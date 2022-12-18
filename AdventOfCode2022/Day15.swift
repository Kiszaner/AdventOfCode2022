//
//  Day15.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day15: Day {
    private struct Sensor {
        let position: Point2D
        let closestBeaconPosition: Point2D
        
        var manhattanDistance: Int {
            position.manhattanDistance(from: closestBeaconPosition)
        }
        
        init(position: Point2D, closestBeaconPosition: Point2D) {
            self.position = position
            self.closestBeaconPosition = closestBeaconPosition
        }
        
        func xBoundariesForY(_ y: Int) -> ClosedRange<Int>? {
            let yOffset = abs(y - position.y)

            guard yOffset <= manhattanDistance else {
                return nil
            }
            
            let xDistance = manhattanDistance - yOffset
            
            return (position.x - xDistance) ... (position.x + xDistance)
        }
    }
    
    override func resolveA<T>(_ input: [String]) -> T {
        let sensors = processInput(input)
        let inspectY = 2_000_000
        let mergedBoundaries = mergedBoundariesForY(inspectY, sensors: sensors)
        let result = mergedBoundaries.map { $0.upperBound - $0.lowerBound }.reduce(0, +)
        
        return result as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        let sensors = processInput(input)
        let maxCoordinate = 4_000_000
        var result = 0
        
        for inspectY in 0 ... maxCoordinate {
            let mergedBoundaries = mergedBoundariesForY(inspectY, sensors: sensors)
            
            if mergedBoundaries.count > 1 {
                result = ((mergedBoundaries.first!.upperBound + 1) * 4_000_000) + inspectY
                return result as! V
            }
        }
        
        return result as! V
    }
    
    private func processInput(_ input: [String]) -> [Sensor] {
        input.dropLast().map { line in
            let parts = line.components(separatedBy: " ")
            var value = String(parts[2].dropFirst(2).dropLast())
            var x = Int(value)!
            value = String(parts[3].dropFirst(2).dropLast())
            var y = Int(value)!
            let sensorPos = Point2D(x: x, y: y)
            value = String(parts[8].dropFirst(2).dropLast())
            x = Int(value)!
            value = String(parts[9].dropFirst(2))
            y = Int(value)!
            let beaconPos = Point2D(x: x, y: y)
            return Sensor(position: sensorPos, closestBeaconPosition: beaconPos)
        }
    }
    
    private func mergedBoundariesForY(_ y: Int, sensors: [Sensor]) -> [ClosedRange<Int>] {
        let boundaries = sensors.compactMap { $0.xBoundariesForY(y) }.sorted(by: { $0.lowerBound < $1.lowerBound })
        var mergedBoundaries: [ClosedRange<Int>] = []
        var index = 0
        while var currentBoundary = boundaries.getElement(at: index) {
            while true {
                index += 1
                guard let nextBoundary = boundaries.getElement(at: index),
                      currentBoundary.overlaps(nextBoundary.lowerBound - 1 ... nextBoundary.upperBound) else { break }
                currentBoundary = currentBoundary.lowerBound ... max(nextBoundary.upperBound, currentBoundary.upperBound)
            }
            
            mergedBoundaries.append(currentBoundary)
        }
        
        return mergedBoundaries
    }
}

private extension Array {
    func getElement(at index: Index) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
