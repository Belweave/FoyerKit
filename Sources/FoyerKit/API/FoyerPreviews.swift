//===--- FoyerPreviews.swift - FoyerKit -------------------------------------===//
//
// This source file is part of FoyerKit, a belweave open source project.
//
// Copyright (c) 2026 belweave (Preetham Kyanam)
// Licensed under the Apache License, Version 2.0
//
// See LICENSE for license information
//
//===----------------------------------------------------------------------===//

#if DEBUG
import SwiftUI

/// Xcode previews of common setups, to try the intro without an app.
/// Each preview replays its intro from a button, and plays the welcome on
/// every run so nothing is remembered between previews.
private struct FoyerPreviewHost: View {
    let intro: Foyer
    @State private var showsIntro = true

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.largeTitle)
                .accessibilityHidden(true)
            Text(verbatim: intro.appName)
                .font(.title.bold())
            Button("Play Again") { showsIntro = true }
                .buttonStyle(.glass)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foyer(intro, isPresented: $showsIntro)
    }
}

private extension Foyer {
    static func preview(
        pages: [FoyerPage],
        mark: FoyerMark = .standard,
        finale: [String]? = nil,
        allowsSkipping: Bool = true
    ) -> Foyer {
        Foyer(
            appName: "Orbit",
            mark: mark,
            pages: pages,
            finale: finale,
            welcome: .everyLaunch,
            storage: FoyerStorage(defaults: .standard, key: "Foyer.preview.hasSeenWelcome"),
            allowsSkipping: allowsSkipping
        )
    }
}

#Preview("Three pages") {
    FoyerPreviewHost(intro: .preview(pages: [
        .greeting("Welcome to Orbit", message: "Plan trips with the people you travel with."),
        .symbols("Everything in Reach", message: "Maps, photos, and notes gather around each trip."),
        .icon("Ready When You Are", message: "Packed and ready to go."),
    ]))
}

#Preview("Symbol mark and graph") {
    FoyerPreviewHost(intro: .preview(
        pages: [
            .mark("Simple, by Design", message: "Everything in one place."),
            .graph("Connected", message: "Plans flow into bookings.", graph: .chain(["calendar", "airplane", "bed.double.fill"])),
        ],
        mark: .symbol("globe.americas.fill", color: .blue),
        finale: ["Have a", "good trip"]
    ))
}

#Preview("Scene and physics") {
    FoyerPreviewHost(intro: .preview(pages: [
        .scene("Seen in Depth", message: "Turn it by dragging.", scene: FoyerScene(shape: .ring, color: .orange, motion: .float)),
        .physics("Feels Real", message: "Every node lands face up.", nodes: ["calendar", "envelope.fill", "bell.fill"]),
    ]))
}

#Preview("Largest text") {
    FoyerPreviewHost(intro: .preview(pages: [
        .greeting("Welcome to Orbit", message: "Titles and messages grow with Dynamic Type."),
    ]))
    .dynamicTypeSize(.accessibility3)
}
#endif
