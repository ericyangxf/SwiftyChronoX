//
//  JPMonthParsers.swift
//  SwiftyChrono
//
//  Created by Codex on 2026-01-20.
//

import Foundation

private let THIS_MONTH_PATTERN = "\\u4eca\\u6708"
private let LAST_MONTH_PATTERN = "\\u5148\\u6708"

public class JPThisMonthParser: Parser {
    override var pattern: String { return THIS_MONTH_PATTERN }
    override var language: Language { return .japanese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)

        result.start.assign(.year, value: ref.year)
        result.start.assign(.month, value: ref.month)
        result.start.assign(.day, value: 1)

        result.end = ParsedComponents(components: nil, ref: ref)
        result.end?.assign(.year, value: ref.year)
        result.end?.assign(.month, value: ref.month)
        result.end?.assign(.day, value: ref.day)

        result.tags[.jpThisMonthParser] = true
        return result
    }
}

public class JPLastMonthParser: Parser {
    override var pattern: String { return LAST_MONTH_PATTERN }
    override var language: Language { return .japanese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        let lastMonth = ref.added(-1, .month)
        var result = ParsedResult(ref: ref, index: index, text: matchText)

        result.start.assign(.year, value: lastMonth.year)
        result.start.assign(.month, value: lastMonth.month)
        result.start.assign(.day, value: 1)

        result.end = result.start.clone()
        let daysInMonth = lastMonth.numberOf(.day, inA: .month) ?? 0
        if daysInMonth > 0 {
            result.end?.assign(.day, value: daysInMonth)
        }

        result.tags[.jpLastMonthParser] = true
        return result
    }
}
