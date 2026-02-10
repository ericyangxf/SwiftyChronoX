//
//  ENYearParsers.swift
//  SwiftyChrono
//
//  Created by Codex on 2025-01-13.
//  Copyright (c) 2025 Potix. All rights reserved.
//

import Foundation

private let YEAR_PATTERN = "(^|\\s)" +
    "(?:in|for|during)\\s+(?:the\\s+)?(?:year\\s+)?" +
    "([1-2]\\d{3})" +
    "(?!\\s*[-/\\.]\\s*\\d)" +
    "(?=\\b|\\s|$)"

private let THIS_YEAR_PATTERN = "(^|\\s)(?:in\\s+)?this\\s+year(?=\\b|\\s|$)"

private let SINCE_YEAR_PATTERN = "(^|\\s)" +
    "since\\s+([1-2]\\d{3})" +
    "(?!\\s*[-/\\.]\\s*\\d)" +
    "(?=\\b|\\s|$)"

private let FROM_YEAR_PATTERN = "(^|\\s)" +
    "from\\s+([1-2]\\d{3})" +
    "(?:\\s*(?:to|through|thru|until|till|-)\\s*([1-2]\\d{3}))?" +
    "(?!\\s*[-/\\.]\\s*\\d)" +
    "(?=\\b|\\s|$)"

private let yearGroup = 2
private let endYearGroup = 3

public class ENYearParser: Parser {
    override var pattern: String { return YEAR_PATTERN }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
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
        result.tags[.enYearParser] = true
        
        return result
    }
}

public class ENThisYearParser: Parser {
    override var pattern: String { return THIS_YEAR_PATTERN }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        
        result.start.assign(.year, value: ref.year)
        result.start.assign(.month, value: 1)
        result.start.assign(.day, value: 1)
        
        result.end = ParsedComponents(components: nil, ref: ref)
        result.end?.assign(.year, value: ref.year)
        result.end?.assign(.month, value: ref.month)
        result.end?.assign(.day, value: ref.day)
        
        result.tags[.enThisYearParser] = true
        return result
    }
}

public class ENSinceYearParser: Parser {
    override var pattern: String { return SINCE_YEAR_PATTERN }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
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
        result.tags[.enSinceYearParser] = true
        
        return result
    }
}

public class ENFromYearParser: Parser {
    override var pattern: String { return FROM_YEAR_PATTERN }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        let yearText = match.string(from: text, atRangeIndex: yearGroup)
        let endYearText = match.isNotEmpty(atRangeIndex: endYearGroup) ?
            match.string(from: text, atRangeIndex: endYearGroup) : ""
        
        guard let year = Int(yearText) else {
            return nil
        }
        
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        result.start.assign(.year, value: year)
        result.start.assign(.month, value: 1)
        result.start.assign(.day, value: 1)
        
        result.end = ParsedComponents(components: nil, ref: ref)
        if let endYear = Int(endYearText) {
            result.end?.assign(.year, value: endYear)
            result.end?.assign(.month, value: 12)
            result.end?.assign(.day, value: 31)
        } else {
            result.end?.assign(.year, value: ref.year)
            result.end?.assign(.month, value: ref.month)
            result.end?.assign(.day, value: ref.day)
        }
        
        result.yearText = yearText
        result.tags[.enFromYearParser] = true
        
        return result
    }
}
