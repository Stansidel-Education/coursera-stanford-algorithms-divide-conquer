//
//  InfiniteIntTests.swift
//  Karatsuba Multiplication
//
//  Created by Stanislav Sidelnikov on 12/10/16.
//  Copyright © 2016 StanSidel. All rights reserved.
//

import XCTest
@testable import Karatsuba_Multiplication

class InfiniteIntTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAdditionsSubtractions() {
        XCTAssert(ii(0) + ii(1) == ii(1))
        XCTAssert(ii(1) + ii(1) == ii(2))
        XCTAssert(ii(0) + ii(100) == ii(100))
        XCTAssert(ii(1) + ii(100) == ii(101))
        XCTAssert(ii(1) + ii(9) == ii(10))
        XCTAssert(ii(11) + ii(9) == ii(20))
        XCTAssert(ii(15) + ii(9) == ii(24))
        XCTAssert(ii(1) - ii(0) == ii(1))
        XCTAssert(ii(0) - ii(0) == ii(0))
        XCTAssert(ii(1) - ii(1) == ii(0))
        XCTAssert(ii(11) - ii(9) == ii(2))
        XCTAssert(ii(11) - ii(10) == ii(1))
        XCTAssert(ii(111) - ii(9) == ii(102))
        XCTAssert(ii(10) - ii(1) == ii(9))
    }
    
    func testComparisons() {
        XCTAssert(ii(0) == ii(0))
        XCTAssert(ii(1) == ii(1))
        XCTAssertFalse(ii(1) != ii(1))
        XCTAssertFalse(ii(1) > ii(1))
        XCTAssertFalse(ii(1) < ii(1))
        XCTAssert(ii(1) >= ii(1))
        XCTAssert(ii(1) <= ii(1))
        XCTAssert(ii(100) > ii(99))
        XCTAssert(ii(90) > ii(89))
        XCTAssertFalse(ii(100) < ii(99))
        XCTAssertFalse(ii(100) == ii(99))
        XCTAssertFalse(ii(100) <= ii(99))
        XCTAssert(ii(100) >= ii(99))
        XCTAssert(ii(100) != ii(99))
    }
    
    func testMultiplication() {
        testMultiply(1, 1)
        testMultiply(1, 2)
        testMultiply(99999999, 1111111)
        testMultiply(91092, 2213)
    }
    
    fileprivate func ii(_ int: UInt) -> InfiniteInt {
        return InfiniteInt(int)
    }
    
    fileprivate func testMultiply(_ n1: UInt, _ n2: UInt, file: String = #file, line: UInt = #line) {
        let expectedResult = ii(n1 * n2)
        let actualResult = ii(n1) * ii(n2)
        let exp = expectation(description: "")
        if actualResult == expectedResult {
            exp.fulfill()
        }
        waitForExpectations(timeout: 0, handler: { (error) -> Void in
            if (error != nil) {
                let message = "Expected \(expectedResult). Got \(actualResult)."
                self.recordFailure(withDescription: message,
                                                  inFile: file, atLine: line, expected: true)
            }
        })
    }
}
