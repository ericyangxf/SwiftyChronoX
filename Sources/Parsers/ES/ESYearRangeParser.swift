//
//  ESYearRangeParser.swift
//  SwiftyChrono
//
//  Created by Codex on 2026-02-10.
//

import Foundation

private let YEAR_RANGE_PATTERN = "(^|\\s)de\\s+([1-2]\\d{3})\\s+a\\s+([1-2]\\d{3})(?=\\b|\\s|$)"

public class ESYearRangeParser: Parser {
    override var pattern: String { return YEAR_RANGE_PATTERN }
    override var language: Language { return .spanish }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        let startYearText = match.string(from: text, atRangeIndex: 2)
        let endYearText = match.string(from: text, atRangeIndex: 3)
        guard let startYear = Int(startYearText), let endYear = Int(endYearText) else {
            return nil
        }

        var result = ParsedResult(ref: ref, index: index, text: matchText)
        result.start.assign(.year, value: startYear)
        result.start.assign(.month, value: 1)
        result.start.assign(.day, value: 1)
        result.end = ParsedComponents(components: nil, ref: ref)
        result.end?.assign(.year, value: endYear)
        result.end?.assign(.month, value: 12)
        result.end?.assign(.day, value: 31)
        result.tags[.esYearParser] = true
        return result
    }
}
