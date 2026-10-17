//===--- GlassLetteringTests.swift - FoyerKit -------------------------------===//
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

import CoreGraphics
import Testing
@testable import FoyerKit

@Suite struct GlassLetteringTests {
    @Test func wordsAreCenteredOnTheOrigin() {
        let path = GlassLettering.path(for: "Welcome", size: 100)
        let bounds = path.boundingRect
        #expect(!path.isEmpty)
        #expect(abs(bounds.midX) < 0.5 && abs(bounds.midY) < 0.5)
        #expect(bounds.width > bounds.height)
    }

    @Test func helloIsWrittenFromStartToEnd() {
        let layout = HelloLayout(restingFrame: CGRect(x: 0, y: 0, width: 420, height: 128))
        #expect(layout.centerline(through: 0).isEmpty)
        let whole = layout.centerline(through: 1)
        #expect(!whole.isEmpty)
        #expect(whole.boundingRect.width > 380)
    }
}
