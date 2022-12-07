//
//  Day7.swift
//  AdventOfCode2022
//
//  Created by Kiszaner.
//

import Foundation

class Day7: Day {
    enum Command {
        case cd, ls
    }

    private var pwds = [String]()
    private var folders = [String: Folder]()
    private var inputs = [String]()
    private let diskSize = 70000000
    private let updateSize = 30000000
    private var usedSpace = 0
    
    override func resolveA<T>(_ input: [String]) -> T {
        inputs = input
        folders["/"] = Folder(name: "/")
        
        var nextInput: String
        repeat {
            nextInput = inputs.first!
            let splittedInput = nextInput.split(separator: " ")
            if splittedInput.count == 0 {
                break
            }
            var parameter: String?
            if splittedInput.count > 2 {
                 parameter = String(splittedInput[2])
            }
            let command = String(splittedInput[1])
            processNextCommand(command, parameter: parameter)
        } while nextInput != ""
        
        let result = folders.map({ $0.value.getSize() })
        let finalResult = result.filter({ $0 <= 100000 }).reduce(0, +)
        
        return finalResult as! T
    }
    
    override func resolveB<V>(_ input: [String]) -> V {
        let usedSpace = folders["/"]!.getSize()
        let freeSpace = diskSize - usedSpace
        let requiredSpace = updateSize - freeSpace
        
        let result = folders.map({ $0.value.getSize() }).filter({ $0 >= requiredSpace }).min()!
        
        return result as! V
    }
    
    private func processNextCommand(_ command: String, parameter: String?) {
        switch command {
        case "cd":
            executeCommand(.cd, parameter: parameter)
        case "ls":
            executeCommand(.ls, parameter: nil)
        default:
            fatalError("Commands are wrongly mapped")
        }
    }
    
    private func executeCommand(_ command: Command, parameter: String?) {
        inputs.removeFirst()
        switch command {
        case .ls:
            readFolderContents()
        case .cd:
            guard let parameter = parameter else {
                fatalError("Shouldn't be a nil parameter here")
            }
            processParameter(parameter)
        }
    }
    
    private func processParameter(_ parameter: String) {
        switch parameter {
        case "..":
            pwds.removeLast()
        default:
            var newPwd = parameter
            if let lastPwd = pwds.last {
                newPwd = lastPwd + parameter
            }
            pwds.append(newPwd)
        }
    }
    
    private func readFolderContents() {
        var isFileOrFolder = true
        repeat {
            let element = inputs.first!
            let splitted = element.split(separator: " ")
            if splitted.count == 0 || splitted.first! == "$" {
                isFileOrFolder = false
            } else {
                getElementInfo(splitted)
                inputs.removeFirst()
            }
        } while isFileOrFolder
    }
    
    func getElementInfo(_ element: [Substring]) {
        switch element.first! {
        case "dir":
            let currentPwd = pwds.last!
            let dirName = currentPwd + String(element.last!)
            let newFolder = Folder(name: dirName)
            folders[dirName] = newFolder
            folders[currentPwd]?.folders.append(newFolder)
        default:
            let currentPwd = pwds.last!
            let size = Int(element.first!)!
            let name = String(element.last!)
            let file = File(name: name, size: size)
            folders[currentPwd]?.files.append(file)
        }
    }
    
    // MARK: - Helper classes
    class Folder {
        let name: String
        var files = [File]()
        var folders = [Folder]()
        
        init(name: String) {
            self.name = name
        }
        
        func getSize() -> Int {
            var size: Int = 0
            folders.forEach { folder in
                size += folder.getSize()
            }
            files.forEach { file in
                size += file.size
            }
            
            return size
        }
    }

    struct File {
        let name: String
        let size: Int
    }
}
