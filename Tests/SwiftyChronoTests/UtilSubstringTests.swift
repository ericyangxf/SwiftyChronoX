//
//  UtilSubstringTests.swift
//  SwiftyChrono
//
//  Created by Codex on 2025-01-13.
//

import XCTest

final class UtilSubstringTests: XCTestCase {
    func testSubstringInvertedRangeReturnsEmptyString() {
        let text = "abcdef"
        let result = text.substring(from: 4, to: 2)
        XCTAssertEqual(result, "")
    }
}
