//
//  FR_TimeParsingTests.swift
//  SwiftyChrono
//
//  Comprehensive test cases for French time parsing
//

import Foundation
import Testing
@testable import SwiftyChrono

struct FR_TimeParsingTests {

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
        let chrono = Chrono(preferredLanguage: .french)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "J'ai une réunion aujourd'hui à 10h30", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.year == 2026)
        #expect(components.month == 1)
        #expect(components.day == 20)
        #expect(components.hour == 10)
        #expect(components.minute == 30)
    }

    @Test func test002_TomorrowAt2PM() async throws {
        let chrono = Chrono(preferredLanguage: .french)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "On se voit demain à 14h00", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.year == 2026)
        #expect(components.month == 1)
        #expect(components.day == 21)
        #expect(components.hour == 14)
        #expect(components.minute == 0)
    }

    @Test func test003_At9AM() async throws {
        let chrono = Chrono(preferredLanguage: .french)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "La réunion commence à 9h00", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 9)
        #expect(components.minute == 0)
    }

    @Test func test004_At5PM() async throws {
        let chrono = Chrono(preferredLanguage: .french)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Dîner à 17h30", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 17)
        #expect(components.minute == 30)
    }

    @Test func test005_MondayAt3PM() async throws {
        let chrono = Chrono(preferredLanguage: .french)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Réunion lundi à 15h00", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 15)
        #expect(components.minute == 0)
    }

    @Test func test006_January15At11AM() async throws {
        let chrono = Chrono(preferredLanguage: .french)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Rendez-vous le 15 janvier à 11h00", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.year == 2026)
        #expect(components.month == 1)
        #expect(components.day == 15)
        #expect(components.hour == 11)
        #expect(components.minute == 0)
    }

    @Test func test007_At8AM() async throws {
        let chrono = Chrono(preferredLanguage: .french)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Petit-déjeuner à 8h00", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 8)
        #expect(components.minute == 0)
    }

    @Test func test008_At6PM() async throws {
        let chrono = Chrono(preferredLanguage: .french)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Rencontre à 18h15", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 18)
        #expect(components.minute == 15)
    }

    @Test func test009_NextWeekAt10AM() async throws {
        let chrono = Chrono(preferredLanguage: .french)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Révision lundi prochain à 10h00", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 10)
        #expect(components.minute == 0)
    }

    @Test func test010_At12PM() async throws {
        let chrono = Chrono(preferredLanguage: .french)
        let refDate = createRefDate(year: 2026, month: 1, day: 20)
        let result = chrono.parse(text: "Déjeuner à 12h30", refDate: refDate)
        let date = try #require(result.first?.start.date)
        let components = timeComponents(date: date)
        #expect(components.hour == 12)
        #expect(components.minute == 30)
    }
}
