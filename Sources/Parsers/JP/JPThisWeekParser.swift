//
//  JPThisWeekParser.swift
//  SwiftyChrono
//
//  Parses 今週 (this week)
//

import Foundation

private let THIS_WEEK_PATTERN = "今週"

public class JPThisWeekParser: Parser {
    override var pattern: String { return THIS_WEEK_PATTERN }
    override var language: Language { return .japanese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)

        let offsetToMonday = (ref.weekday + 6) % 7
        let weekStart = ref.added(-offsetToMonday, .day)

        result.start.assign(.year, value: weekStart.year)
        result.start.assign(.month, value: weekStart.month)
        result.start.assign(.day, value: weekStart.day)

        result.end = ParsedComponents(components: nil, ref: ref)
        result.end?.assign(.year, value: ref.year)
        result.end?.assign(.month, value: ref.month)
        result.end?.assign(.day, value: ref.day)

        result.tags[.jpThisWeekParser] = true
        return result
    }
}
