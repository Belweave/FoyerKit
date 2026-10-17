//===--- Foyer.swift - FoyerKit ---------------------------------------------===//
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

/// Everything an intro shows: the launch, where your mark comes up on
/// frosted glass, and the welcome, where it turns to glass and tells your
/// app's story a page at a time, ending in a few words of glass and the mark
/// in colour.
///
/// ```swift
/// ContentView()
///     .foyer(Foyer(
///         appName: "Orbit",
///         mark: .symbol("globe.americas.fill", color: .blue),
///         pages: [
///             .greeting("Welcome to Orbit", message: "Plan trips together."),
///             .symbols("Everything in Reach", message: "Maps, photos, and notes."),
///             .icon("Ready When You Are", message: "Packed and ready to go."),
///         ],
///         finale: ["Have a", "good trip"]
///     ))
/// ```
public struct Foyer {
    /// When the welcome plays.
    public enum WelcomeSchedule: Sendable {
        /// Once, on the first launch; never again after it has been shown
        /// or skipped.
        case firstLaunchOnly
        /// On every launch.
        case everyLaunch
        /// Never; only the launch plays.
        case never
    }

    /// How the launch begins.
    public enum Opening: Sendable {
        /// Straight from the mark: it comes up on frosted glass over the
        /// app, then carries on into the welcome, or dissolves.
        case mark
        /// With the opening stage: rings and lines are drawn in the launch
        /// colour, white spreads across the window, and closes onto the
        /// mark.
        case stage
    }

    /// How a play of the intro ended, reported to ``onFinish``.
    nonisolated public enum Outcome: Sendable, Equatable {
        /// The welcome played through its ending, and the app was revealed.
        case finished
        /// The intro was skipped: with the Skip button, the VoiceOver
        /// escape gesture, or Escape on macOS.
        case skipped
        /// Only the launch played; there was no welcome to show.
        case launchOnly

        init(skipped: Bool, presentedWelcome: Bool) {
            if skipped {
                self = .skipped
            } else {
                self = presentedWelcome ? .finished : .launchOnly
            }
        }
    }

    /// The app's name, the last word of the ending by default.
    public var appName: String
    /// The app's mark, which the launch opens on and the welcome turns to
    /// glass.
    public var mark: FoyerMark
    /// The welcome's pages, in any order.
    public var pages: [FoyerPage]
    /// The words that turn in, one after another, in glass once the last
    /// page's button is pressed, before the mark fills with colour. Each is
    /// one line, and three at most are shown; the last is the line's
    /// subject. Empty, the mark fills with colour straight away.
    public var finale: [String]
    /// The last page's line, above its button.
    public var startTitle: Text
    /// The last page's button, which plays the ending.
    public var startButton: Text
    /// The button on every other page, unless the page has its own.
    public var continueButton: Text
    /// The opening stage's colour, with `opening: .stage`.
    public var tint: Color
    /// What the window shows behind the launch, before the app appears.
    public var background: Color
    /// When the welcome plays at launch. A replay with `isPresented` plays
    /// it unless the schedule is `never`.
    public var welcome: WelcomeSchedule
    /// How the launch begins: straight from the mark, or with the opening
    /// stage drawn first.
    public var opening: Opening
    /// Whether the launch plays when the welcome does not. It plays once
    /// per process, in the first window that asks for it.
    public var playsLaunchAnimation: Bool
    /// Where the intro records that the welcome was shown.
    public var storage: FoyerStorage
    /// Whether the welcome shows a Skip button in its top corner. VoiceOver
    /// users can always skip with the escape gesture, and Mac users with
    /// Escape, unless ``FoyerAccessibility/allowsEscapeToSkip`` is off.
    public var allowsSkipping: Bool
    /// The Skip button's label, with `allowsSkipping`.
    public var skipButton: Text
    /// How the intro adapts to Dynamic Type, Reduce Transparency, Increase
    /// Contrast, and VoiceOver.
    public var accessibility: FoyerAccessibility
    /// Whether a light haptic marks each page as it settles, on devices
    /// that have haptics.
    public var playsHaptics: Bool
    /// Called on the main actor each time a play of the intro ends, once
    /// the app has been revealed.
    public var onFinish: (@MainActor (Outcome) -> Void)?

