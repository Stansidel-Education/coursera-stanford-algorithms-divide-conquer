//
//  InfiniteInt.swift
//  Karatsuba Multiplication
//
//  Created by Stanislav Sidelnikov on 12/10/16.
//  Copyright © 2016 StanSidel. All rights reserved.
//

import Foundation

protocol Number {
    static func *(l: Self, r: Self) -> Self
    static func +(l: Self, r: Self) -> Self
    static func +=(l: inout Self, r: Self)
    static func -(l: Self, r: Self) -> Self
    static func -=(l: inout Self, r: Self)
    static func >(l: Self, r: Self) -> Bool
    static func >=(l: Self, r: Self) -> Bool
    static func <(l: Self, r: Self) -> Bool
    static func <=(l: Self, r: Self) -> Bool
    static func ==(l: Self, r: Self) -> Bool
    static func !=(l: Self, r: Self) -> Bool
}

// See https://beaunouvelle.com/large-numbers-with-swift-big-int/
struct InfiniteInt {
    fileprivate var value: String
    
    init?(_ value: String) {
        for character in value.characters {
            if Int(String(character)) == nil {
                return nil
            }
        }
        if value.isEmpty {
            self.value = "0"
        } else {
            self.value = value
        }
    }
    
    init(_ int: UInt) {
        self.value = String(int)
    }
}

extension InfiniteInt: Number {
    static func *(left: InfiniteInt, right: InfiniteInt) -> InfiniteInt {
        let lcount = left.value.characters.count
        let rcount = right.value.characters.count
        if lcount == rcount && log2(Double(lcount)).remainder(dividingBy: 1) == 0 {
            print("Multiplying with Karatsuba")
            return multiplyKaratsuba(left, right)
        } else {
            print("Multiplying with Traditional")
            return multiplyTraditional(left, right)
        }
    }
    
    static func +(left: InfiniteInt, right: InfiniteInt) -> InfiniteInt {
        let maxl = left.value.characters.count - 1
        let maxr = right.value.characters.count - 1
        var il: String.Index? = left.value.index(before: left.value.endIndex)
        var ir: String.Index? = right.value.index(before: right.value.endIndex)
        var digits = [Int]()
        var memory = 0
        for _ in (0...max(maxl, maxr)).reversed() {
            var sum = memory
            if il != nil {
                sum += Int(String(left.value[il!]))!
                if il! > left.value.startIndex {
                    il = left.value.index(before: il!)
                } else {
                    il = nil
                }
            }
            if ir != nil {
                sum += Int(String(right.value[ir!]))!
                if ir! > right.value.startIndex {
                    ir = right.value.index(before: ir!)
                } else {
                    ir = nil
                }
            }
            digits.append(sum % 10)
            memory = sum / 10
        }
        if memory > 0 {
            digits.append(memory)
        }
        let result = InfiniteInt(digits.reversed().map({ String($0) }).joined())!
        return result
    }
    
    static func -(left: InfiniteInt, right: InfiniteInt) -> InfiniteInt {
        guard left >= right else { fatalError("Cannot work with negative numbers") }
        guard left != right else { return InfiniteInt(0) }
        
        let maxl = left.value.characters.count - 1
        let maxr = right.value.characters.count - 1
        var il: String.Index? = left.value.index(before: left.value.endIndex)
        var ir: String.Index? = right.value.index(before: right.value.endIndex)
        var digits = [String]()
        var memory = 0
        for _ in (0...max(maxl, maxr)).reversed() {
            var sum = memory
            if il != nil {
                sum += Int(String(left.value[il!]))!
                if il! > left.value.startIndex {
                    il = left.value.index(before: il!)
                } else {
                    il = nil
                }
            }
            if ir != nil {
                sum -= Int(String(right.value[ir!]))!
                if ir! > right.value.startIndex {
                    ir = right.value.index(before: ir!)
                } else {
                    ir = nil
                }
            }
            if sum < 0 {
                sum += 10
                memory = -1
            } else {
                memory = 0
            }
            digits.append(String(sum))
        }
        if memory < 0 {
            fatalError()
        }
        while let digit = digits.last, digit == "0" {
            digits.removeLast()
        }
        guard digits.count > 0 else { return InfiniteInt(0) }
        let result = InfiniteInt(digits.reversed().joined())!
        return result
    }
    
