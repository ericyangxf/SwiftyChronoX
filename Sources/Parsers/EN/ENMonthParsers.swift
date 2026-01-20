//
//  ENMonthParsers.swift
//  SwiftyChrono
//
//  Created by Codex on 2026-01-20.
//

import Foundation

private let THIS_MONTH_PATTERN = "(^|\\s)(?:in\\s+)?this\\s+month(?=\\b|\\s|$)"

public class ENThisMonthParser: Parser {
    override var pattern: String { return THIS_MONTH_PATTERN }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)

        result.start.assign(.year, value: ref.year)
        result.start.assign(.month, value: ref.month)
        result.start.assign(.day, value: 1)

        result.end = ParsedComponents(components: nil, ref: ref)
        result.end?.assign(.year, value: ref.year)
        result.end?.assign(.month, value: ref.month)
        result.end?.assign(.day, value: ref.day)

        result.tags[.enThisMonthParser] = true
        return result
    }
}
