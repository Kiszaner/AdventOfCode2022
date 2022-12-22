//
//  Day20.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day20: Day {
    typealias EncryptedFile = [(value: Int, id: Int)]
    
    override func resolveA<T>(_ input: [String]) -> T {
        let encryptedFile = input.dropLast().compactMap(Int.init).enumerated().map { (value: $0.element, id: $0.offset) }
        let decryptedFile = mix(encryptedFile).map(\.value)
        let indexOfZero = decryptedFile.firstIndex(of: 0)!
        let coords = [1000, 2000, 3000].map {
            decryptedFile[(indexOfZero + $0) % decryptedFile.count]
        }
        
        let result = coords.reduce(0, +)
        
        return result as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        let decryptionKey = 811589153
        var decryptedNumbers = input.dropLast().compactMap(Int.init).enumerated().map { (value: $0.element * decryptionKey, id: $0.offset) }
        for _ in 1 ... 10 {
            decryptedNumbers = mix(decryptedNumbers)
        }
        let decryptedFile = decryptedNumbers.map(\.value)
        let indexOfZero = decryptedFile.firstIndex(of: 0)!
        let coords = [1000, 2000, 3000].map {
            decryptedFile[(indexOfZero + $0) % decryptedFile.count]
        }
        
        let result = coords.reduce(0, +)
        
        return result as! V
    }
    
    func mix(_ encryptedFile: EncryptedFile) -> EncryptedFile {
        let count = encryptedFile.count - 1
        var decryptedFile = encryptedFile
        for id in encryptedFile.indices {
            let index = decryptedFile.firstIndex(where: { $0.id == id })!
            let number = decryptedFile[index]
            var newIndex = (index + number.value) % count
            if newIndex < 0 {
                newIndex = count + newIndex
            }
            if newIndex == 0 {
                newIndex = count
            }
            guard newIndex != index else { continue }
            decryptedFile.remove(at: index)
            decryptedFile.insert(number, at: newIndex)
        }
        return decryptedFile
    }
}