    /// An intro of `pages`.
    ///
    /// - Parameters:
    ///   - appName: The app's name, the last word of the ending by default.
    ///   - mark: The app's mark; by default ``FoyerMark/standard``.
    ///   - pages: The welcome's pages, in any order.
    ///   - finale: The words of the ending; by default "Welcome", "to", and
    ///     `appName`. Pass `[]` for none.
    ///   - startTitle: The last page's line; by default "Let's Begin".
    ///   - startButton: The last page's button; by default "Get Started".
    ///   - continueButton: The button on every other page; by default
    ///     "Continue". A page can have its own.
    ///   - tint: The opening stage's colour, with `opening: .stage`.
    ///   - background: What the window shows behind the launch.
    ///   - welcome: When the welcome plays at launch.
    ///   - opening: How the launch begins; by default straight from the mark.
    ///   - playsLaunchAnimation: Whether the launch plays when the welcome
    ///     does not.
    ///   - storage: Where the intro records that the welcome was shown.
    ///   - allowsSkipping: Whether the welcome shows a Skip button.
    ///   - skipButton: The Skip button's label; by default "Skip".
    ///   - accessibility: How the intro adapts to accessibility settings.
    ///   - playsHaptics: Whether a light haptic marks each page.
    ///   - onFinish: Called each time a play of the intro ends.
    public init(
        appName: String,
        mark: FoyerMark = .standard,
        pages: [FoyerPage],
        finale: [String]? = nil,
        startTitle: Text? = nil,
        startButton: Text? = nil,
        continueButton: Text? = nil,
        tint: Color = .accentColor,
        background: Color = Foyer.defaultBackground,
        welcome: WelcomeSchedule = .firstLaunchOnly,
        opening: Opening = .mark,
        playsLaunchAnimation: Bool = true,
        storage: FoyerStorage = .standard,
        allowsSkipping: Bool = false,
        skipButton: Text? = nil,
        accessibility: FoyerAccessibility = .standard,
        playsHaptics: Bool = true,
        onFinish: (@MainActor (Outcome) -> Void)? = nil
    ) {
        self.appName = appName
        self.mark = mark
        self.pages = pages
        self.finale = finale ?? Self.defaultFinale(appName: appName)
        self.startTitle = startTitle ?? Text("Let's Begin", bundle: .module)
        self.startButton = startButton ?? Text("Get Started", bundle: .module)
        self.continueButton = continueButton ?? Text("Continue", bundle: .module)
        self.tint = tint
        self.background = background
        self.welcome = welcome
        self.opening = opening
        self.playsLaunchAnimation = playsLaunchAnimation
        self.storage = storage
        self.allowsSkipping = allowsSkipping
        self.skipButton = skipButton ?? Text("Skip", bundle: .module)
        self.accessibility = accessibility
        self.playsHaptics = playsHaptics
        self.onFinish = onFinish
    }

    /// The window's own background colour.
    public static var defaultBackground: Color {
        #if os(macOS)
        Color(nsColor: .windowBackgroundColor)
        #else
        Color(uiColor: .systemBackground)
        #endif
    }

    /// Forgets that the welcome was shown, so it plays on the next launch.
    public static func resetWelcome(storage: FoyerStorage = .standard) {
        storage.hasSeenWelcome = false
    }

    nonisolated static func defaultFinale(appName: String) -> [String] {
        ["Welcome", "to", appName]
    }

    /// Whether the welcome plays at this launch.
    var isWelcomePending: Bool {
        guard !pages.isEmpty else {
            return false
        }
        switch welcome {
        case .firstLaunchOnly:
            return !storage.hasSeenWelcome
        case .everyLaunch:
            return true
        case .never:
            return false
        }
    }
}
