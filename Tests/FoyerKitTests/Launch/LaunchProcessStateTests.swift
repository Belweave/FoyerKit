//===--- LaunchProcessStateTests.swift - FoyerKit ---------------------------===//
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

@Suite struct LaunchProcessStateTests {
    @Test func onlyTheFirstClaimPlaysTheLaunch() {
        let state = LaunchProcessState()
        #expect(state.wouldPresentSequence(isAnimationEnabled: true))
        #expect(state.claimSequence() == .full)
        #expect(state.claimSequence() == .immediate)
        state.completeSequence()
        #expect(state.claimSequence() == .immediate)
        #expect(!state.wouldPresentSequence(isAnimationEnabled: true))
    }

    @Test func turnedOffAnimationSettlesAtOnce() {
        let state = LaunchProcessState()
        #expect(!state.wouldPresentSequence(isAnimationEnabled: false))
        #expect(state.claimSequence(isAnimationEnabled: false) == .immediate)
        #expect(state.claimSequence(isAnimationEnabled: true) == .immediate)
    }
}
