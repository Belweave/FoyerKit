//===--- TransitionContinuityTests.swift - FoyerKit -------------------------===//
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

import SwiftUI
import Testing
@testable import FoyerKit

/// Every picture after every other, turned as soon as allowed and long
/// after: the picture never jumps, and every outline stays finite.
@Suite struct TransitionContinuityTests {
    nonisolated static let pairs: [(FoyerPage.Visual, FoyerPage.Visual)] = FoyerPage.Visual.allCases.flatMap { first in
        FoyerPage.Visual.allCases.map { (first, $0) }
    }

    @Test(arguments: pairs)
    func pairNeverJumps(_ first: FoyerPage.Visual, _ second: FoyerPage.Visual) async {
        let outlines = await TestOutlines.all()
        for delay in [0.0, 1.7] {
            let run = WelcomeRun(
                pages: [TestPages.page(first), TestPages.page(second)],
                outlines: outlines,
                delay: { _ in delay }
            )
            let faults = await run.continuity.faults(from: 0, to: run.readyEnd)
            #expect(faults.isEmpty, "\(first) → \(second), turned \(delay)s after the text: \(faults.prefix(4))")
        }
    }

    @Test(arguments: FoyerPage.Visual.allCases)
    func pictureNeverJumpsOnAPhone(_ visual: FoyerPage.Visual) async {
        let outlines = await TestOutlines.all()
        let run = WelcomeRun(
            pages: [TestPages.page(visual), TestPages.page(visual)],
            size: CGSize(width: 390, height: 844),
            outlines: outlines
        )
        let faults = await run.continuity.faults(from: 0, to: run.readyEnd)
        #expect(faults.isEmpty, "\(visual) twice on a phone: \(faults.prefix(4))")
    }

    @Test(arguments: [[], ["Have a", "good trip"], ["A rather long line of words", "and another", "Orbit", "past three"]])
    func endingOfAnyWordsNeverJumps(words: [String]) async {
        let outlines = await TestOutlines.all()
        for size in [CGSize(width: 1200, height: 800), CGSize(width: 390, height: 844)] {
            let run = WelcomeRun(pages: [TestPages.page(.mark)], finale: words, size: size, outlines: outlines, delay: { _ in 0.5 })
            let faults = await run.continuity.faults(from: run.readyEnd, to: run.end)
            #expect(faults.isEmpty, "\(words) on \(size): \(faults.prefix(4))")
        }
    }

    @Test func endingNeverJumps() async {
        let outlines = await TestOutlines.all()
        let run = WelcomeRun(pages: [TestPages.page(.icon)], outlines: outlines, delay: { _ in 0.5 })
        let faults = await run.continuity.faults(from: run.readyEnd, to: run.end)
        #expect(faults.isEmpty, "the ending: \(faults.prefix(4))")
    }
}
