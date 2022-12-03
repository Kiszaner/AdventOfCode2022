//
//  Day3.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day3: Day {
    override func resolveA<T>(_ input: [String]) -> T {
        let processedInput = input.dropLast().map { rucksack in
            let middleIndex = rucksack.index(rucksack.startIndex, offsetBy: rucksack.count / 2)
            let firstHalf = Set(rucksack[..<middleIndex])
            let secondHalf = Set(rucksack[middleIndex..<rucksack.endIndex])
            return firstHalf.intersection(secondHalf).first! as Character
        }
        let result = processedInput.reduce(0, { $0 + $1.letterValue! })
        return result as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        let processedInput = input.dropLast().chunks(ofCount: 3).map({ $0.map({ Set($0) }) })
        let result = processedInput
            .map({ $0.reduce($0.first!, { $0.intersection($1) }) })
            .flatMap({ $0 })
            .reduce(0, { $0 + $1.letterValue! })
        return result as! V
    }
}

// MARK: - Extensions

private extension Character {
    static let alphabet = "abcdefghijklmnopqrstuvwxyz"
    static let lowerCaseAlphabetValue = zip(alphabet, 1...26).reduce(into: [:]) { $0[$1.0] = $1.1 }
    static let upperCaseAlphabetValue = zip(alphabet.uppercased(), 27...52).reduce(into: [:]) { $0[$1.0] = $1.1 }
    var letterValue: Int? {
        switch self {
        case "a"..."z":
            return Self.lowerCaseAlphabetValue[self]
        case "A"..."Z":
            return Self.upperCaseAlphabetValue[self]
        default:
            return nil
        }
    }
}
