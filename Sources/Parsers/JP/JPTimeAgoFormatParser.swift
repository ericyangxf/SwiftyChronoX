//
//  JPTimeAgoFormatParser.swift
//  SwiftyChrono
//
//  Parses Japanese "time ago" expressions like:
//  5日前, 2週間前, 3か月前, 5年前, 数日前, 1週間前
//

import Foundation

// Matches: number + unit + 前
// Units: 日, 週間, か月/ヶ月/カ月, 年
// Number: digits, or 数 (few = 3)
private let PATTERN =
    "(\\d+|数)\\s*" +
    "(日|週間?|か月|ヶ月|カ月|年)" +
    "\\s*前"

private let numberGroup = 1
private let unitGroup = 2

public class JPTimeAgoFormatParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .japanese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)

        let numberString = match.string(from: text, atRangeIndex: numberGroup)
        let number: Int
        if numberString == "数" {
            number = 3
        } else if let intValue = Int(numberString) {
            number = intValue
        } else {
            return nil
        }

        var date = ref
        let unit = match.string(from: text, atRangeIndex: unitGroup)

        if unit == "日" {
            date = date.added(-number, .day)
        } else if unit.hasPrefix("週") {
            date = date.added(-number * 7, .day)
        } else if unit == "か月" || unit == "ヶ月" || unit == "カ月" {
            date = date.added(-number, .month)
        } else if unit == "年" {
            date = date.added(-number, .year)
        }

        result.start.assign(.day, value: date.day)
        result.start.assign(.month, value: date.month)
        result.start.assign(.year, value: date.year)
        result.tags[.jpTimeAgoFormatParser] = true
        return result
    }
}
