//
//  JPSlashDateFormatParser.swift
//  SwiftyChrono
//
//  Slash/dot/dash date format parser for Japanese context.
//  Japanese characters are Unicode word characters (\w), so the EN parser's
//  (\W|^) boundary doesn't match after Japanese chars. This parser uses
//  a non-digit boundary instead.
//

import Foundation

private let PATTERN = "([^0-9]|^)" +
    "(?:" +
        "(?:[月火水木金土日]曜日?)" +
        "\\s*,?\\s*" +
    ")?" +
    "([0-3]?[0-9])[\\/\\.\\-]([0-3]?[0-9])" +
    "(?:" +
        "[\\/\\.\\-]" +
        "([0-9]{4}|[0-9]{2})" +
    ")?" +
    "([^0-9]|$)"

private let openningGroup = 1
private let endingGroup = 5
private let yearGroup = 4

public class JPSlashDateFormatParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .japanese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        if (match.isNotEmpty(atRangeIndex: openningGroup) && match.string(from: text, atRangeIndex: openningGroup) == "/") ||
            (match.isNotEmpty(atRangeIndex: endingGroup) && match.string(from: text, atRangeIndex: endingGroup) == "/") {
            let match0 = match.range(at: 0)
            return ParsedResult.moveIndexMode(index: match0.location + match0.length)
        }

        let openGroup = match.isNotEmpty(atRangeIndex: openningGroup) ? match.string(from: text, atRangeIndex: openningGroup) : ""
        let endGroup = match.isNotEmpty(atRangeIndex: endingGroup) ? match.string(from: text, atRangeIndex: endingGroup) : ""
        let fullMatchText = match.string(from: text, atRangeIndex: 0)
        let index = match.range(at: 0).location + match.range(at: openningGroup).length
        let matchText = fullMatchText.substring(from: openGroup.count, to: fullMatchText.count - endGroup.count)
        var result = ParsedResult(ref: ref, index: index, text: matchText)

        if NSRegularExpression.isMatch(forPattern: "^\\d\\.\\d$", in: matchText) ||
            NSRegularExpression.isMatch(forPattern: "^\\d\\.\\d{1,2}\\.\\d{1,2}$", in: matchText) {
            return nil
        }

        // MM/dd -> OK
        // MM.dd -> NG (need year for dot format)
        if match.isEmpty(atRangeIndex: yearGroup) && (text.range(of: "/")?.isEmpty ?? true) {
            return nil
        }

        var year = match.isNotEmpty(atRangeIndex: yearGroup) ? Int(match.string(from: text, atRangeIndex: yearGroup)) ?? ref.year : ref.year

        let littleEndian = opt[.littleEndian] ?? 0
        let monthGroup: Int
        let dayGroup: Int
        if littleEndian == 1 {
            monthGroup = 3
            dayGroup = 2
        } else {
            monthGroup = 2
            dayGroup = 3
        }
        var month = match.isNotEmpty(atRangeIndex: monthGroup) ? Int(match.string(from: text, atRangeIndex: monthGroup)) ?? 0 : 0
        var day = match.isNotEmpty(atRangeIndex: dayGroup) ? Int(match.string(from: text, atRangeIndex: dayGroup)) ?? 0 : 0

        if month < 1 || month > 12 {
            if month > 12 {
                if day >= 1 && day <= 12 && month >= 13 && month <= 31 {
                    let tday = month
                    month = day
                    day = tday
                } else {
                    return nil
                }
            }
        }

        if day < 1 || day > 31 {
            return nil
        }

        if year < 100 {
            year += year > 50 ? 1900 : 2000
        }

        result.start.assign(.day, value: day)
        result.start.assign(.month, value: month)
        result.start.assign(.year, value: year)

        result.tags[.enSlashDateFormatParser] = true
        return result
    }
}
