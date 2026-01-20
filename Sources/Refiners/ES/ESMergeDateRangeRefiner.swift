//
//  ESMergeDateRangeRefiner.swift
//  SwiftyChrono
//
//  Created by Codex on 2026-01-20.
//

import Foundation

class ESMergeDateRangeRefiner: MergeDateRangeRefiner {
    override var PATTERN: String { return "(?!)" }
    override var TAGS: TagUnit { return .esMergeDateRangeRefiner }

    override func isAbleToMerge(text: String, result1: ParsedResult, result2: ParsedResult) -> Bool {
        let (startIndex, endIndex) = sortTwoNumbers(result1.index + result1.text.count, result2.index)
        let textBetween = text.substring(from: startIndex, to: endIndex)
        guard NSRegularExpression.isMatch(forPattern: "^\\s*(y|e)\\s*$", in: textBetween) else {
            return false
        }

        let prefixText = text.substring(from: 0, to: result1.index)
        return NSRegularExpression.isMatch(forPattern: "\\bentre\\s*$", in: prefixText)
    }
}
