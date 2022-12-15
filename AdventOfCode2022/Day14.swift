//
//  Day14.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day14: Day {
    private struct Path {
        let points: [Point2D]
    }
    
    override func resolveA<T>(_ input: [String]) -> T {
        let paths = processInput(input)
        let sandStartPoint = Point2D(x: 500, y: 0)
        var blockedPoints = getBlockedPoints(with: paths)
        let bottomY = blockedPoints.map(\.y).max()!
        
        var grainsOfSand = 0
        sandLoop: while true {
            var currentPoint = sandStartPoint
            moveLoop: while true {
                let down = currentPoint.moved(.south)
                let downLeft = down.moved(.west)
                let downRight = down.moved(.east)

                if currentPoint.y > bottomY {
                    break sandLoop
                }
                
                if !blockedPoints.contains(down) {
                    currentPoint = down
                    continue moveLoop
                }
                
                if !blockedPoints.contains(downLeft) {
                    currentPoint = downLeft
                    continue moveLoop
                }
                
                if !blockedPoints.contains(downRight) {
                    currentPoint = downRight
                    continue moveLoop
                }
                
                blockedPoints.insert(currentPoint)
                grainsOfSand += 1
                
                break moveLoop
            }
        }
        
        return grainsOfSand as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        let paths = processInput(input)
        let sandStartPoint = Point2D(x: 500, y: 0)
        var blockedPoints = getBlockedPoints(with: paths)
        let bottomY = blockedPoints.map(\.y).max()!
        let virtualBottomY = bottomY + 2
        
        var grainsOfSand = 0
        sandLoop: while true {
            var currentPoint = sandStartPoint
            moveLoop: while true {
                let down = currentPoint.moved(.south)
                let downLeft = down.moved(.west)
                let downRight = down.moved(.east)
                
                if down.y == virtualBottomY {
                    blockedPoints.insert(currentPoint)
                    grainsOfSand += 1
                    break moveLoop
                }
                
                if !blockedPoints.contains(down) {
                    currentPoint = down
                    continue moveLoop
                }
                
                if !blockedPoints.contains(downLeft), currentPoint.y < virtualBottomY {
                    currentPoint = downLeft
                    continue moveLoop
                }
                
                if !blockedPoints.contains(downRight) {
                    currentPoint = downRight
                    continue moveLoop
                }
                
                blockedPoints.insert(currentPoint)
                grainsOfSand += 1
                if currentPoint == sandStartPoint {
                    break sandLoop
                }
                
                break moveLoop
            }
        }
        
        return grainsOfSand as! V
    }
    
    private func processInput(_ input: [String]) -> [Path] {
        input.dropLast().map { line in
            Path(points: line.components(separatedBy: " -> ").map { components in
                let components = components.components(separatedBy: ",")
                return Point2D(x: Int(components[0])!, y: Int(components[1])!)
            })
        }
    }
    
    private func getBlockedPoints(with paths: [Path]) -> Set<Point2D> {
        var blockedPoints: Set<Point2D> = []
        paths.forEach { path in
            for index in 0 ..< path.points.count - 1 {
                var currentPoint = path.points[index]
                let nextPoint = path.points[index + 1]
                
                blockedPoints.insert(currentPoint)

                while currentPoint != nextPoint {
                    currentPoint.x += sign(nextPoint.x - currentPoint.x)
                    currentPoint.y += sign(nextPoint.y - currentPoint.y)
                    blockedPoints.insert(currentPoint)
                }
            }
        }
        
        return blockedPoints
    }
    
    private func sign(_ value: Int) -> Int {
        if value == 0 {
            return 0
        } else {
            return value < 0 ? -1 : 1
        }
    }
}
