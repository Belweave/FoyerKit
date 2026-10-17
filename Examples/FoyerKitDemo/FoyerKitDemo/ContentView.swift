//===--- ContentView.swift - FoyerKit ---------------------------------------===//
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

import FoyerKit
import SwiftUI

/// The demo: adjust the intro, play it, and land in the app it opens onto.
struct ContentView: View {
    @State private var settings = IntroSettings()
    /// Whether the intro plays. The kit sets it back to false when the intro
    /// ends.
    @State private var showsIntro = false
    /// Whether the app the intro opens onto is shown, rather than the
    /// settings.
    @State private var showsApp = false

    var body: some View {
        NavigationStack {
            if showsApp {
                HelloView(appName: settings.appName) {
                    showsApp = false
                }
            } else {
                SettingsView(settings: settings) {
                    showsApp = true
                    showsIntro = true
                }
            }
        }
        #if os(macOS)
        .frame(minWidth: 640, minHeight: 520)
        #endif
        .foyer(settings.intro, isPresented: $showsIntro)
        #if DEBUG
        .onAppear {
            // Automated screenshots only; see DemoAutomation.
            if DemoAutomation.apply(to: settings) {
                showsApp = true
                showsIntro = true
            }
        }
        #endif
    }
}

#Preview {
    ContentView()
}
