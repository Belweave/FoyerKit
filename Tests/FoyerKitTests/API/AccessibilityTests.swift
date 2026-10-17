//===--- AccessibilityTests.swift - FoyerKit --------------------------------===//
//
// This source file is part of FoyerKit, a belweave open source project.
//
// Copyright (c) 2026 belweave (Preetham Kyanam)
// Licensed under the Apache License, Version 2.0
//
// See LICENSE for license information
//
//===----------------------------------------------------------------------===//

import Foundation
import SwiftUI
import Testing
@testable import FoyerKit

@Suite struct AccessibilityTests {
    @Test func defaultsFollowTheSystem() {
        let options = FoyerAccessibility.standard
        #expect(options.maximumDynamicTypeSize == .accessibility3)
        #expect(options.adaptsToReduceTransparency)
        #expect(options.adaptsToIncreasedContrast)
        #expect(options.movesFocusToEachPage)
        #expect(options.allowsEscapeToSkip)
    }

    @Test func reduceTransparencyDrawsSolidGlassAndRaisesContrast() {
        let plain = IntroLegibility(reducesTransparency: false, increasesContrast: false, options: .standard)
        #expect(!plain.drawsSolidGlass && !plain.raisesContrast)
        #expect(plain == .standard)

        let reduced = IntroLegibility(reducesTransparency: true, increasesContrast: false, options: .standard)
        #expect(reduced.drawsSolidGlass)
        #expect(reduced.raisesContrast)
        #expect(reduced.messageOpacity > plain.messageOpacity)
    }

    @Test func increasedContrastBrightensTextWithoutChangingGlass() {
        let contrast = IntroLegibility(reducesTransparency: false, increasesContrast: true, options: .standard)
        #expect(!contrast.drawsSolidGlass)
        #expect(contrast.raisesContrast)
        for current in 0..<4 {
            for index in 0..<4 {
                #expect(contrast.dotOpacity(index: index, current: current)
                    >= IntroLegibility.standard.dotOpacity(index: index, current: current))
            }
        }
    }

    @Test func adaptationsCanBeTurnedOff() {
        let off = FoyerAccessibility(adaptsToReduceTransparency: false, adaptsToIncreasedContrast: false)
        let legibility = IntroLegibility(reducesTransparency: true, increasesContrast: true, options: off)
        #expect(!legibility.drawsSolidGlass && !legibility.raisesContrast)
    }

    @Test func pageIndicatorKeepsItsOrder() {
        let legibility = IntroLegibility.standard
        let current = legibility.dotOpacity(index: 2, current: 2)
        let seen = legibility.dotOpacity(index: 1, current: 2)
        let ahead = legibility.dotOpacity(index: 3, current: 2)
        #expect(current > seen && seen > ahead)
    }

    @Test func solidGlassStaysVisibleAndBounded() {
        let legibility = IntroLegibility.standard
        #expect(legibility.solidGlassOpacity(tint: 0) > 0.2)
        #expect(legibility.solidGlassOpacity(tint: -1) == legibility.solidGlassOpacity(tint: 0))
        #expect(legibility.solidGlassOpacity(tint: 10) <= 0.9)
        #expect(legibility.solidGlassOpacity(tint: 0.4) > legibility.solidGlassOpacity(tint: 0.1))
    }
}

@Suite struct OptionTests {
    @Test func newOptionsHaveQuietDefaults() {
        let intro = Foyer(appName: "Orbit", pages: [.greeting("A", message: "a")])
        #expect(!intro.allowsSkipping)
        #expect(intro.playsHaptics)
        #expect(intro.onFinish == nil)
        #expect(intro.accessibility == .standard)
    }

    @Test func contentCarriesAccessibilityAndHaptics() {
        let options = FoyerAccessibility(maximumDynamicTypeSize: .xxxLarge, movesFocusToEachPage: false)
        let intro = Foyer(
            appName: "Orbit",
            pages: [.greeting("A", message: "a")],
            accessibility: options,
            playsHaptics: false
        )
        let content = WelcomeContent(intro)
        #expect(content.accessibility == options)
        #expect(!content.playsHaptics)
    }

    @Test func outcomeReportsHowThePlayEnded() {
        #expect(Foyer.Outcome(skipped: true, presentedWelcome: true) == .skipped)
        #expect(Foyer.Outcome(skipped: true, presentedWelcome: false) == .skipped)
        #expect(Foyer.Outcome(skipped: false, presentedWelcome: true) == .finished)
        #expect(Foyer.Outcome(skipped: false, presentedWelcome: false) == .launchOnly)
    }

    @Test func onFinishIsCalledWithTheOutcome() {
        var received: [Foyer.Outcome] = []
        let intro = Foyer(appName: "Orbit", pages: []) { received.append($0) }
        intro.onFinish?(.skipped)
        #expect(received == [.skipped])
    }

    @Test func pagesCanDescribeTheirPictures() {
        let plain = FoyerPage.greeting("A", message: "a")
        #expect(plain.pictureDescription == nil)
        let described = plain.pictureDescription(Text("A hand writing hello in glass."))
        #expect(described.pictureDescription != nil)
        #expect(described.visual == .greeting)
    }
}
