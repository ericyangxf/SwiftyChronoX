//
//  ZHSingleDateDefaultEndRefiner.swift
//  SwiftyChrono
//
//  Sets end = start for single ZH date results that should represent a single day.
//

import Foundation

class ZHSingleDateDefaultEndRefiner: Refiner {
    override public func refine(text: String, results: [ParsedResult], opt: [OptionType: Int]) -> [ParsedResult] {
        var refinedResults = [ParsedResult]()

        for var result in results {
            if result.end != nil {
                refinedResults.append(result)
                continue
            }

            // Month-only results get end = last day of month
            if result.tags[.zhMonthNameParser] ?? false {
                result.end = result.start.clone()
                let daysInMonth = result.start.date.numberOf(.day, inA: .month) ?? 0
                if daysInMonth > 0 {
                    result.end?.assign(.day, value: daysInMonth)
                }
                refinedResults.append(result)
                continue
            }

            // Single-day results: set end = start
            if (result.tags[.zhHantDateParser] ?? false) ||
                (result.tags[.zhHantCasualDateParser] ?? false) ||
                (result.tags[.zhHantWeekdayParser] ?? false) ||
                (result.tags[.enSlashDateFormatParser] ?? false) ||
                (result.tags[.enSlashDateFormatStartWithYearParser] ?? false) ||
                (result.tags[.enISOFormatParser] ?? false)
            {
                result.end = result.start.clone()
            }

            refinedResults.append(result)
        }

        return refinedResults
    }
}
