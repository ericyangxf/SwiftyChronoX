//
//  JPDateRangeParser.swift
//  SwiftyChrono
//
//  Parses Japanese date range patterns like:
//  1月15日から20日, 1月15日から20日まで
//  These are intra-month ranges where the second date omits the month.
//

import Foundation

// Matches: [year年] month月 day日 から/- day[日] [まで]
private let PATTERN =
    "(?:([0-9０-９]{4})\\s*年\\s*)?" +
    "([0-9０-９]{1,2})\\s*月\\s*" +
    "([0-9０-９]{1,2})\\s*日\\s*" +
    "(?:から|\\-)\\s*" +
    "([0-9０-９]{1,2})\\s*日?" +
    "(?![0-9月])"

private let yearGroup = 1
private let monthGroup = 2
private let startDayGroup = 3
private let endDayGroup = 4

public class JPDateRangeParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .japanese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)

        let monthString = match.string(from: text, atRangeIndex: monthGroup).hankakuOnlyNumber
        guard let month = Int(monthString), month >= 1, month <= 12 else {
            return nil
        }

        let startDayString = match.string(from: text, atRangeIndex: startDayGroup).hankakuOnlyNumber
        guard let startDay = Int(startDayString), startDay >= 1, startDay <= 31 else {
            return nil
        }

        let endDayString = match.string(from: text, atRangeIndex: endDayGroup).hankakuOnlyNumber
        guard let endDay = Int(endDayString), endDay >= 1, endDay <= 31 else {
            return nil
        }

        var result = ParsedResult(ref: ref, index: index, text: matchText)

        let year: Int
        if match.isNotEmpty(atRangeIndex: yearGroup) {
            let yearText = match.string(from: text, atRangeIndex: yearGroup).hankakuOnlyNumber
            year = Int(yearText) ?? ref.year
            result.start.assign(.year, value: year)
        } else {
            year = ref.year
            result.start.imply(.year, to: year)
        }

        result.start.assign(.month, value: month)
        result.start.assign(.day, value: startDay)

        result.end = ParsedComponents(components: nil, ref: ref)
        result.end?.assign(.year, value: year)
        result.end?.assign(.month, value: month)
        result.end?.assign(.day, value: endDay)

        result.tags[.jpStandardParser] = true
        return result
    }
}
