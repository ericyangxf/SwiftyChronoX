//
//  JP_TimeParsingTests.swift
//  SwiftyChrono
//
//  Comprehensive test cases for Japanese time parsing
//

import Foundation
import Testing
@testable import SwiftyChronoX

struct JP_TimeParsingTests {

    // MARK: - Helper Functions

    func timeComponents(date: Date, calendar: Calendar = Calendar(identifier: .gregorian)) -> DateComponents {
        return calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
    }

    func createRefDate(year: Int, month: Int, day: Int, hour: Int = 12, minute: Int = 0) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return Calendar(identifier: .gregorian).date(from: components)!
    }

    // MARK: - Basic Time Tests

    @Test func test001_TodayAt10AM() async throws {
        let chrono = Chrono(preferredLanguage: .japanese)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "今日10時30分に会議があります", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.year == 2026)
        #expect(components.month == 1)
        #expect(components.day == 20)
        #expect(components.hour == 10)
        #expect(components.minute == 30)
    }

    @Test func test002_TomorrowAt2PM() async throws {
        let chrono = Chrono(preferredLanguage: .japanese)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "明日14時に会いましょう", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.year == 2026)
        #expect(components.month == 1)
        #expect(components.day == 21)
        #expect(components.hour == 14)
        #expect(components.minute == 0)
    }

    @Test func test003_At9AM() async throws {
        let chrono = Chrono(preferredLanguage: .japanese)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "会議は9時に始まります", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 9)
        #expect(components.minute == 0)
    }

    @Test func test004_At5PM() async throws {
        let chrono = Chrono(preferredLanguage: .japanese)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "17時30分に夕食", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 17)
        #expect(components.minute == 30)
    }

    @Test func test005_MondayAt3PM() async throws {
        let chrono = Chrono(preferredLanguage: .japanese)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "月曜日15時に会議", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 15)
        #expect(components.minute == 0)
    }

    @Test func test006_January15At11AM() async throws {
        let chrono = Chrono(preferredLanguage: .japanese)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "1月15日11時に予約", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.year == 2026)
        #expect(components.month == 1)
        #expect(components.day == 15)
        #expect(components.hour == 11)
        #expect(components.minute == 0)
    }

    @Test func test007_At8AM() async throws {
        let chrono = Chrono(preferredLanguage: .japanese)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "朝食は8時", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 8)
        #expect(components.minute == 0)
    }

    @Test func test008_At6PM() async throws {
        let chrono = Chrono(preferredLanguage: .japanese)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "18時15分に集合", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 18)
        #expect(components.minute == 15)
    }

    @Test func test009_NextWeekAt10AM() async throws {
        let chrono = Chrono(preferredLanguage: .japanese)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "次の月曜日10時にレビュー", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 10)
        #expect(components.minute == 0)
    }

    @Test func test010_At12PM() async throws {
        let chrono = Chrono(preferredLanguage: .japanese)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "12時30分に昼食", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 12)
        #expect(components.minute == 30)
    }
}
