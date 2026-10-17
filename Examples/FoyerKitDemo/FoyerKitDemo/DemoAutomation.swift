//===--- DemoAutomation.swift - FoyerKit ------------------------------------===//
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
import Foundation

/// A debug-only hook for automated screenshots: launched with
/// `-FoyerDemoPage <page>`, the demo plays an intro straight away instead of
/// opening on its settings.
///
/// - A page name (`greeting`, `mark`, `symbols`, `scene`, `graph`,
///   `physics`, `icon`, `card`) plays a welcome of that one page, which
///   rests on it.
/// - `all` plays the demo's default welcome.
///
/// ```sh
/// xcrun simctl launch booted com.example.FoyerKitDemo -FoyerDemoPage symbols
/// ```
enum DemoAutomation {
    /// The value of `-FoyerDemoPage`, read from the launch arguments.
    static var requestedPage: String? {
        UserDefaults.standard.string(forKey: "FoyerDemoPage")
    }

    /// Sets `settings` up for the requested page. Returns whether an intro
    /// should play at once.
    @MainActor
    static func apply(to settings: IntroSettings) -> Bool {
        guard let requested = requestedPage else {
            return false
        }
        // Clean frames: no Skip button and no haptics.
        settings.allowsSkipping = false
        settings.playsHaptics = false
        if let kind = PageKind(rawValue: requested) {
            settings.pages = [kind]
        }
        return true
    }
}
#endif
