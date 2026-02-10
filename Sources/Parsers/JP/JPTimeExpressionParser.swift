//
//  JPTimeExpressionParser.swift
//  SwiftyChrono
//

import Foundation

private let FIRST_REG_PATTERN =
    "(\\d{1,2})(?:\\s*)時" +
    "(?:\\s*(\\d{1,2})(?:\\s*)分)?" +
    "(?:\\s*(\\d{1,2})(?:\\s*)秒)?"

private let hourGroup = 1
private let minuteGroup = 2
private let secondGroup = 3

public class JPTimeExpressionParser: Parser {
    override var pattern: String { return FIRST_REG_PATTERN }
    override var language: Language { return .japanese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let idx = match.range(at: 0).location
        if idx > 0 {
            let str = text.substring(from: idx - 1, to: idx)
            if NSRegularExpression.isMatch(forPattern: "[a-zA-Z0-9_]", in: str) {
                return nil
            }
        }

        let matchText = match.string(from: text, atRangeIndex: 0)
        var result = ParsedResult(ref: ref, index: idx, text: matchText)
        result.tags[.jpTimeExpressionParser] = true

        result.start.imply(.day, to: ref.day)
        result.start.imply(.month, to: ref.month)
        result.start.imply(.year, to: ref.year)

        let hour = Int(match.string(from: text, atRangeIndex: hourGroup)) ?? 0
        var minute = 0
        var meridiem = -1

        if match.isNotEmpty(atRangeIndex: secondGroup) {
            if let second = Int(match.string(from: text, atRangeIndex: secondGroup)) {
                if second >= 60 { return nil }
                result.start.assign(.second, value: second)
            }
        }

        if match.isNotEmpty(atRangeIndex: minuteGroup) {
            minute = Int(match.string(from: text, atRangeIndex: minuteGroup)) ?? 0
        }

        if minute >= 60 || hour > 24 {
            return nil
        }

        if hour >= 12 {
            meridiem = 1
        }

        result.start.assign(.hour, value: hour)
        result.start.assign(.minute, value: minute)
        if meridiem >= 0 {
            result.start.assign(.meridiem, value: meridiem)
        } else {
            result.start.imply(.meridiem, to: 0)
        }

        return result
    }
}
