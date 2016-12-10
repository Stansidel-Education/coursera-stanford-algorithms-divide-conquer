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
    static func -(l: Self, r: Self) -> Self
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
        self.value = value
    }
    
    init(_ int: UInt) {
        self.value = String(int)
    }
}

extension InfiniteInt: Number {
    static func *(left: InfiniteInt, right: InfiniteInt) -> InfiniteInt {
        return left
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
}

extension InfiniteInt: CustomStringConvertible, CustomDebugStringConvertible {
    var debugDescription: String { return value }
    var description: String { return value }
}
