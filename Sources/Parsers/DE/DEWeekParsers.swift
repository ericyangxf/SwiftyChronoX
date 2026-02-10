//
//  DEWeekParsers.swift
//  SwiftyChrono
//
//  Created by Codex on 2026-02-09.
//

import Foundation

private let THIS_WEEK_PATTERN = "(^|\\s)(?:f[üu]r\\s+|in\\s+)?diese[rn]?\\s+woche(?=\\b|\\s|$)"

public class DEThisWeekParser: Parser {
    override var pattern: String { return THIS_WEEK_PATTERN }
    override var language: Language { return .german }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
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

        result.tags[.deThisWeekParser] = true
        return result
    }
}
