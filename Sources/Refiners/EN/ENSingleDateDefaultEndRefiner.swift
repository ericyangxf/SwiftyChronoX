//
//  ENSingleDateDefaultEndRefiner.swift
//  SwiftyChrono
//
//  Created by Codex on 2026-02-09.
//

import Foundation

class ENSingleDateDefaultEndRefiner: Refiner {
    override public func refine(text: String, results: [ParsedResult], opt: [OptionType: Int]) -> [ParsedResult] {
        var refinedResults = [ParsedResult]()

        for var result in results {
            if result.end != nil {
                refinedResults.append(result)
                continue
            }

            if result.tags[.enMonthNameParser] ?? false {
                result.end = result.start.clone()
                let daysInMonth = result.start.date.numberOf(.day, inA: .month) ?? 0
                if daysInMonth > 0 {
                    result.end?.assign(.day, value: daysInMonth)
                }
                refinedResults.append(result)
                continue
            }

            if (result.tags[.enMonthNameMiddleEndianParser] ?? false) ||
                (result.tags[.enMonthNameLittleEndianParser] ?? false) ||
                (result.tags[.enSlashDateFormatParser] ?? false) ||
                (result.tags[.enSlashDateFormatStartWithYearParser] ?? false) ||
                (result.tags[.enISOFormatParser] ?? false) ||
                (result.tags[.enCasualDateParser] ?? false) ||
                (result.tags[.enCasualTimeParser] ?? false) ||
                (result.tags[.enWeekdayParser] ?? false)
            {
                result.end = result.start.clone()
            }

            refinedResults.append(result)
        }

        return refinedResults
    }
}
