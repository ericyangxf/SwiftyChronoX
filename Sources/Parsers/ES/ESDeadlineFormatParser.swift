//
//  ESDeadlineFormatParser.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 2/6/17.
//  Copyright © 2017 Potix. All rights reserved.
//

import Foundation

private let PATTERN = "(\\W|^)(dentro\\s*de|en)\\s*(\(ES_INTEGER_WORDS_PATTERN)|[0-9]+|medi[oa]|unos?|unas?|algunos?|algunas?)\\s*(minutos?|horas?|d[ií]as?|semanas?|mes(?:es)?|a[ñn]os?)\\s*(?=(?:\\W|$))"



public class ESDeadlineFormatParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .spanish }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        result.tags[.esDeadlineFormatParser] = true
        
        let number: Int
        let numberText = match.string(from: text, atRangeIndex: 3).lowercased()
        if let n = ES_INTEGER_WORDS[numberText] {
            number = n
        } else if NSRegularExpression.isMatch(forPattern: "medi", in: numberText) {
            number = HALF
        } else if NSRegularExpression.isMatch(forPattern: "unos|unas|algunos|algunas", in: numberText) {
            number = 3
        } else {
            number = Int(numberText) ?? 1
        }

        var date = ref
        let unitText = match.string(from: text, atRangeIndex: 4).lowercased()
        func ymdResult() -> ParsedResult {
            result.start.assign(.year, value: date.year)
            result.start.assign(.month, value: date.month)
            result.start.assign(.day, value: date.day)
            return result
        }
        if NSRegularExpression.isMatch(forPattern: "d[ií]a", in: unitText) {
            date = number != HALF ? date.added(number, .day) : date.added(12, .hour)
            return ymdResult()
        } else if NSRegularExpression.isMatch(forPattern: "semana", in: unitText) {
            date = number != HALF ? date.added(number * 7, .day) : date.added(3, .day).added(12, .hour)
            return ymdResult()
        } else if NSRegularExpression.isMatch(forPattern: "mes", in: unitText) {
            date = number != HALF ? date.added(number, .month) : date.added((date.numberOf(.day, inA: .month) ?? 30)/2, .day)
            return ymdResult()
        } else if NSRegularExpression.isMatch(forPattern: "a[ñn]o", in: unitText) {
            date = number != HALF ? date.added(number, .year) : date.added(6, .month)
            return ymdResult()
        }

        if NSRegularExpression.isMatch(forPattern: "hora", in: unitText) {
            date = number != HALF ? date.added(number, .hour) : date.added(30, .minute)
        } else if NSRegularExpression.isMatch(forPattern: "minuto", in: unitText) {
            date = number != HALF ? date.added(number, .minute) : date.added(30, .second)
        }

        result.start.imply(.year, to: date.year)
        result.start.imply(.month, to: date.month)
        result.start.imply(.day, to: date.day)
        result.start.assign(.hour, value: date.hour)
        result.start.assign(.minute, value: date.minute)

        return result
    }
}

