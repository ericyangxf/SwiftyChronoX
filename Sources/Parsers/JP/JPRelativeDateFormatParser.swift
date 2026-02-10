//
//  JPRelativeDateFormatParser.swift
//  SwiftyChrono
//
//  Parses Japanese relative date expressions:
//  Form 1: 過去N日/週間/か月/年 (past N days/weeks/months/years)
//  Form 2: 先週/来週/来月/来年/昨年 (last/next week/month/year)
//

import Foundation

private let PATTERN =
    "(?:" +
        // Form 1: 過去N日間/週間/か月/年 (past N units)
        "過去\\s*(\\d+)\\s*(日間?|週間?|か月|ヶ月|カ月|年)" +
    "|" +
        // Form 2: 先週/来週/来月/来年/昨年/次の週/次の月/次の年
        "(先週|来週|来月|来年|昨年)" +
    ")"

private let pastNumberGroup = 1
private let pastUnitGroup = 2
private let relativeWordGroup = 3

public class JPRelativeDateFormatParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .japanese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        result.tags[.jpRelativeDateFormatParser] = true

        let suffixText = text.substring(from: index + matchText.count, to: min(index + matchText.count + 5, text.count))
        let hasSinceSuffix = NSRegularExpression.isMatch(forPattern: "^\\s*以降", in: suffixText)

        // Form 1: 過去N日/週間/か月/年
        if match.isNotEmpty(atRangeIndex: pastNumberGroup) {
            let numberString = match.string(from: text, atRangeIndex: pastNumberGroup)
            let unitString = match.string(from: text, atRangeIndex: pastUnitGroup)

            guard let number = Int(numberString) else { return nil }

            var date = ref
            if unitString.hasPrefix("日") {
                date = date.added(-number, .day)
            } else if unitString.hasPrefix("週") {
                date = date.added(-number * 7, .day)
            } else if unitString == "か月" || unitString == "ヶ月" || unitString == "カ月" {
                date = date.added(-number, .month)
            } else if unitString == "年" {
                date = date.added(-number, .year)
            }

            result.start.assign(.year, value: date.year)
            result.start.assign(.month, value: date.month)
            result.start.assign(.day, value: date.day)
            return result
        }

        // Form 2: 先週/来週/来月/来年/昨年
        if match.isNotEmpty(atRangeIndex: relativeWordGroup) {
            let word = match.string(from: text, atRangeIndex: relativeWordGroup)

            if word == "先週" {
                let offsetToMonday = (ref.weekday + 6) % 7
                let currentWeekMonday = ref.added(-offsetToMonday, .day)
                let lastMonday = currentWeekMonday.added(-7, .day)

                result.start.assign(.year, value: lastMonday.year)
                result.start.assign(.month, value: lastMonday.month)
                result.start.assign(.day, value: lastMonday.day)

                if !hasSinceSuffix {
                    let lastSunday = lastMonday.added(6, .day)
                    result.end = ParsedComponents(components: nil, ref: result.start.date)
                    result.end?.assign(.year, value: lastSunday.year)
                    result.end?.assign(.month, value: lastSunday.month)
                    result.end?.assign(.day, value: lastSunday.day)
                }
            } else if word == "来週" {
                let offsetToMonday = (ref.weekday + 6) % 7
                let currentWeekMonday = ref.added(-offsetToMonday, .day)
                let nextMonday = currentWeekMonday.added(7, .day)

                result.start.assign(.year, value: nextMonday.year)
                result.start.assign(.month, value: nextMonday.month)
                result.start.assign(.day, value: nextMonday.day)

                if !hasSinceSuffix {
                    let nextSunday = nextMonday.added(6, .day)
                    result.end = ParsedComponents(components: nil, ref: result.start.date)
                    result.end?.assign(.year, value: nextSunday.year)
                    result.end?.assign(.month, value: nextSunday.month)
                    result.end?.assign(.day, value: nextSunday.day)
                }
            } else if word == "来月" {
                let nextMonth = ref.added(1, .month)
                result.start.assign(.year, value: nextMonth.year)
                result.start.assign(.month, value: nextMonth.month)
                result.start.assign(.day, value: 1)

                if !hasSinceSuffix {
                    let daysInMonth = nextMonth.numberOf(.day, inA: .month) ?? 0
                    result.end = ParsedComponents(components: nil, ref: result.start.date)
                    result.end?.assign(.year, value: nextMonth.year)
                    result.end?.assign(.month, value: nextMonth.month)
                    if daysInMonth > 0 {
                        result.end?.assign(.day, value: daysInMonth)
                    }
                }
            } else if word == "来年" {
                let nextYear = ref.year + 1
                result.start.assign(.year, value: nextYear)
                result.start.assign(.month, value: 1)
                result.start.assign(.day, value: 1)

                if !hasSinceSuffix {
                    result.end = ParsedComponents(components: nil, ref: result.start.date)
                    result.end?.assign(.year, value: nextYear)
                    result.end?.assign(.month, value: 12)
                    result.end?.assign(.day, value: 31)
                }
            } else if word == "昨年" {
                let lastYear = ref.year - 1
                result.start.assign(.year, value: lastYear)
                result.start.assign(.month, value: 1)
                result.start.assign(.day, value: 1)

                if !hasSinceSuffix {
                    result.end = ParsedComponents(components: nil, ref: result.start.date)
                    result.end?.assign(.year, value: lastYear)
                    result.end?.assign(.month, value: 12)
                    result.end?.assign(.day, value: 31)
                }
            }
            return result
        }

        return result
    }
}
