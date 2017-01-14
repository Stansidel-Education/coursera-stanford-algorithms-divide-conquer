//
//  main.swift
//  Karger Algorithm
//
//  Created by Stanislav Sidelnikov on 10/28/16.
//  Copyright © 2016 Yandex. All rights reserved.
//

import Foundation

let runner = KargerAlgorithm()

let filename = NSString(string: CommandLine.arguments[1]).expandingTildeInPath
runner.readFile(named: filename)

var minVal = Int.max
let n = Double(runner.originalGraph!.count)
//let N = Int(ceil(pow(n, 2) * (log(n) / log(M_E))))
let N = 20
print("Trying \(N) times...")
for i in 0..<N {
    var date = Date()
    runner.readFile(named: filename)
    let readingTime = Date().timeIntervalSince(date)
    date = Date()
    let value = runner.perform()
    minVal = min(value, minVal)
    let computingTime = Date().timeIntervalSince(date)
    print("Run \(i): \(value) | reading: \(readingTime), computing: \(computingTime)")
}
print("Min cut: \(minVal)")
