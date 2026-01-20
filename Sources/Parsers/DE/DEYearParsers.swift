//
//  DEYearParsers.swift
//  SwiftyChrono
//
//  Created by Codex on 2025-01-13.
//  Copyright (c) 2025 Potix. All rights reserved.
//

import Foundation

private let YEAR_PATTERN = "(^|\\s)(?:im\\s+jahr|im|in|f\\u00fcr|w\\u00e4hrend)\\s+(?:jahr\\s+)?([1-2]\\d{3})" +
    "(?!\\s*[-/\\.]\\s*\\d)(?=\\b|\\s|$)"
private let THIS_YEAR_PATTERN = "(^|\\s)diese(?:s|n|m)?\\s+jahr(?=\\b|\\s|$)"
private let LAST_YEAR_PATTERN = "(^|\\s)(?:letzte|vorige)(?:s|n|m)?\\s+jahr(?=\\b|\\s|$)"
private let SINCE_YEAR_PATTERN = "(^|\\s)seit\\s+(?:dem\\s+jahr\\s+)?([1-2]\\d{3})" +
    "(?!\\s*[-/\\.]\\s*\\d)(?=\\b|\\s|$)"
private let FROM_YEAR_PATTERN = "(^|\\s)ab\\s+(?:dem\\s+jahr\\s+)?([1-2]\\d{3})" +
    "(?!\\s*[-/\\.]\\s*\\d)(?=\\b|\\s|$)"

private let yearGroup = 2

public class DEYearParser: Parser {
    override var pattern: String { return YEAR_PATTERN }
    override var language: Language { return .german }
    
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
        result.tags[.deYearParser] = true
        return result
    }
}

public class DEThisYearParser: Parser {
    override var pattern: String { return THIS_YEAR_PATTERN }
    override var language: Language { return .german }
    
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
        
        result.tags[.deThisYearParser] = true
        return result
    }
}

public class DELastYearParser: Parser {
    override var pattern: String { return LAST_YEAR_PATTERN }
    override var language: Language { return .german }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        let lastYear = ref.year - 1
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        
        result.start.assign(.year, value: lastYear)
        result.start.assign(.month, value: 1)
        result.start.assign(.day, value: 1)
        result.end = result.start.clone()
        result.end?.assign(.month, value: 12)
        result.end?.assign(.day, value: 31)
        
        result.tags[.deLastYearParser] = true
        return result
    }
}

public class DESinceYearParser: Parser {
    override var pattern: String { return SINCE_YEAR_PATTERN }
    override var language: Language { return .german }
    
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
        result.tags[.deSinceYearParser] = true
        return result
    }
}

public class DEFromYearParser: Parser {
    override var pattern: String { return FROM_YEAR_PATTERN }
    override var language: Language { return .german }
    
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
        result.tags[.deFromYearParser] = true
        return result
    }
}
