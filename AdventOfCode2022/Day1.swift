//
//  Day1.swift
//  adventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day1: Day {
    override func resolveA<T>(_ input: [String]) -> T {
        let processedInput = input.split(separator: "")
        let partials = processedInput.map({ $0.reduce(0, { $0 + Int($1)! }) })
        
        return partials.max(count: 1, sortedBy: <).first! as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        let processedInput = input.split(separator: "")
        let partials = processedInput.map({ $0.reduce(0, { $0 + Int($1)! }) }).max(count: 3, sortedBy: <)
        
        return partials.reduce(0, +) as! V
    }
}
