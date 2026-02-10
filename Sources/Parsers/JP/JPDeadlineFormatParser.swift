//
//  JPDeadlineFormatParser.swift
//  SwiftyChrono
//
//  Parses Japanese deadline/future expressions like:
//  5日後, 2週間後, 3か月後, 1年後
//  2日以内
//

import Foundation

// Matches: number + unit + 後/以内
private let PATTERN =
    "(\\d+)\\s*" +
    "(日|週間?|か月|ヶ月|カ月|年)" +
    "\\s*(?:後|以内)"

private let numberGroup = 1
private let unitGroup = 2

public class JPDeadlineFormatParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .japanese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)

        let numberString = match.string(from: text, atRangeIndex: numberGroup)
        guard let number = Int(numberString) else { return nil }

        var date = ref
        let unit = match.string(from: text, atRangeIndex: unitGroup)

        if unit == "日" {
            date = date.added(number, .day)
        } else if unit.hasPrefix("週") {
            date = date.added(number * 7, .day)
        } else if unit == "か月" || unit == "ヶ月" || unit == "カ月" {
            date = date.added(number, .month)
        } else if unit == "年" {
            date = date.added(number, .year)
        }

        result.start.assign(.year, value: date.year)
        result.start.assign(.month, value: date.month)
        result.start.assign(.day, value: date.day)
        result.tags[.jpDeadlineFormatParser] = true
        return result
    }
}
