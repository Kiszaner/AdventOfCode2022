//
//  Day8.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day8: Day {
    override func resolveA<T>(_ input: [String]) -> T {
        var heights = [Point2D: Int]()
        
        for (row, line) in input.enumerated() {
            for (column, height) in line.enumerated() {
                let point = Point2D(x: column, y: row)
                heights[point] = Int(String(height))!
            }
        }
        
        var result = 0
        
        for point in heights.keys {
            result += isTreeVisible(at: point, heights: heights) ? 1 : 0
        }
        
        return result as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        var heights = [Point2D: Int]()
        
        for (row, line) in input.enumerated() {
            for (column, height) in line.enumerated() {
                let point = Point2D(x: column, y: row)
                heights[point] = Int(String(height))!
            }
        }
        
        var result = 0
        
        for point in heights.keys {
            result = max(result, scenicScore(at: point, heights: heights))
        }
        
        return result as! V
    }
    
    private func isTreeVisible(at point: Point2D, heights: [Point2D: Int]) -> Bool {
        let treeHeight = heights[point]!
        
    outerloop: for direction in Point2D.Direction.allCases {
        var currentPoint = point.moved(direction)
        
        while let otherTreeHeight = heights[currentPoint] {
            if otherTreeHeight >= treeHeight {
                continue outerloop
            }
            
            currentPoint = currentPoint.moved(direction)
        }
        
        return true
    }
        
        return false
    }
    
    private func scenicScore(at point: Point2D, heights: [Point2D: Int]) -> Int {
        let treeHeight = heights[point]!
        var scenicScore = 1
        
        for direction in Point2D.Direction.allCases {
            var currentPoint = point.moved(direction)
            var visibleDistance = 0
            
            while let otherTreeHeight = heights[currentPoint] {
                visibleDistance += 1
                
                if otherTreeHeight >= treeHeight {
                    break
                }
                
                currentPoint = currentPoint.moved(direction)
            }
            
            scenicScore *= visibleDistance
        }
        
        return scenicScore
    }
}
