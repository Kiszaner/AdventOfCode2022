//
//  Day13.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day13: Day {
    override func resolveA<T>(_ input: [String]) -> T {
        let processedInput = processInput(input)
        let count = processedInput.map { Packet.compare(lhs: $0.lhs, rhs: $0.rhs) }
            .enumerated()
            .map { index, result in
                result == .orderedAscending ? index + 1 : 0
            }
            .reduce(0, +)
        
        return count as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        let dividerPackets = ["[[2]]", "[[6]]"].map {
            var line = Array($0)[...]
            return Packet(&line)
        }
        let packets = input.compactMap { line -> Packet? in
            guard !line.isEmpty else { return nil }
            var line = Array(line)[...]
            return Packet(&line)
        }
        let sorted = (packets + dividerPackets).sorted { lhs, rhs in
            return Packet.compare(lhs: lhs, rhs: rhs) == .orderedAscending
        }
        let start = sorted.firstIndex(of: dividerPackets[0])! + 1
        let end = sorted.firstIndex(of: dividerPackets[1])! + 1
        
        return (start * end) as! V
    }
    
    private func processInput(_ input: [String]) -> [Pair] {
        input.split(separator: "").map({ Pair(lines: $0) })
    }
}

enum Packet: Equatable {
    case number(Int)
    indirect case list([Packet])

    init(_ input: inout ArraySlice<Character>) {
        var packets = [Packet]()
        var chars = [Character]()
        while let char = input.popFirst() {
            switch char {
            case "[":
                packets.append(.init(&input))
                break
            case "]":
                if chars.isEmpty == false {
                    let value = Int(String(chars))!
                    packets.append(.number(value))
                }
                self = .list(packets)
                return
            case ",":
                if !chars.isEmpty {
                    let value = Int(String(chars))!
                    chars = []
                    packets.append(.number(value))
                }
                break
            default:
                chars.append(char)
                break
            }
        }
        self = .list(packets)
    }
}

struct Pair {
    let lhs: Packet
    let rhs: Packet

    init(lines: ArraySlice<String>) {
        var line = Array(lines.first!)[...]
        self.lhs = Packet(&line)
        line = Array(lines.last!)[...]
        self.rhs = Packet(&line)
    }
}

extension Packet {
    static func compare(lhs: Self, rhs: Self) -> ComparisonResult {
        switch (lhs, rhs) {
        case let (.number(left), .number(right)):
            return left < right ? .orderedAscending : left > right ? .orderedDescending : .orderedSame
        case let (.number, .list(right)):
            return compare(lhs: [lhs], rhs: right)
        case let (.list(left), .number):
            return compare(lhs: left, rhs: [rhs])
        case let (.list(left), .list(right)):
            return compare(lhs: left, rhs: right)
        }
    }

    private static func compare(lhs: [Packet], rhs: [Packet]) -> ComparisonResult {
        for (index, packet) in lhs.enumerated() {
            guard index < rhs.count else {
                return .orderedDescending
            }
            let result = compare(lhs: packet, rhs: rhs[index])
            if result == .orderedSame {
                continue
            } else {
                return result
            }
        }
        return lhs.count == rhs.count ? .orderedSame : .orderedAscending
    }
}