    static func >(left: InfiniteInt, right: InfiniteInt) -> Bool {
        guard left.value != right.value else { return false }
        let lenL = left.value.characters.count
        let lenR = right.value.characters.count
        guard lenL == lenR else { return lenL > lenR }
        var il = left.value.startIndex
        var ir = right.value.startIndex
        while il < left.value.endIndex {
            if left.value[il] != right.value[ir] {
                return Int(String(left.value[il]))! > Int(String(right.value[ir]))!
            }
            il = left.value.index(after: il)
            ir = right.value.index(after: ir)
        }
        return true
    }
    
    static func >=(left: InfiniteInt, right: InfiniteInt) -> Bool {
        return left > right || left == right
    }
    
    static func <(left: InfiniteInt, right: InfiniteInt) -> Bool {
        return !(left > right || left == right)
    }
    
    static func <=(left: InfiniteInt, right: InfiniteInt) -> Bool {
        return left < right || left == right
    }
    
    static func ==(left: InfiniteInt, right: InfiniteInt) -> Bool {
        return left.value == right.value
    }
    
    static func !=(left: InfiniteInt, right: InfiniteInt) -> Bool {
        return left.value != right.value
    }
    
    static func +=(left: inout InfiniteInt, right: InfiniteInt) {
        left = left + right
    }
    
    static func -=(left: inout InfiniteInt, right: InfiniteInt) {
        left = left - right
    }
    
    fileprivate static func multiplyTraditional(_ l: InfiniteInt, _ r: InfiniteInt) -> InfiniteInt {
        guard l != InfiniteInt(0) && r != InfiniteInt(0) else { return InfiniteInt(0) }
        let (left, right) = l > r ? (l, r) : (r, l)
        let rcount = right.value.characters.count
        let lcount = left.value.characters.count
        var result = InfiniteInt(0)
        for i in (0..<rcount) {
            let ir = right.value.index(right.value.endIndex, offsetBy: -i - 1)
            let digitRight = UInt(String(right.value[ir]))!
            var digits = Array<String>(repeating: "0", count: i)
            var memory: UInt = 0
            for j in (0..<lcount) {
                let il = left.value.index(left.value.endIndex, offsetBy: -j - 1)
                let digitLeft = UInt(String(left.value[il]))!
                let product = (digitLeft * digitRight) + memory
                digits.append(String(product % 10))
                memory = product / 10
            }
            if memory > 0 {
                digits.append(String(memory))
            }
            result += InfiniteInt(digits.reversed().joined())!
        }
        return result
    }
    
    fileprivate static func multiplyKaratsuba(_ left: InfiniteInt, _ right: InfiniteInt) -> InfiniteInt {
        let lv = left.value
        let rv = right.value
        let n = lv.characters.count
        guard n > 1 else {
            let leftInt = UInt(left.value)!
            let rightInt = UInt(right.value)!
            return InfiniteInt(leftInt * rightInt)
        }
        let leftMiddleIndex = lv.index(lv.endIndex, offsetBy: -n / 2)
        let a = InfiniteInt(lv.substring(to: leftMiddleIndex))!
        let b = InfiniteInt(lv.substring(from: leftMiddleIndex))!
        let rightMiddleIndex = rv.index(rv.endIndex, offsetBy: -n / 2)
        let c = InfiniteInt(rv.substring(to: rightMiddleIndex))!
        let d = InfiniteInt(rv.substring(from: rightMiddleIndex))!
        let ac = multiplyKaratsuba(a, c)
        let bd = multiplyKaratsuba(b, d)
        let third = multiplyKaratsuba(a + b, c + d)
        let fourth = third - ac - bd
        let x1 = InfiniteInt(ac.value + String(repeating: "0", count: n - (n % 2)))!
        let x2 = InfiniteInt(fourth.value + String(repeating: "0", count: n / 2))!
        let result = x1 + x2 + bd
        return result
    }
}

extension InfiniteInt: CustomStringConvertible, CustomDebugStringConvertible {
    var debugDescription: String { return value }
    var description: String { return value }
}
