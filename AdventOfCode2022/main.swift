//
//  main.swift
//  adventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation
import Algorithms


// MARK: - Advent of Code 2022
// MARK: Day 1

let day1 = Day1(fileUrl: getInputsFileUrl(name: "Day1"))
let result1: (Int, Int) = day1.resolve(input: getStringsFrom(day1.fileUrl))
print("Day 1: \(result1)")

