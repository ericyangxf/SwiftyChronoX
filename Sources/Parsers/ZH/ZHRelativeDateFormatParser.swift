//
//  ZHRelativeDateFormatParser.swift
//  SwiftyChrono
//
//  Parses Chinese relative date expressions like:
//  过去N天/周/月/年, 上周, 下周, 上个月, 下个月, 明年, 去年
//  自上周以来, 自上个月以来, 自去年以来
//

import Foundation

// Matches:
//   过去N天/周/个月/年
//   过去一周/一个月/一年
private let PATTERN =
    "(?:" +
        // Form 1: 过去N天/周/月/年 (past N days/weeks/months/years)
        "过去\\s*(\\d+|[一二两三四五六七八九十几幾半]+)\\s*(?:个|個)?\\s*(天|日|周|週|星期|礼拜|禮拜|月|年)" +
    "|" +
        // Form 2: 上/下 + 周/个月/年 with optional 自...以来 prefix
        "(上|下)\\s*(?:个|個)?\\s*(周|週|星期|礼拜|禮拜|月|年)" +
    "|" +
        // Form 3: 明年 (next year)
        "(明年)" +
    ")"

private let pastNumberGroup = 1
private let pastUnitGroup = 2
private let relativeModifierGroup = 3
private let relativeUnitGroup = 4
private let nextYearGroup = 5

public class ZHRelativeDateFormatParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .chinese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        result.tags[.zhRelativeDateFormatParser] = true

        let prefixText = text.substring(from: 0, to: index)
        let hasSincePrefix = NSRegularExpression.isMatch(forPattern: "自\\s*$", in: prefixText)

        // Form 1: 过去N天/周/月/年
        if match.isNotEmpty(atRangeIndex: pastNumberGroup) {
            let numberString = match.string(from: text, atRangeIndex: pastNumberGroup)
            let unitString = match.string(from: text, atRangeIndex: pastUnitGroup)
            let unitAbbr = unitString.firstString ?? ""

            let number: Int
            if numberString == "几" || numberString == "幾" {
                number = 3
            } else if numberString == "半" {
                number = HALF
            } else if let intValue = Int(numberString) {
                number = intValue
            } else {
                number = ZHStringToNumber(text: numberString)
            }

            var date = ref
            if unitAbbr == "天" || unitAbbr == "日" {
                date = date.added(-number, .day)
                result.start.assign(.year, value: date.year)
                result.start.assign(.month, value: date.month)
                result.start.assign(.day, value: date.day)
            } else if unitAbbr == "周" || unitAbbr == "週" || unitAbbr == "星" || unitAbbr == "礼" || unitAbbr == "禮" {
                date = date.added(-number * 7, .day)
                result.start.assign(.year, value: date.year)
                result.start.assign(.month, value: date.month)
                result.start.assign(.day, value: date.day)
            } else if unitAbbr == "月" {
                date = date.added(-number, .month)
                result.start.assign(.year, value: date.year)
                result.start.assign(.month, value: date.month)
                result.start.assign(.day, value: date.day)
            } else if unitAbbr == "年" {
                date = date.added(-number, .year)
                result.start.assign(.year, value: date.year)
                result.start.assign(.month, value: date.month)
                result.start.assign(.day, value: date.day)
            }
            return result
        }

        // Form 3: 明年
        if match.isNotEmpty(atRangeIndex: nextYearGroup) {
            let nextYear = ref.year + 1
            result.start.assign(.year, value: nextYear)
            result.start.assign(.month, value: 1)
            result.start.assign(.day, value: 1)
            if !hasSincePrefix {
                result.end = ParsedComponents(components: nil, ref: result.start.date)
                result.end?.assign(.year, value: nextYear)
                result.end?.assign(.month, value: 12)
                result.end?.assign(.day, value: 31)
            }
            return result
        }

        // Form 2: 上/下 + 周/个月/年
        if match.isNotEmpty(atRangeIndex: relativeModifierGroup) {
            let modifier = match.string(from: text, atRangeIndex: relativeModifierGroup)
            let unitString = match.string(from: text, atRangeIndex: relativeUnitGroup)
            let unitAbbr = unitString.firstString ?? ""
            let direction = modifier == "上" ? -1 : 1

            if unitAbbr == "周" || unitAbbr == "週" || unitAbbr == "星" || unitAbbr == "礼" || unitAbbr == "禮" {
                // Calendar week (Mon-Sun)
                let offsetToMonday = (ref.weekday + 6) % 7
                let currentWeekMonday = ref.added(-offsetToMonday, .day)
                let targetMonday = currentWeekMonday.added(direction * 7, .day)

                result.start.assign(.year, value: targetMonday.year)
                result.start.assign(.month, value: targetMonday.month)
                result.start.assign(.day, value: targetMonday.day)

                if !hasSincePrefix {
                    let targetSunday = targetMonday.added(6, .day)
                    result.end = ParsedComponents(components: nil, ref: result.start.date)
                    result.end?.assign(.year, value: targetSunday.year)
                    result.end?.assign(.month, value: targetSunday.month)
                    result.end?.assign(.day, value: targetSunday.day)
                }
            } else if unitAbbr == "月" {
                let targetMonth = ref.added(direction, .month)
                result.start.assign(.year, value: targetMonth.year)
                result.start.assign(.month, value: targetMonth.month)
                result.start.assign(.day, value: 1)

                if !hasSincePrefix {
                    let daysInMonth = targetMonth.numberOf(.day, inA: .month) ?? 0
                    result.end = ParsedComponents(components: nil, ref: result.start.date)
                    result.end?.assign(.year, value: targetMonth.year)
                    result.end?.assign(.month, value: targetMonth.month)
                    if daysInMonth > 0 {
                        result.end?.assign(.day, value: daysInMonth)
                    }
                }
            } else if unitAbbr == "年" {
                let targetYear = ref.year + direction
                result.start.assign(.year, value: targetYear)
                result.start.assign(.month, value: 1)
                result.start.assign(.day, value: 1)

                if !hasSincePrefix {
                    result.end = ParsedComponents(components: nil, ref: result.start.date)
                    result.end?.assign(.year, value: targetYear)
                    result.end?.assign(.month, value: 12)
                    result.end?.assign(.day, value: 31)
                }
            }
            return result
        }

        return result
    }
}
