//
//  ZHMergeDateRangeRefiner.swift
//  SwiftyChrono
//
//  Merges Chinese date ranges connected by 到/至/- between two results.
//  Also handles 从...到/至 patterns and N月N日到N日 patterns.
//

import Foundation

class ZHMergeDateRangeRefiner: MergeDateRangeRefiner {
    override var PATTERN: String { return "^\\s*(到|至|\\-)\\s*$" }
    override var TAGS: TagUnit { return .zhMergeDateRangeRefiner }

    override func isAbleToMerge(text: String, result1: ParsedResult, result2: ParsedResult) -> Bool {
        if super.isAbleToMerge(text: text, result1: result1, result2: result2) {
            return true
        }

        // Handle 之间 pattern: "X到Y之间" or "X和Y之间"
        let (startIndex, endIndex) = sortTwoNumbers(result1.index + result1.text.count, result2.index)
        let textBetween = text.substring(from: startIndex, to: endIndex)
        guard NSRegularExpression.isMatch(forPattern: "^\\s*(和|与|與)\\s*$", in: textBetween) else {
            return false
        }

        let prefixText = text.substring(from: 0, to: result1.index)
        return NSRegularExpression.isMatch(forPattern: "(?:从|從|自)\\s*$", in: prefixText)
    }
}
