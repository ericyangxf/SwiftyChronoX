//
//  DE_TimeParsingTests.swift
//  SwiftyChrono
//
//  Comprehensive test cases for German time parsing
//

import Foundation
import Testing
@testable import SwiftyChronoX

struct DE_TimeParsingTests {

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
        let chrono = Chrono(preferredLanguage: .german)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Ich habe heute um 10:30 Uhr ein Meeting", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.year == 2026)
        #expect(components.month == 1)
        #expect(components.day == 20)
        #expect(components.hour == 10)
        #expect(components.minute == 30)
    }

    @Test func test002_TomorrowAt2PM() async throws {
        let chrono = Chrono(preferredLanguage: .german)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Lass uns morgen um 14:00 Uhr treffen", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.year == 2026)
        #expect(components.month == 1)
        #expect(components.day == 21)
        #expect(components.hour == 14)
        #expect(components.minute == 0)
    }

    @Test func test003_At9AM() async throws {
        let chrono = Chrono(preferredLanguage: .german)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Das Meeting beginnt um 9:00 Uhr", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 9)
        #expect(components.minute == 0)
    }

    @Test func test004_At5PM() async throws {
        let chrono = Chrono(preferredLanguage: .german)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Abendessen um 17:30 Uhr", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 17)
        #expect(components.minute == 30)
    }

    @Test func test005_MondayAt3PM() async throws {
        let chrono = Chrono(preferredLanguage: .german)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Meeting am Montag um 15:00 Uhr", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 15)
        #expect(components.minute == 0)
    }

    @Test func test006_January15At11AM() async throws {
        let chrono = Chrono(preferredLanguage: .german)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Termin am 15. Januar um 11:00 Uhr", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.year == 2026)
        #expect(components.month == 1)
        #expect(components.day == 15)
        #expect(components.hour == 11)
        #expect(components.minute == 0)
    }

    @Test func test007_At8AM() async throws {
        let chrono = Chrono(preferredLanguage: .german)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Frühstück um 8:00 Uhr", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 8)
        #expect(components.minute == 0)
    }

    @Test func test008_At6PM() async throws {
        let chrono = Chrono(preferredLanguage: .german)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Treffen um 18:15 Uhr", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 18)
        #expect(components.minute == 15)
    }

    @Test func test009_NextWeekAt10AM() async throws {
        let chrono = Chrono(preferredLanguage: .german)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Überprüfung nächsten Montag um 10:00 Uhr", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 10)
        #expect(components.minute == 0)
    }

    @Test func test010_At12PM() async throws {
        let chrono = Chrono(preferredLanguage: .german)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Mittagessen um 12:30 Uhr", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 12)
        #expect(components.minute == 30)
    }
}
