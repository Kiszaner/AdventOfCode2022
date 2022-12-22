//
//  Day18.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Collections
import Foundation

class Day18: Day {
    override func resolveA<T>(_ input: [String]) -> T {
        let processedInput = Set(input.dropLast().map({ Point3D(string: $0) }))
        var result = 0
        
        processedInput.forEach { point in
            point.neighbors().forEach { neighbor in
                result += processedInput.contains(neighbor) ? 0 : 1
            }
        }
        
        return result as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        let processedInput = Set(input.dropLast().map({ Point3D(string: $0) }))
        
        let minX = processedInput.map(\.x).min()! - 1
        let maxX = processedInput.map(\.x).max()! + 1
        let minY = processedInput.map(\.y).min()! - 1
        let maxY = processedInput.map(\.y).max()! + 1
        let minZ = processedInput.map(\.z).min()! - 1
        let maxZ = processedInput.map(\.z).max()! + 1
        
        let startPoint = Point3D(x: minX, y: minY, z: minZ)
        var visitedNodes: Set<Point3D> = [startPoint]
        var queue: Deque<Point3D> = [startPoint]
        var result = 0
        
        while let node = queue.popFirst() {
            for neighbor in node.neighbors() {
                if processedInput.contains(neighbor) {
                    result += 1
                }
                
                guard
                    visitedNodes.contains(neighbor) == false,
                    (minX ... maxX).contains(neighbor.x),
                    (minY ... maxY).contains(neighbor.y),
                    (minZ ... maxZ).contains(neighbor.z),
                    processedInput.contains(neighbor) == false
                else {
                    continue
                }
                
                queue.append(neighbor)
                
                visitedNodes.insert(neighbor)
            }
        }
        
        return result as! V
    }
}
