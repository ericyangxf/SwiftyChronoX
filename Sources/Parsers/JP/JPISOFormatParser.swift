//
//  JPISOFormatParser.swift
//  SwiftyChrono
//
//  ISO 8601 format parser for Japanese context.
//  Japanese characters are Unicode word characters (\w), so the EN parser's
//  (\W|^) boundary doesn't match after Japanese chars. This parser uses
//  a non-digit boundary instead.
//

import Foundation

private let PATTERN = "([^0-9]|^)" +
    "([0-9]{4})\\-([0-9]{1,2})\\-([0-9]{1,2})" +
    "(?=\\D|$)"

private let yearNumberGroup = 2
private let monthNumberGroup = 3
private let dayNumberGroup = 4

public class JPISOFormatParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .japanese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)

        result.start.assign(.year, value: Int(match.string(from: text, atRangeIndex: yearNumberGroup)))
        result.start.assign(.month, value: Int(match.string(from: text, atRangeIndex: monthNumberGroup)))
        result.start.assign(.day, value: Int(match.string(from: text, atRangeIndex: dayNumberGroup)))

        guard let month = result.start[.month], let day = result.start[.day] else {
            return nil
        }

        if month > 12 || month < 1 || day > 31 || day < 1 {
            return nil
        }

        result.tags[.enISOFormatParser] = true
        return result
    }
}
