//
//  BackwardDateRefiner.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 1/24/17.
//  Copyright © 2017 Potix. All rights reserved.
//

import Foundation

class BackwardDateRefiner: Refiner {
    override public func refine(text: String, results: [ParsedResult], opt: [OptionType: Int]) -> [ParsedResult] {
        if !opt.keys.contains(.backwardDate) && !opt.keys.contains(.backwardDate) {
            return results
        }
        
        let resultsLength = results.count
        var newResults = [ParsedResult]()
        
        var i = 0
        while i < resultsLength {
            var result = results[i]
            var refMoment = result.ref
            
            if /*result.start.isCertain(component: .day) &&*/ result.start.isCertain(component: .month) &&
                !result.start.isCertain(component: .year) && result.start.moment.isAfter(refMoment) {
                // Adjust year into the past
                for _ in 0..<3 {
                    if !result.start.moment.isAfter(refMoment) {
                        break
                    }
                    
                    result.start.imply(.year, to: result.start[.year]! - 1)
                    if result.end != nil && !result.end!.isCertain(component: .year) {
                        result.end!.imply(.year, to: result.end![.year]! - 1)
                    }
                }
                
                result.tags[.backwardDateRefiner] = true
            }
            
            if !result.start.isCertain(component: .day) && !result.start.isCertain(component: .month) &&
                !result.start.isCertain(component: .year) && result.start.isCertain(component: .weekday) &&
                result.start.moment.isAfter(refMoment)
            {
                // Adjust date to the previous week
                let weekday = result.start[.weekday]!
                
                let shouldAdjustWeekday: Bool = refMoment.weekday < weekday
                
                // Adjust start date
                refMoment = refMoment.setOrAdded(
                    shouldAdjustWeekday ? weekday - 7 : weekday,
                    .weekday)
                
                result.start.imply(.day, to: refMoment.day)
                result.start.imply(.month, to: refMoment.month)
                result.start.imply(.year, to: refMoment.year)
                
                // Adjust end date
                if let resultEnd = result.end {
                    var refMomentEnd = result.ref
                    let weekdayEnd = resultEnd[.weekday]!
                    
                    refMomentEnd = refMomentEnd.setOrAdded(
                        shouldAdjustWeekday ? weekdayEnd - 7 : weekdayEnd,
                        .weekday)
                    
                    result.end?.imply(.day, to: refMomentEnd.day)
                    result.end?.imply(.month, to: refMomentEnd.month)
                    result.end?.imply(.year, to: refMomentEnd.year)
                }
                
                result.tags[.backwardDateRefiner] = true
            }
            
            newResults.append(result)
            i += 1
        }
        
        return newResults
    }
}
