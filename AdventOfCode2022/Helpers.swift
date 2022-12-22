//
//  Helpers.swift
//  adventOfCode2022
//
//  Created by Kiszaner.
//

import Collections
import Foundation

// MARK: - Parsing

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

// MARK: - Common classes

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

// MARK: - Maps & Geometry

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
    
    public func neighbors() -> [Point2D] {
        return [
            moved(.north),
            moved(.east),
            moved(.south),
            moved(.west)
        ]
    }
    
    public func manhattanDistance(from rhs: Point2D) -> Int {
        let difference = rhs - self
        
        return abs(difference.x) + abs(difference.y)
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

public struct Point3D: Hashable, Equatable, AdditiveArithmetic {
    public var x: Int = 0
    public var y: Int = 0
    public var z: Int = 0
    
    public static var zero: Point3D {
        Point3D(x: 0, y: 0, z: 0)
    }
    
    public init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(string: String) {
        let components = string.components(separatedBy: ",")
        
        x = Int(components[0])!
        y = Int(components[1])!
        z = Int(components[2])!
    }
    
    public func manhattanDistance(from rhs: Point3D) -> Int {
        let difference = rhs - self
        
        return abs(difference.x) + abs(difference.y) + abs(difference.z)
    }
    
    public func neighbors() -> [Point3D] {
        [
            Point3D(x: x - 1, y: y, z: z),
            Point3D(x: x + 1, y: y, z: z),
            Point3D(x: x, y: y - 1, z: z),
            Point3D(x: x, y: y + 1, z: z),
            Point3D(x: x, y: y, z: z - 1),
            Point3D(x: x, y: y, z: z + 1)
        ]
    }
    
    public static func + (lhs: Point3D, rhs: Point3D) -> Point3D {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    public static func - (lhs: Point3D, rhs: Point3D) -> Point3D {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    
    public static func * (lhs: Point3D, rhs: Point3D) -> Point3D {
        .init(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
    }
    
    public static func += (lhs: inout Point3D, rhs: Point3D) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }
    
    public static func -= (lhs: inout Point3D, rhs: Point3D) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
    }
    
    public static func *= (lhs: inout Point3D, rhs: Point3D) {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
        lhs.z *= rhs.z
    }
}

// MARK: Shortest path in grid from A to B

public protocol BFSGrid {
    func getReachableNeighborsAt(position: Point2D) -> [Point2D]
}

// Breadth-first search
public enum BFS {
    struct ShortestPathInGridResult {
        /// The full path from point A to point B.
        public let path: [Point2D]
        
        /// The total number of steps required to get from point A to point B in the grid.
        public let steps: Int
    }
    
    private struct ShortestPathInGrid {
        let position: Point2D
        let visitedPoints: [Point2D]
        let steps: Int
    }
    
    /// Tries to find the shortest path in a grid from point A to B.
    /// - Parameters:
    ///   - grid: The grid to find the path in.
    ///   - pointA: Starting point in the grid. Should be an accessible grid point.
    ///   - pointB: End point in the grid. Should be an accessible grid point.
    /// - Returns: The solution when available.
    static func getShortestPathInGrid(_ grid: BFSGrid, from pointA: Point2D, to pointB: Point2D) -> ShortestPathInGridResult? {
        var solutionQueue: Deque<ShortestPathInGrid> = [ShortestPathInGrid(position: pointA, visitedPoints: [pointA], steps: 0)]
        var bestSolution: ShortestPathInGrid?
        var visitedPoints: Set<Point2D> = [pointA]
        
        while let solution = solutionQueue.popFirst()  {
            if solution.position == pointB {
                bestSolution = solution
                break
            }
            
            let possiblePoints = grid.getReachableNeighborsAt(position: solution.position)
            for nextPoint in possiblePoints where visitedPoints.contains(nextPoint) == false {
                visitedPoints.insert(nextPoint)
                solutionQueue.append(
                    ShortestPathInGrid(
                        position: nextPoint,
                        visitedPoints: solution.visitedPoints + [nextPoint],
                        steps: solution.steps + 1
                    )
                )
            }
        }
        
        guard let bestSolution else {
            return nil
        }
        
        return ShortestPathInGridResult(path: bestSolution.visitedPoints, steps: bestSolution.steps)
    }
}

// MARK: - Maths

public func greatestCommonFactor(_ x: Int, _ y: Int) -> Int {
    var a = 0
    var b = max(x, y)
    var r = min(x, y)
    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    
    return b
}

public func leastCommonMultiplier(for a: Int, and b: Int) -> Int {
    return a / greatestCommonFactor(a, b) * b
}

public func leastCommonMultiplier(for values: [Int]) -> Int {
    let uniqueValues = Array(Set(values))
    guard uniqueValues.count >= 2 else {
        return uniqueValues.first ?? 0
    }

    var currentLCM = leastCommonMultiplier(for: uniqueValues[0], and: uniqueValues[1])
    for value in uniqueValues[2 ..< uniqueValues.count] {
        currentLCM = leastCommonMultiplier(for: currentLCM, and: value)
    }

    return currentLCM
}
