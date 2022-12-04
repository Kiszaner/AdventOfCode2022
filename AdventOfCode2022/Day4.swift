//
//  Day4.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day4: Day {
    override func resolveA<T>(_ input: [String]) -> T {
        let processedInput = input.dropLast().map({ $0.split(separator: ",") }).map { sectionPairs in
            sectionPairs.map { sections in
                let sectionsEnds = sections.split(separator: "-").map({Int($0)!})
                let sectionRange = sectionsEnds.first!...sectionsEnds.last!
                return sectionRange
            }
        }
        let result = processedInput.map {
            return $0.first!.contains($0.last!) || $0.last!.contains($0.first!)
        }.filter({ $0 }).count
        
        return result as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        let processedInput = input.dropLast().map({ $0.split(separator: ",") }).map { sectionPairs in
            sectionPairs.map { sections in
                let sectionsEnds = sections.split(separator: "-").map({Int($0)!})
                let sectionRange = sectionsEnds.first!...sectionsEnds.last!
                return sectionRange
            }
        }
        let result = processedInput.map({ $0.first!.overlaps($0.last!) }).filter({ $0 }).count
        
        return result as! V
    }
}
