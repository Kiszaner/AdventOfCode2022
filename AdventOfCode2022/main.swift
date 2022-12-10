//
//  main.swift
//  adventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation
import Algorithms


// MARK: - Advent of Code 2022
// MARK: - Day 1

let day1 = Day1(fileUrl: getInputsFileUrl(name: "Day1"))
let result1: (Int, Int) = day1.resolve(input: getStringsFrom(day1.fileUrl))
print("Day 1: \(result1)")

// MARK: - Day 2

let day2 = Day2(fileUrl: getInputsFileUrl(name: "Day2"))
let result2: (Int, Int) = day2.resolve(input: getStringsFrom(day2.fileUrl))
print("Day 2: \(result2)")

// MARK: - Day 3

let day3 = Day3(fileUrl: getInputsFileUrl(name: "Day3"))
let result3: (Int, Int) = day3.resolve(input: getStringsFrom(day3.fileUrl))
print("Day 3: \(result3)")

// MARK: - Day 4

let day4 = Day4(fileUrl: getInputsFileUrl(name: "Day4"))
let result4: (Int, Int) = day4.resolve(input: getStringsFrom(day4.fileUrl))
print("Day 4: \(result4)")

// MARK: - Day 6

let day6 = Day6(fileUrl: getInputsFileUrl(name: "Day6"))
let result6: (Int, Int) = day6.resolve(input: getStringsFrom(day6.fileUrl))
print("Day 6: \(result6)")

// MARK: - Day 7

let day7 = Day7(fileUrl: getInputsFileUrl(name: "Day7"))
let result7: (Int, Int) = day7.resolve(input: getStringsFrom(day7.fileUrl))
print("Day 7: \(result7)")

let day8 = Day8(fileUrl: getInputsFileUrl(name: "Day8"))
let result8: (Int, Int) = day8.resolve(input: getStringsFrom(day8.fileUrl))
print("Day 8: \(result8)")

// MARK: - Day 9

let day9 = Day9(fileUrl: getInputsFileUrl(name: "Day9"))
let result9: (Int, Int) = day9.resolve(input: getStringsFrom(day9.fileUrl))
print("Day 9: \(result9)")
