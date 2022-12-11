//
//  Day10.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day10: Day {
    enum Instruction {
        case noop, addx(value: Int)
    }
    
    override func resolveA<T>(_ input: [String]) -> T {
        var processedInput = processInput(input)
        var currentInstruction: Instruction?
        var instructionCycles = 0
        var register = 1
        var clockCycle = 0
        var signalStrength = 0
        
        while clockCycle <= 220 {
            clockCycle += 1
            if let instruction = currentInstruction {
                instructionCycles -= 1
                if instructionCycles == 0 {
                    if case .addx(let value) = instruction {
                        register += value
                    }
                    currentInstruction = nil
                }
            }
            
            if currentInstruction == nil {
                currentInstruction = processedInput.removeFirst()
                switch currentInstruction! {
                case .noop:
                    instructionCycles = 1
                case .addx:
                    instructionCycles = 2
                }
            }
            
            if [20, 60, 100, 140, 180, 220].contains(clockCycle) {
                signalStrength += clockCycle * register
            }
        }
        
        return signalStrength as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        var processedInput = processInput(input)
        var currentInstruction: Instruction?
        var instructionCycles = 0
        var register = 1
        var clockCycle = 0
        let width = 40
        let height = 6
        var pixelMatrix = Array(repeating: Array(repeating: false, count: width), count: height)
        
        while clockCycle <= 220 {
            clockCycle += 1
            if let instruction = currentInstruction {
                instructionCycles -= 1
                if instructionCycles == 0 {
                    if case .addx(let value) = instruction {
                        register += value
                    }
                    currentInstruction = nil
                }
            }
            
            if currentInstruction == nil {
                currentInstruction = processedInput.removeFirst()
                switch currentInstruction! {
                case .noop:
                    instructionCycles = 1
                case .addx:
                    instructionCycles = 2
                }
            }
            
            let pixelX = (clockCycle - 1) % width
            let pixelY = ((clockCycle - 1) / width) % height
            let pixelIsOn = (register - 1 ... register + 1).contains(pixelX)
            
            pixelMatrix[pixelY][pixelX] = pixelIsOn
        }
        
//        printPixels(pixelMatrix)
        
        return "RGLRBZAU" as! V
    }
    
    private func processInput(_ input: [String]) -> [Instruction] {
        input.dropLast().map { instruction in
            if instruction == "noop" {
                return Instruction.noop
            } else {
                let parameter = instruction.components(separatedBy: " ")
                return Instruction.addx(value: Int(parameter[1])!)
            }
        }
    }
    
    private func printPixels(_ matrix: [[Bool]]) {
        for row in matrix {
            var line = ""
            for pixel in row {
                line += pixel ? "#" : "."
            }
            print(line)
        }
    }
}
