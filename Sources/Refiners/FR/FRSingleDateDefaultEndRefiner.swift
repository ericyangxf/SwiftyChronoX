//
//  FRSingleDateDefaultEndRefiner.swift
//  SwiftyChrono
//
//  Created by Codex on 2026-02-09.
//

import Foundation

class FRSingleDateDefaultEndRefiner: Refiner {
    override public func refine(text: String, results: [ParsedResult], opt: [OptionType: Int]) -> [ParsedResult] {
        var refinedResults = [ParsedResult]()

        for var result in results {
            if result.end != nil {
                refinedResults.append(result)
                continue
            }

            if result.tags[.frMonthNameParser] ?? false {
                result.end = result.start.clone()
                let daysInMonth = result.start.date.numberOf(.day, inA: .month) ?? 0
                if daysInMonth > 0 {
                    result.end?.assign(.day, value: daysInMonth)
                }
                refinedResults.append(result)
                continue
            }

            if (result.tags[.frMonthNameLittleEndianParser] ?? false) ||
                (result.tags[.frSlashDateFormatParser] ?? false) ||
                (result.tags[.frCasualDateParser] ?? false) ||
                (result.tags[.frWeekdayParser] ?? false) ||
                (result.tags[.enISOFormatParser] ?? false) ||
                (result.tags[.enSlashDateFormatParser] ?? false) ||
                (result.tags[.enSlashDateFormatStartWithYearParser] ?? false)
            {
                result.end = result.start.clone()
            }

            refinedResults.append(result)
        }

        return refinedResults
    }
}
