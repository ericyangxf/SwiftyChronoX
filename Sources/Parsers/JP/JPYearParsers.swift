//
//  JPYearParsers.swift
//  SwiftyChrono
//
//  Created by Codex on 2025-01-13.
//

import Foundation

private let YEAR_PATTERN = "([0-9\\uff10-\\uff19]{4})\\s*\\u5e74(?:\\s*(?:\\u306b|\\u3067))?"
private let THIS_YEAR_PATTERN = "\\u4eca\\u5e74"
private let LAST_YEAR_PATTERN = "\\u53bb\\u5e74"
private let SINCE_YEAR_PATTERN = "([0-9\\uff10-\\uff19]{4})\\s*\\u5e74\\s*(?:\\u4ee5\\u6765|\\u4ee5\\u964d)"
private let FROM_YEAR_PATTERN = "([0-9\\uff10-\\uff19]{4})\\s*\\u5e74\\s*\\u304b\\u3089"
// 2020年から2025年まで (year range with から/- connector, optional まで suffix)
private let YEAR_RANGE_PATTERN = "([0-9\\uff10-\\uff19]{4})\\s*年\\s*(?:から|\\-)\\s*([0-9\\uff10-\\uff19]{4})\\s*年(?:\\s*まで)?"

private let yearGroup = 1

public class JPYearParser: Parser {
    override var pattern: String { return YEAR_PATTERN }
    override var language: Language { return .japanese }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        let yearText = match.string(from: text, atRangeIndex: yearGroup)
        let year = Int(yearText.hankakuOnlyNumber) ?? 0
        if year == 0 {
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
        result.tags[.jpYearParser] = true
        return result
    }
}

public class JPThisYearParser: Parser {
    override var pattern: String { return THIS_YEAR_PATTERN }
    override var language: Language { return .japanese }
    
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
        
        result.tags[.jpThisYearParser] = true
        return result
    }
}

public class JPLastYearParser: Parser {
    override var pattern: String { return LAST_YEAR_PATTERN }
    override var language: Language { return .japanese }
    
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
        
        result.tags[.jpLastYearParser] = true
        return result
    }
}

public class JPSinceYearParser: Parser {
    override var pattern: String { return SINCE_YEAR_PATTERN }
    override var language: Language { return .japanese }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        let yearText = match.string(from: text, atRangeIndex: yearGroup)
        let year = Int(yearText.hankakuOnlyNumber) ?? 0
        if year == 0 {
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
        result.tags[.jpSinceYearParser] = true
        return result
    }
}

public class JPFromYearParser: Parser {
    override var pattern: String { return FROM_YEAR_PATTERN }
    override var language: Language { return .japanese }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        let yearText = match.string(from: text, atRangeIndex: yearGroup)
        let year = Int(yearText.hankakuOnlyNumber) ?? 0
        if year == 0 {
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
        result.tags[.jpFromYearParser] = true
        return result
    }
}

public class JPYearRangeParser: Parser {
    override var pattern: String { return YEAR_RANGE_PATTERN }
    override var language: Language { return .japanese }

    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndexForCHHant(from: text, andMatchResult: match)
        let startYearText = match.string(from: text, atRangeIndex: 1).hankakuOnlyNumber
        let endYearText = match.string(from: text, atRangeIndex: 2).hankakuOnlyNumber
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
        result.tags[.jpYearParser] = true
        return result
    }
}
