//===--- FoyerAccessibility.swift - FoyerKit --------------------------------===//
//
// This source file is part of FoyerKit, a belweave open source project.
//
// Copyright (c) 2026 belweave (Preetham Kyanam)
// Licensed under the Apache License, Version 2.0
//
// See LICENSE for license information
//
//===----------------------------------------------------------------------===//

import SwiftUI

/// How an intro adapts to the person watching it.
///
/// The defaults follow the system settings; change one only when your
/// design truly needs it.
///
/// ```swift
/// Foyer(
///     appName: "Orbit",
///     pages: pages,
///     accessibility: FoyerAccessibility(maximumDynamicTypeSize: .accessibility2)
/// )
/// ```
nonisolated public struct FoyerAccessibility: Sendable, Equatable {
    /// The largest Dynamic Type size the page text grows to. Titles and
    /// messages scale with the person's text size up to this size, so the
    /// text still fits above the picture.
    public var maximumDynamicTypeSize: DynamicTypeSize
    /// Whether glass is drawn as solid, high-contrast shapes, and frosted
    /// layers as opaque ones, when Reduce Transparency is on.
    public var adaptsToReduceTransparency: Bool
    /// Whether secondary text and the page indicator are drawn brighter
    /// when Increase Contrast or Reduce Transparency is on.
    public var adaptsToIncreasedContrast: Bool
    /// Whether VoiceOver moves to each page's title as the page appears.
    public var movesFocusToEachPage: Bool
    /// Whether the VoiceOver escape gesture, and Escape on macOS, skip the
    /// intro.
    public var allowsEscapeToSkip: Bool

    public init(
        maximumDynamicTypeSize: DynamicTypeSize = .accessibility3,
        adaptsToReduceTransparency: Bool = true,
        adaptsToIncreasedContrast: Bool = true,
        movesFocusToEachPage: Bool = true,
        allowsEscapeToSkip: Bool = true
    ) {
        self.maximumDynamicTypeSize = maximumDynamicTypeSize
        self.adaptsToReduceTransparency = adaptsToReduceTransparency
        self.adaptsToIncreasedContrast = adaptsToIncreasedContrast
        self.movesFocusToEachPage = movesFocusToEachPage
        self.allowsEscapeToSkip = allowsEscapeToSkip
    }

    /// Follows every system setting.
    public static let standard = FoyerAccessibility()
}

/// What the intro draws for the current accessibility settings: plain data,
/// so it can be tested without a view.
nonisolated struct IntroLegibility: Equatable {
    /// Draws glass as solid shapes instead of Liquid Glass.
    var drawsSolidGlass: Bool
    /// Raises the contrast of secondary text and indicators.
    var raisesContrast: Bool

    init(
        reducesTransparency: Bool,
        increasesContrast: Bool,
        options: FoyerAccessibility
    ) {
        drawsSolidGlass = reducesTransparency && options.adaptsToReduceTransparency
        raisesContrast = options.adaptsToIncreasedContrast && (increasesContrast || drawsSolidGlass)
    }

    static let standard = IntroLegibility(
        reducesTransparency: false,
        increasesContrast: false,
        options: .standard
    )

    /// The page message's opacity over the dark welcome.
    var messageOpacity: Double {
        raisesContrast ? 0.92 : 0.72
    }

    /// A page indicator dot's opacity: the current page, pages already
    /// seen, and pages still to come.
    func dotOpacity(index: Int, current: Int) -> Double {
        if index == current {
            return raisesContrast ? 1 : 0.95
        }
        if index < current {
            return raisesContrast ? 0.7 : 0.5
        }
        return raisesContrast ? 0.45 : 0.25
    }

    /// The fill opacity of a solid glass piece, from the piece's own tint.
    func solidGlassOpacity(tint: Double) -> Double {
        min(0.34 + max(tint, 0) * 0.5, 0.9)
    }
}

extension View {
    /// The intro's button style: Liquid Glass, or a solid bordered button
    /// when glass is drawn solid.
    @ViewBuilder
    func introButtonStyle(prominent: Bool, solid: Bool) -> some View {
        switch (prominent, solid) {
        case (true, false):
            buttonStyle(.glassProminent)
        case (true, true):
            buttonStyle(.borderedProminent)
        case (false, false):
            buttonStyle(.glass)
        case (false, true):
            buttonStyle(.bordered)
        }
    }
}
