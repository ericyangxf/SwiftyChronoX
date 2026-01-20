//
//  ENMergeDateRangeRefiner.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 1/20/17.
//  Copyright © 2017 Potix. All rights reserved.
//

import Foundation

class ENMergeDateRangeRefiner: MergeDateRangeRefiner {
    override var PATTERN: String { return "^\\s*(to|\\-)\\s*$" }
    override var TAGS: TagUnit { return .enMergeDateRangeRefiner }

    override func isAbleToMerge(text: String, result1: ParsedResult, result2: ParsedResult) -> Bool {
        if super.isAbleToMerge(text: text, result1: result1, result2: result2) {
            return true
        }

        let (startIndex, endIndex) = sortTwoNumbers(result1.index + result1.text.count, result2.index)
        let textBetween = text.substring(from: startIndex, to: endIndex)
        guard NSRegularExpression.isMatch(forPattern: "^\\s*and\\s*$", in: textBetween) else {
            return false
        }

        let prefixText = text.substring(from: 0, to: result1.index)
        return NSRegularExpression.isMatch(forPattern: "\\bbetween\\s*$", in: prefixText)
    }
}











