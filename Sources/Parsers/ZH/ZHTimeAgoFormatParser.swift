//
//  ZHTimeAgoFormatParser.swift
//  SwiftyChrono
//
//  Parses Chinese "time ago" expressions like:
//  5天前, 2周前, 3个月前, 5年前, 一周前, 一个月前, 几天前
//

import Foundation

private let PATTERN =
    "(\\d+|[一二两三四五六七八九十几幾半]+)\\s*" +
    "(?:个|個)?" +
    "(秒(?:钟|鐘)?|分钟|分鐘|小时|小時|天|日|周|週|星期|礼拜|禮拜|月|年)" +
    "(?:之)?前"

private let numberGroup = 1
private let unitGroup = 2

public class ZHTimeAgoFormatParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .chinese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)

        let numberString = match.string(from: text, atRangeIndex: numberGroup)
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
        let unit = match.string(from: text, atRangeIndex: unitGroup)
        let unitAbbr = unit.firstString ?? ""

        if unitAbbr == "秒" {
            date = number != HALF ? date.added(-number, .second) : date.added(-30, .second)
            result.start.imply(.day, to: date.day)
            result.start.imply(.month, to: date.month)
            result.start.imply(.year, to: date.year)
            result.start.assign(.hour, value: date.hour)
            result.start.assign(.minute, value: date.minute)
            result.start.assign(.second, value: date.second)
            result.tags[.zhTimeAgoFormatParser] = true
            return result
        } else if unitAbbr == "分" {
            date = number != HALF ? date.added(-number, .minute) : date.added(-30, .second)
            result.start.imply(.day, to: date.day)
            result.start.imply(.month, to: date.month)
            result.start.imply(.year, to: date.year)
            result.start.assign(.hour, value: date.hour)
            result.start.assign(.minute, value: date.minute)
            result.tags[.zhTimeAgoFormatParser] = true
            return result
        } else if unitAbbr == "小" {
            date = number != HALF ? date.added(-number, .hour) : date.added(-30, .minute)
            result.start.imply(.day, to: date.day)
            result.start.imply(.month, to: date.month)
            result.start.imply(.year, to: date.year)
            result.start.assign(.hour, value: date.hour)
            result.start.assign(.minute, value: date.minute)
            result.tags[.zhTimeAgoFormatParser] = true
            return result
        }

        if unitAbbr == "天" || unitAbbr == "日" {
            date = number != HALF ? date.added(-number, .day) : date.added(-12, .hour)
        } else if unitAbbr == "周" || unitAbbr == "週" || unitAbbr == "星" || unitAbbr == "礼" || unitAbbr == "禮" {
            date = number != HALF ? date.added(-number * 7, .day) : date.added(-3, .day).added(-12, .hour)
        } else if unitAbbr == "月" {
            date = number != HALF ? date.added(-number, .month) : date.added(-(date.numberOf(.day, inA: .month) ?? 30)/2, .day)
        } else if unitAbbr == "年" {
            date = number != HALF ? date.added(-number, .year) : date.added(-6, .month)
        }

        result.start.assign(.day, value: date.day)
        result.start.assign(.month, value: date.month)
        result.start.assign(.year, value: date.year)
        result.tags[.zhTimeAgoFormatParser] = true
        return result
    }
}
