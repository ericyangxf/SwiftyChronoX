//
//  JPWeekdayParser.swift
//  SwiftyChrono
//
//  Parses Japanese weekday expressions like:
//  月曜日, 火曜日, 次の月曜日, 先週金曜日, 今週水曜日
//

import Foundation

private let JP_WEEKDAY_MAP: [String: Int] = [
    "日": 0,
    "月": 1,
    "火": 2,
    "水": 3,
    "木": 4,
    "金": 5,
    "土": 6,
]

// Matches: [prefix] weekday曜日
// prefix: 先週 (last week), 今週 (this week), 次の/来週 (next)
private let PATTERN =
    "(?:(先週|今週|次の|来週)\\s*)?" +
    "([月火水木金土日])曜日?"

private let prefixGroup = 1
private let weekdayGroup = 2

public class JPWeekdayParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .japanese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)

        let dayChar = match.string(from: text, atRangeIndex: weekdayGroup)
        guard let offset = JP_WEEKDAY_MAP[dayChar] else {
            return nil
        }

        var modifier = ""
        if match.isNotEmpty(atRangeIndex: prefixGroup) {
            let prefix = match.string(from: text, atRangeIndex: prefixGroup)
            if prefix == "先週" {
                modifier = "last"
            } else if prefix == "次の" || prefix == "来週" {
                modifier = "next"
            } else if prefix == "今週" {
                modifier = "this"
            }
        }

        result = updateParsedComponent(result: result, ref: ref, offset: offset, modifier: modifier)
        result.tags[.jpWeekdayParser] = true
        return result
    }
}
