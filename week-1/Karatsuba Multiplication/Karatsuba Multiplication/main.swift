//
//  main.swift
//  Karatsuba Multiplication
//
//  Created by Stanislav Sidelnikov on 12/10/16.
//  Copyright © 2016 StanSidel. All rights reserved.
//

import Foundation

let number1 = InfiniteInt(CommandLine.arguments[1])!
let number2 = InfiniteInt(CommandLine.arguments[2])!

let result = number1 - number2
print(result)
