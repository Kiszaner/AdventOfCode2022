//
//  Helpers.swift
//  adventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

func getInputsFileUrl(name: String) -> URL {
    let directory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/Support Files")
    let fileUrl = URL(filePath: name, relativeTo: directory)
    return fileUrl
}

func getStringsFrom(_ url: URL, separatedBy separator: String = "\n") -> [String] {
    let rawString = try? String(contentsOf: url, encoding: .utf8)
    return rawString?.components(separatedBy: separator) ?? []
}

func getStringsFrom<T: Decodable>(_ url: URL) -> [T] {
    let data = try! Data(contentsOf: url)
    return try! JSONDecoder().decode([T].self, from: data)
}

class Day {
    let fileUrl: URL
    
    init(fileUrl: URL) {
        self.fileUrl = fileUrl
    }
    
    func resolve<T, V>(input: [String]) -> (T, V) {
        let resultA: T = resolveA(input)
        let resultB: V = resolveB(input)
        return (resultA, resultB)
    }
    
    open func resolveA<T>(_ input: [String]) -> T {
        fatalError("Method must be implemented by child class")
    }
    
    open func resolveB<V>(_ input: [String]) -> V {
        fatalError("Method must be implemented by child class")
    }
}

public struct Point2D: Hashable, Equatable, AdditiveArithmetic {
    public enum Direction: CaseIterable {
        case north, east, south, west
    }
    
    public static var zero: Point2D {
        Point2D(x: 0, y: 0)
    }
    
    public var x: Int
    public var y: Int
    
    public init(x: Int = 0, y: Int = 0) {
        self.x = x
        self.y = y
    }
    
    public func moved(_ direction: Direction) -> Point2D {
        switch direction {
        case .north:
            return self + Point2D(x: 0, y: -1)
        case .east:
            return self + Point2D(x: 1, y: 0)
        case .south:
            return self + Point2D(x: 0, y: 1)
        case .west:
            return self + Point2D(x: -1, y: 0)
        }
    }
    
    public static func + (lhs: Point2D, rhs: Point2D) -> Point2D {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func - (lhs: Point2D, rhs: Point2D) -> Point2D {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public static func += (lhs: inout Point2D, rhs: Point2D) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    
    public static func -= (lhs: inout Point2D, rhs: Point2D) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
}
