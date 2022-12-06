//
//  Day6.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day6: Day {
    override func resolveA<T>(_ input: [String]) -> T {
        let processedInput = input.first!
        let result = getCharaterPosition(from: processedInput, ofCount: 4)
        return result as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        let processedInput = input.first!
        let result = getCharaterPosition(from: processedInput, ofCount: 14)
        return result as! V
    }
    
    private func getCharaterPosition(from input: String, ofCount count: Int) -> Int {
        let windows = input.windows(ofCount: count).map({ Set($0) })
        let resultIndex = windows.firstIndex(where: { $0.count == count })!
        let result = windows.distance(from: windows.startIndex, to: resultIndex) + count // count is the offset from the window start to end
        return result
    }
}
