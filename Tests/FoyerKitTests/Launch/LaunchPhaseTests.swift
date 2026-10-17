//===--- LaunchPhaseTests.swift - FoyerKit ----------------------------------===//
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

import Testing
@testable import FoyerKit

@Suite struct LaunchPhaseTests {
    @Test func contentStaysCoveredUntilTheStageCloses() {
        for phase in LaunchPresentationPhase.allCases {
            let presentation = LaunchWorkspacePresentation(phase: phase, reducesMotion: false)
            let isCovered = phase.rawValue < LaunchPresentationPhase.logo.rawValue
            #expect(presentation.workspaceCoverOpacity == (isCovered ? 1 : 0))
            #expect(presentation.workspaceOpacity == (isCovered ? 0 : 1))
        }
    }

    @Test func theAppIsUsableOnlyOnceTheMarkHasGone() {
        for phase in LaunchPresentationPhase.allCases {
            let full = LaunchWorkspacePresentation(phase: phase, reducesMotion: false)
            #expect(full.isWorkspaceAvailable == (phase == .complete))

            let reduced = LaunchWorkspacePresentation(phase: phase, reducesMotion: true)
            let gone = phase.rawValue >= LaunchPresentationPhase.handoff.rawValue
            #expect(reduced.isWorkspaceAvailable == gone)
        }
    }

    @Test func reduceMotionShowsNoGlass() {
        for phase in LaunchPresentationPhase.allCases {
            let presentation = LaunchWorkspacePresentation(phase: phase, reducesMotion: true)
            #expect(presentation.frostedGlassOpacity == 0)
        }
    }

    @Test func windowChromeStaysHiddenWhileTheIntroPlays() {
        for reducesMotion in [false, true] {
            for phase in LaunchPresentationPhase.allCases {
                let presentation = LaunchWorkspacePresentation(phase: phase, reducesMotion: reducesMotion)
                // It returns before the app is revealed and stays from then on.
                let returned = phase.rawValue >= (reducesMotion ? LaunchPresentationPhase.handoff : .settling).rawValue
                #expect(presentation.hidesWindowChrome == !returned)
            }
            // The welcome plays in the logo phase, with the chrome hidden.
            #expect(LaunchWorkspacePresentation(phase: .logo, reducesMotion: reducesMotion).hidesWindowChrome)
        }
    }

    @Test func settledStageMatchesEachPhase() {
        #expect(OpeningStageProperties.settled(at: .background) == OpeningStageProperties())
        #expect(!OpeningStageProperties.settled(at: .construction).convertToLogo)
        #expect(OpeningStageProperties.settled(at: .logo).convertToLogo)
        #expect(!OpeningStageProperties.settled(at: .settling).dissolvesMark)
        #expect(OpeningStageProperties.settled(at: .complete).dissolvesMark)
    }
}
