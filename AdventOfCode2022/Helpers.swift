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