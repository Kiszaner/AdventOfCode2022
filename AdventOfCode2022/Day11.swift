//
//  Day11.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day11: Day {
    struct Monkey {
        var items: [Int]
        let operation: Operation
        let test: Test
        
        enum Operation {
            case add(value: Int?)
            case mul(value: Int?)
        }
        
        struct Test {
            let divisible: Int
            let trueMonkeyIndex: Int
            let falseMonkeyIndex: Int
        }
    }
    
    override func resolveA<T>(_ input: [String]) -> T {
        var monkeys = processInput(input)
        var inspectionCounter: [Int: Int] = [:]
        
        let rounds = 20
        for _ in 0 ..< rounds {
            for index in 0 ..< monkeys.count {
                var monkey = monkeys[index]
                for item in monkey.items {
                    inspectionCounter[index, default: 0] += 1
                    var worryLevel = item
                    switch monkey.operation {
                    case .add(let value):
                        worryLevel += value ?? worryLevel
                    case .mul(let value):
                        worryLevel *= value ?? worryLevel
                    }
                    
                    worryLevel /= 3
                    
                    if (worryLevel % monkey.test.divisible) == 0 {
                        monkeys[monkey.test.trueMonkeyIndex].items.append(worryLevel)
                    } else {
                        monkeys[monkey.test.falseMonkeyIndex].items.append(worryLevel)
                    }
                }
                
                monkey.items.removeAll()
                monkeys[index] = monkey
            }
        }
        
        let result = inspectionCounter.values.sorted().suffix(2).reduce(1, *)
        
        return result as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        var monkeys = processInput(input)
        var inspectionCounter: [Int: Int] = [:]
        let commonDivisor = leastCommonMultiplier(for: monkeys.map(\.test.divisible))
        
        let rounds = 10000
        for _ in 0 ..< rounds {
            for index in 0 ..< monkeys.count {
                var monkey = monkeys[index]
                for item in monkey.items {
                    inspectionCounter[index, default: 0] += 1
                    var worryLevel = item
                    
                    switch monkey.operation {
                    case .add(let value):
                        worryLevel += value ?? worryLevel
                    case .mul(let value):
                        worryLevel *= value ?? worryLevel
                    }
                    
                    worryLevel %= commonDivisor
                    
                    if (worryLevel % monkey.test.divisible) == 0 {
                        monkeys[monkey.test.trueMonkeyIndex].items.append(worryLevel)
                    } else {
                        monkeys[monkey.test.falseMonkeyIndex].items.append(worryLevel)
                    }
                }
                
                monkey.items.removeAll()
                monkeys[index] = monkey
            }
        }
        
        let result = inspectionCounter.values.sorted().suffix(2).reduce(1, *)
        
        return result as! V
    }
    
    private func processInput(_ input: [String]) -> [Monkey] {
        var monkeys: [Monkey] = []
        let processedInput = input.filter({ !$0.isEmpty })
        let numberOfMonkeys = processedInput.count / 6
        
        for index in 0 ..< numberOfMonkeys {
            let monkeyLines = Array(processedInput[(index * 6) ..< ((index + 1) * 6)])
            let startingItems = monkeyLines[1].components(separatedBy: ": ")[1].components(separatedBy: ", ").map { Int($0)! }
            let operand = monkeyLines[2].components(separatedBy: " ")[7]
            let operation: Monkey.Operation
            
            switch monkeyLines[2].components(separatedBy: " ")[6] {
            case "+":
                operation = .add(value: Int(operand))
            case "*":
                operation = .mul(value: Int(operand))
            default:
                fatalError("Not an expected operation")
            }
            
            let test = Monkey.Test(
                divisible: Int(monkeyLines[3].components(separatedBy: " ")[5])!,
                trueMonkeyIndex: Int(monkeyLines[4].components(separatedBy: " ")[9])!,
                falseMonkeyIndex: Int(monkeyLines[5].components(separatedBy: " ")[9])!
            )
            
            monkeys.append(Monkey(items: startingItems, operation: operation, test: test))
        }
        
        return monkeys
    }
}
