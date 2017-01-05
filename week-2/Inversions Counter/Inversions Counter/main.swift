//
//  main.swift
//  Inversions Counter
//
//  Created by Stanislav Sidelnikov on 1/5/17.
//  Copyright © 2017 StanSidel. All rights reserved.
//

import Foundation

let filePath = NSString(string: CommandLine.arguments[1]).expandingTildeInPath

let contentData = FileManager.default.contents(atPath: filePath)
let content = NSString(data: contentData!, encoding: String.Encoding.utf8.rawValue) as! String
let scanner = Scanner(string: content)
var numbers = [Int]()
var value = 0
while scanner.scanInt(&value) {
    numbers.append(value)
}

func sortAndCount(a: [Int]) -> ([Int], Int) {
    let n = a.count
    guard n > 1 else { return (a, 0) }
    let m = n / 2
    let (left, leftC) = sortAndCount(a: Array(a[0..<m]))
    let (right, rightC) = sortAndCount(a: Array(a[m..<n]))
    var i = 0, j = 0, splitC = 0
    var result = [Int]()
    for _ in 0..<n {
        let leftN = i < left.count ? left[i] : nil
        let rightN = j < right.count ? right[j] : nil
        if leftN != nil && (rightN == nil || leftN! < rightN!) {
            result.append(left[i])
            i += 1
        } else if rightN != nil {
            result.append(right[j])
            splitC += left.count - i
            j += 1
        }
    }
    return (result, leftC + rightC + splitC)
}

let (_, inversionsNumber) = sortAndCount(a: numbers)
print("Lines count = \(numbers.count).")
print("Number of inversions is \(inversionsNumber).")
