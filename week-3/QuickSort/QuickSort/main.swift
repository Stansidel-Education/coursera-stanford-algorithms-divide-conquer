#!/usr/bin/swift
//
//  main.swift
//  QuickSort
//
//  Created by Stanislav Sidelnikov on 10/16/16.
//  Copyright © 2016 Yandex. All rights reserved.
//

import Foundation

enum PivotPickFunction: Int {
    case first = 1
    case last
    case random
}

extension Array where Element: Comparable {
    mutating func quickSort(usingPivotPickFunction pivotFunction: PivotPickFunction) -> Int {
        return quickSort(usingPivotPickFunciton: pivotFunction, from: 0, to: self.count - 1) + self.count - 1
    }
    
    private mutating func quickSort(usingPivotPickFunciton pivotFunction: PivotPickFunction, from: Int, to: Int) -> Int {
        if to == from {
            return 0
        }
        
        let p = pickPivotIndex(usingFunction: pivotFunction, from: from, to: to)
        if p != from {
            swapElements(index1: from, index2: p)
        }
        
        var i = from + 1
        for j in (from + 1)...to {
            if self[j] < self[from] {
                if j != from {
                    swapElements(index1: i, index2: j)
                }
                i += 1
            }
        }
        swapElements(index1: from, index2: i - 1)
        var leftC = 0
        if from < i - 2 {
            leftC = quickSort(usingPivotPickFunciton: pivotFunction, from: from, to: i - 2)
            leftC += (i - 2 - from)
        }
        var rightC = 0
        if to > i {
            rightC = quickSort(usingPivotPickFunciton: pivotFunction, from: i, to: to)
            rightC += to - i
        }
        return leftC + rightC
    }
    
    private mutating func swapElements(index1: Int, index2: Int) {
        let swap = self[index1]
        self[index1] = self[index2]
        self[index2] = swap
    }
    
    private func pickPivotIndex(usingFunction pivotFunction: PivotPickFunction, from: Int, to: Int) -> Int {
        switch pivotFunction {
        case .first:
            return from
        case .last:
            return to
        case .random:
            let m = from + (to - from) / 2
            if (self[m] >= self[to] && self[m] <= self[from]) || (self[m] >= self[from] && self[m] <= self[to]) {
                return m
            } else if (self[to] >= self[from] && self[to] <= self[m]) || (self[to] >= self[m] && self[to] <= self[from]) {
                return to
            } else {
                return from
            }
        }
    }
}

let filenameIn = NSString(string: CommandLine.arguments[1]).expandingTildeInPath

print("Reading file \"\(filenameIn)\"...")
let fileContent = try! String(contentsOfFile: filenameIn)
//let lines = fileContent.components(separatedBy: .newlines)//.map{Int($0) ?? -1}.filter{ $0 > -1 }
let scanner = Scanner(string: fileContent)
var numbers = [Int]()
var value = 0
while scanner.scanInt(&value) {
    numbers.append(value)
}

var comparisons = 0
var content = ""

print("File read. Computing...")
print("Pivot: first element.")
var numbers1 = numbers
comparisons = numbers1.quickSort(usingPivotPickFunction: .first)
print("Number of comparisons is: \(comparisons).")
content = numbers1.map{String($0)}.joined(separator: "\r\n")
try! content.write(toFile: "\(filenameIn).out.1", atomically: true, encoding: .utf8)

print("Pivot: last element.")
var numbers2 = numbers
comparisons = numbers2.quickSort(usingPivotPickFunction: .last)
print("Number of comparisons is: \(comparisons).")
content = numbers2.map{String($0)}.joined(separator: "\r\n")
try! content.write(toFile: "\(filenameIn).out.2", atomically: true, encoding: .utf8)

print("Pivot: random element.")
var numbers3 = numbers
comparisons = numbers3.quickSort(usingPivotPickFunction: .random)
print("Number of comparisons is: \(comparisons).")
content = numbers3.map{String($0)}.joined(separator: "\r\n")
try! content.write(toFile: "\(filenameIn).out.3", atomically: true, encoding: .utf8)

print("Finished")
