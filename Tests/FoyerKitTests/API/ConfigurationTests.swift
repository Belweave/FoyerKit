//===--- ConfigurationTests.swift - FoyerKit --------------------------------===//
//
// This source file is part of FoyerKit, a belweave open source project.
//
// Copyright (c) 2026 belweave (Preetham Kyanam)
// Portions derived from an Apache 2.0 licensed project; its
// original copyright and attribution notices are kept in NOTICE.
// Copyright (c) 2026 Jiaxu Li
// Modified by belweave, 2026: renamed and changed; see CHANGES.md.
// Licensed under the Apache License, Version 2.0
//
// See LICENSE for license information
//
//===----------------------------------------------------------------------===//

import Foundation
import SwiftUI
import Testing
@testable import FoyerKit

@Suite struct ConfigurationTests {
    @Test func finaleWelcomesToTheApp() {
        let intro = Foyer(appName: "Orbit", pages: [])
        #expect(intro.finale == ["Welcome", "to", "Orbit"])
        #expect(Foyer(appName: "Orbit", pages: [], finale: ["Hi"]).finale == ["Hi"])
    }

    @Test func finaleCanBeYourOwnWordsOrNone() {
        let own = Foyer(appName: "Orbit", pages: [], finale: ["Have a", "good trip"])
        #expect(own.finale == ["Have a", "good trip"])
        let none = Foyer(appName: "Orbit", pages: [], finale: [])
        #expect(none.finale.isEmpty)
        // Without words, the ending goes straight to the mark in colour.
        let reveal = FinaleReveal(canvasSize: CGSize(width: 1200, height: 800), lines: none.finale)
        #expect(reveal.wordStarts.isEmpty && reveal.blackStart < 0.5)
    }

    @Test func welcomeScheduleAndStorage() throws {
        let suite = "FoyerKitTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let storage = FoyerStorage(defaults: defaults)
        let pages: [FoyerPage] = [.greeting("A", message: "a")]

        let firstLaunch = Foyer(appName: "Orbit", pages: pages, storage: storage)
        #expect(firstLaunch.isWelcomePending)
        storage.hasSeenWelcome = true
        #expect(!firstLaunch.isWelcomePending)
        #expect(Foyer(appName: "Orbit", pages: pages, welcome: .everyLaunch, storage: storage).isWelcomePending)
        #expect(!Foyer(appName: "Orbit", pages: pages, welcome: .never, storage: storage).isWelcomePending)
        Foyer.resetWelcome(storage: storage)
        #expect(firstLaunch.isWelcomePending)
        #expect(!Foyer(appName: "Orbit", pages: [], storage: storage).isWelcomePending)
    }

    @Test func contentTellsEachPictureWhatItNeeds() {
        let intro = Foyer(
            appName: "Orbit",
            mark: .symbol("globe.americas.fill"),
            pages: [
                .graph("E", message: "e", nodes: ["bolt.fill"]),
                .symbols("C", message: "c", symbols: ["star.fill", "leaf.fill", "star.fill"]),
                .greeting("A", message: "a"),
                .symbols("D", message: "d", symbols: ["bolt.fill"], center: "star.fill"),
            ]
        )
        let content = WelcomeContent(intro)
        #expect(content.pages.count == 4)
        #expect(content.readyIndex == 4)
        #expect(content.picture(at: 0) == .page(.graph))
        #expect(content.picture(at: 4) == .rest)
        #expect(content.centerSymbol(at: 1) == "globe.americas.fill")
        #expect(content.centerSymbol(at: 3) == "star.fill")
        #expect(content.centerSymbol(at: 0) == nil)
        let canvas = IntroCanvas(size: CGSize(width: 1200, height: 800), bodyDiameterRatio: 0.76)
        #expect(content.context(page: 0, canvas: canvas, outlines: [:], textTop: nil).symbols == ["bolt.fill"])
        #expect(content.tracedSymbols == ["globe.americas.fill", "star.fill", "leaf.fill", "bolt.fill"])
    }

    @Test func customMarksHaveNoSymbolToTrace() {
        let mark = FoyerMark.custom(outline: { rect, _ in Path(ellipseIn: rect) }) { Circle() }
        let content = WelcomeContent(Foyer(appName: "Orbit", mark: mark, pages: [.symbols("A", message: "a")]))
        #expect(content.centerSymbol(at: 0) == nil)
        #expect(content.tracedSymbols == FoyerPage.defaultScatterSymbols)
    }
}
