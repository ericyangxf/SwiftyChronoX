//
//  ESYearParsers.swift
//  SwiftyChrono
//
//  Created by Codex on 2025-01-13.
//

import Foundation

private let YEAR_PATTERN = "(^|\\s)(?:en|durante|para)\\s+(?:el\\s+)?(?:a(?:\\u00f1|n)o\\s+)?([1-2]\\d{3})" +
    "(?!\\s*[-/\\.]\\s*\\d)(?=\\b|\\s|$)"
private let THIS_YEAR_PATTERN = "(^|\\s)este\\s+a(?:\\u00f1|n)o(?=\\b|\\s|$)"
private let LAST_YEAR_PATTERN = "(^|\\s)(?:el\\s+)?a(?:\\u00f1|n)o\\s+pasado(?=\\b|\\s|$)"
private let SINCE_YEAR_PATTERN = "(^|\\s)desde\\s+(?:el\\s+)?(?:a(?:\\u00f1|n)o\\s+)?([1-2]\\d{3})" +
    "(?!\\s*[-/\\.]\\s*\\d)(?=\\b|\\s|$)"
private let FROM_YEAR_PATTERN = "(^|\\s)a\\s+partir\\s+de\\s+(?:el\\s+)?(?:a(?:\\u00f1|n)o\\s+)?([1-2]\\d{3})" +
    "(?!\\s*[-/\\.]\\s*\\d)(?=\\b|\\s|$)"

private let yearGroup = 2

public class ESYearParser: Parser {
    override var pattern: String { return YEAR_PATTERN }
    override var language: Language { return .spanish }
    
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
        result.tags[.esYearParser] = true
        return result
    }
}

public class ESThisYearParser: Parser {
    override var pattern: String { return THIS_YEAR_PATTERN }
    override var language: Language { return .spanish }
    
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
        
        result.tags[.esThisYearParser] = true
        return result
    }
}

public class ESLastYearParser: Parser {
    override var pattern: String { return LAST_YEAR_PATTERN }
    override var language: Language { return .spanish }
    
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
        
        result.tags[.esLastYearParser] = true
        return result
    }
}

public class ESSinceYearParser: Parser {
    override var pattern: String { return SINCE_YEAR_PATTERN }
    override var language: Language { return .spanish }
    
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
        result.tags[.esSinceYearParser] = true
        return result
    }
}

public class ESFromYearParser: Parser {
    override var pattern: String { return FROM_YEAR_PATTERN }
    override var language: Language { return .spanish }
    
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
        result.tags[.esFromYearParser] = true
        return result
    }
}
