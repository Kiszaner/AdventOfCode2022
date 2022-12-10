//
//  Day9.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day9: Day {
    struct Motion {
        let direction: Point2D.Direction
        let steps: Int
    }
    
    override func resolveA<T>(_ input: [String]) -> T {
        let processedInput = processInput(input)
        var result: Set<Point2D> = []
        
        var currentHead = Point2D()
        var currentTail = Point2D()
        
        processedInput.forEach { motion in
            for _ in 0 ..< motion.steps {
                currentHead = currentHead.moved(motion.direction)
                currentTail = knotMovement(at: currentTail, head: currentHead)
                result.insert(currentTail)
            }
        }
        
        return result.count as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        let processedInput = processInput(input)
        var result: Set<Point2D> = []
        
        var currentHead = Point2D()
        var allTails: [Point2D] = Array(repeating: .zero, count: 9)
        
        processedInput.forEach { motion in
            for _ in 0 ..< motion.steps {
                currentHead = currentHead.moved(motion.direction)
                for tailIndex in 0 ..< allTails.count {
                    var temporalTail = allTails[tailIndex]
                    let temporalHead = allTails.getElement(at: tailIndex - 1) ?? currentHead
                    temporalTail = knotMovement(at: temporalTail, head: temporalHead)
                    allTails[tailIndex] = temporalTail
                }
                result.insert(allTails.last!)
            }
        }
        
        return result.count as! V
    }
    
    private func processInput(_ input: [String]) -> [Motion] {
        return input.dropLast().map { entry in
            let components = entry.components(separatedBy: " ")
            let repetitions = Int(components[1])!
            switch components[0] {
            case "U":
                return Motion(direction: .north, steps: repetitions)
            case "R":
                return Motion(direction: .east, steps: repetitions)
            case "D":
                return Motion(direction: .south, steps: repetitions)
            case "L":
                return Motion(direction: .west, steps: repetitions)
            default:
                fatalError("Not a motion")
            }
        }
    }
    
    private func knotMovement(at origin: Point2D, head: Point2D) -> Point2D {
        var nextKnotPoint = origin
        
        if abs(head.x - origin.x) >= 2 || abs(head.y - origin.y) >= 2 {
            if head.x != origin.x {
                nextKnotPoint.x += head.x > origin.x ? 1 : -1
            }
            
            if head.y != origin.y {
                nextKnotPoint.y += head.y > origin.y ? 1 : -1
            }
        }
        return nextKnotPoint
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
