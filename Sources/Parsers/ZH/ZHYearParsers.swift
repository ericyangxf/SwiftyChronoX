//
//  ZHYearParsers.swift
//  SwiftyChrono
//
//  Created by Codex on 2025-01-13.
//

import Foundation

private let YEAR_PATTERN = "(?:\\u5728\\s*)?([0-9]{4})\\s*\\u5e74"
private let THIS_YEAR_PATTERN = "\\u4eca\\u5e74"
private let LAST_YEAR_PATTERN = "\\u53bb\\u5e74"
private let SINCE_YEAR_PATTERN = "(?:\\u81ea|\\u4ece|\\u5f9e)\\s*([0-9]{4})\\s*\\u5e74\\s*(?:\\u4ee5\\u6765)?"
private let FROM_YEAR_PATTERN = "(?:\\u81ea|\\u4ece|\\u5f9e)\\s*([0-9]{4})\\s*\\u5e74\\s*(?:\\u8d77|\\u5f00\\u59cb)"
// 2020年到2025年 (year range with 到/至/- connector)
private let YEAR_RANGE_PATTERN = "([0-9]{4})\\s*\\u5e74\\s*(?:\\u5230|\\u81f3|\\-)\\s*([0-9]{4})\\s*\\u5e74"

private let yearGroup = 1

public class ZHYearParser: Parser {
    override var pattern: String { return YEAR_PATTERN }
    override var language: Language { return .chinese }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        let yearText = match.string(from: text, atRangeIndex: yearGroup)
        guard let year = Int(yearText) else {
            return nil
        }
        
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        result.start.assign(.year, value: year)
        result.start.assign(.month, value: 1)
        result.start.assign(.day, value: 1)
        result.end = result.start.clone()
        result.end?.assign(.month, value: 12)
        result.end?.assign(.day, value: 31)
        result.yearText = yearText
        result.tags[.zhYearParser] = true
        return result
    }
}

public class ZHThisYearParser: Parser {
    override var pattern: String { return THIS_YEAR_PATTERN }
    override var language: Language { return .chinese }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        
        result.start.assign(.year, value: ref.year)
        result.start.assign(.month, value: 1)
        result.start.assign(.day, value: 1)
        
        result.end = ParsedComponents(components: nil, ref: ref)
        result.end?.assign(.year, value: ref.year)
        result.end?.assign(.month, value: ref.month)
        result.end?.assign(.day, value: ref.day)
        
        result.tags[.zhThisYearParser] = true
        return result
    }
}

public class ZHLastYearParser: Parser {
    override var pattern: String { return LAST_YEAR_PATTERN }
    override var language: Language { return .chinese }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        let lastYear = ref.year - 1
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        
        result.start.assign(.year, value: lastYear)
        result.start.assign(.month, value: 1)
        result.start.assign(.day, value: 1)
        result.end = result.start.clone()
        result.end?.assign(.month, value: 12)
        result.end?.assign(.day, value: 31)
        
        result.tags[.zhLastYearParser] = true
        return result
    }
}

public class ZHSinceYearParser: Parser {
    override var pattern: String { return SINCE_YEAR_PATTERN }
    override var language: Language { return .chinese }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        let yearText = match.string(from: text, atRangeIndex: yearGroup)
        guard let year = Int(yearText) else {
            return nil
        }
        
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        result.start.assign(.year, value: year)
        result.start.assign(.month, value: 1)
        result.start.assign(.day, value: 1)
        
        result.end = ParsedComponents(components: nil, ref: ref)
        result.end?.assign(.year, value: ref.year)
        result.end?.assign(.month, value: ref.month)
        result.end?.assign(.day, value: ref.day)
        
        result.yearText = yearText
        result.tags[.zhSinceYearParser] = true
        return result
    }
}

public class ZHFromYearParser: Parser {
    override var pattern: String { return FROM_YEAR_PATTERN }
    override var language: Language { return .chinese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        let yearText = match.string(from: text, atRangeIndex: yearGroup)
        guard let year = Int(yearText) else {
            return nil
        }

        var result = ParsedResult(ref: ref, index: index, text: matchText)
        result.start.assign(.year, value: year)
        result.start.assign(.month, value: 1)
        result.start.assign(.day, value: 1)

        result.end = ParsedComponents(components: nil, ref: ref)
        result.end?.assign(.year, value: ref.year)
        result.end?.assign(.month, value: ref.month)
        result.end?.assign(.day, value: ref.day)

        result.yearText = yearText
        result.tags[.zhFromYearParser] = true
        return result
    }
}

public class ZHYearRangeParser: Parser {
    override var pattern: String { return YEAR_RANGE_PATTERN }
    override var language: Language { return .chinese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        let startYearText = match.string(from: text, atRangeIndex: 1)
        let endYearText = match.string(from: text, atRangeIndex: 2)
        guard let startYear = Int(startYearText), let endYear = Int(endYearText) else {
            return nil
        }

        var result = ParsedResult(ref: ref, index: index, text: matchText)
        result.start.assign(.year, value: startYear)
        result.start.assign(.month, value: 1)
        result.start.assign(.day, value: 1)
        result.end = ParsedComponents(components: nil, ref: ref)
        result.end?.assign(.year, value: endYear)
        result.end?.assign(.month, value: 12)
        result.end?.assign(.day, value: 31)
        result.tags[.zhYearParser] = true
        return result
    }
}
