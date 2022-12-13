//
//  Day12.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day12: Day {
    struct Grid: BFSGrid {
        let heightMap: [Point2D: Int]
        
        func getReachableNeighborsAt(position: Point2D) -> [Point2D] {
            let currentHeight = heightMap[position]!
            
            return position.neighbors().filter { point in
                guard let neighborHeight = heightMap[point], neighborHeight <= currentHeight + 1 else {
                    return false
                }
                
                return true
            }
        }
    }
    
    override func resolveA<T>(_ input: [String]) -> T {
        let processedInput = parseInput(input)
        let bfsGrid = Grid(heightMap: processedInput.heightMap)
        let result = BFS.getShortestPathInGrid(bfsGrid, from: processedInput.start, to: processedInput.end)!.steps
        
        return result as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        let processedInput = parseInput(input)
        let bfsGrid = Grid(heightMap: processedInput.heightMap)
        let allZeroHeightPoints = processedInput.heightMap.filter { $0.value == 0 }
        var result = Int.max
        
        allZeroHeightPoints.keys.forEach { startPoint in
            if let steps = BFS.getShortestPathInGrid(bfsGrid, from: startPoint, to: processedInput.end)?.steps {
                result = min(result, steps)
            }
        }
        
        return result as! V
    }
    
    private func parseInput(_ input: [String]) -> (start: Point2D, end: Point2D, heightMap: [Point2D: Int]) {
        var start: Point2D = .zero
        var end: Point2D = .zero
        var heightMap: [Point2D: Int] = [:]
        
        for (y, line) in input.enumerated() {
            for (x, value) in line.enumerated() {
                let point = Point2D(x: x, y: y)
                switch value {
                case "S":
                    start = point
                    heightMap[point] = 0
                case "E":
                    end = point
                    heightMap[point] = 25
                default:
                    heightMap[point] = Int(value.asciiValue! - UInt8.a)
                }
            }
        }
        
        return (start: start, end: end, heightMap: heightMap)
    }
}

private extension UInt8 {
    static let a: UInt8 = 97 // 97 is character "a" in Ascii
}
