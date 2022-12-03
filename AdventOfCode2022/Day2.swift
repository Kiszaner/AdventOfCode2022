//
//  Day2.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day2: Day {
    enum OponentPlays: Character {
        case rock = "A", paper = "B", scissor = "C"
    }
    
    enum GuidePlays: Character {
        case rock = "X", paper = "Y", scissor = "Z"
        
        func value() -> Int {
            switch self {
            case .rock:
                return 1
            case .paper:
                return 2
            case .scissor:
                return 3
            }
        }
    }
    
    enum RoundResult: Character {
        case lose = "X", draw = "Y", win = "Z"
        
        func value() -> Int {
            switch self {
            case .lose:
                return 0
            case .draw:
                return 3
            case .win:
                return 6
            }
        }
    }
    
    override func resolveA<T>(_ input: [String]) -> T {
        var oponentPlays = [OponentPlays]()
        var guidePlays = [GuidePlays]()
        input.dropLast().forEach { round in
            oponentPlays.append(OponentPlays(rawValue: round.first!)!)
            guidePlays.append(GuidePlays(rawValue: round.last!)!)
        }
        var result = 0
        for (oponent, guide) in zip(oponentPlays, guidePlays) {
            let roundScore: Int
            switch (oponent, guide) {
            case (.rock, .rock):
                roundScore = 3 + guide.value()
            case (.rock, .paper):
                roundScore = 6 + guide.value()
            case (.rock, .scissor):
                roundScore = 0 + guide.value()
            case (.paper, .rock):
                roundScore = 0 + guide.value()
            case (.paper, .paper):
                roundScore = 3 + guide.value()
            case (.paper, .scissor):
                roundScore = 6 + guide.value()
            case (.scissor, .rock):
                roundScore = 6 + guide.value()
            case (.scissor, .paper):
                roundScore = 0 + guide.value()
            case (.scissor, .scissor):
                roundScore = 3 + guide.value()
            }
            result += roundScore
        }
        
        return result as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        var oponentPlays = [OponentPlays]()
        var roundResults = [RoundResult]()
        input.dropLast().forEach { round in
            oponentPlays.append(OponentPlays(rawValue: round.first!)!)
            roundResults.append(RoundResult(rawValue: round.last!)!)
        }
        var result = 0
        for (oponent, round) in zip(oponentPlays, roundResults) {
            let roundScore: Int
            switch (oponent, round) {
            case (.rock, .lose):
                roundScore = 3 + round.value()
            case (.paper, .lose):
                roundScore = 1 + round.value()
            case (.scissor, .lose):
                roundScore = 2 + round.value()
            case (.rock, .draw):
                roundScore = 1 + round.value()
            case (.paper, .draw):
                roundScore = 2 + round.value()
            case (.scissor, .draw):
                roundScore = 3 + round.value()
            case (.rock, .win):
                roundScore = 2 + round.value()
            case (.paper, .win):
                roundScore = 3 + round.value()
            case (.scissor, .win):
                roundScore = 1 + round.value()
            }
            result += roundScore
        }
        
        return result as! V
    }
}
