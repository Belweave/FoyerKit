//===--- WelcomePageText.swift - FoyerKit -----------------------------------===//
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

/// A page's text: one title, one message, and the button that turns the
/// page.
///
/// Titles and messages scale with Dynamic Type up to the intro's limit;
/// VoiceOver moves to the title as each page appears.
struct WelcomePageText: View {
    @ScaledMetric(relativeTo: .title) private var titleSize: CGFloat = 32
    @ScaledMetric(relativeTo: .title) private var compactTitleSize: CGFloat = 26
    @AccessibilityFocusState private var isTitleFocused: Bool

    let page: FoyerPage
    let index: Int
    let pageCount: Int
    let continueButton: Text
    let isRevealed: Bool
    let isEnabled: Bool
    let isCompact: Bool
    let legibility: IntroLegibility
    let accessibility: FoyerAccessibility
    let onContinue: () -> Void
    /// Reports where the text's top sits in the welcome.
    let onTopChange: (CGFloat) -> Void

    var body: some View {
        VStack(spacing: 10) {
            WelcomePageDots(current: index, count: pageCount, isRevealed: isRevealed, legibility: legibility)
                .padding(.bottom, 8)

            if let description = page.pictureDescription {
                // The picture itself is drawn behind the text and hidden from
                // VoiceOver; this stands in for it.
                Color.clear
                    .frame(width: 1, height: 1)
                    .accessibilityElement()
                    .accessibilityLabel(description)
                    .accessibilityAddTraits(.isImage)
            }

            page.title
                .font(.system(size: isCompact ? compactTitleSize : titleSize, weight: .semibold))
                .minimumScaleFactor(0.75)
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($isTitleFocused)
                .modifier(WelcomeReveal(isRevealed: isRevealed, order: 0))

            page.message
                .font(.body)
                .foregroundStyle(Color.white.opacity(legibility.messageOpacity))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 460)
                .modifier(WelcomeReveal(isRevealed: isRevealed, order: 1))

            Button(action: onContinue) {
                (page.continueButton ?? continueButton)
                    .frame(minWidth: 160)
            }
            .introButtonStyle(prominent: true, solid: legibility.drawsSolidGlass)
            .controlSize(.large)
            .welcomeDefaultAction(isRevealed)
            .disabled(!isRevealed || !isEnabled)
            .padding(.top, 18)
            .modifier(WelcomeReveal(isRevealed: isRevealed, order: 2))
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(Color.white)
        .dynamicTypeSize(...accessibility.maximumDynamicTypeSize)
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.frame(in: .named(WelcomeView.coordinateSpace)).minY
        } action: { top in
            onTopChange(top)
        }
        .allowsHitTesting(isRevealed)
        .accessibilityHidden(!isRevealed)
        .onChange(of: isRevealed) { _, revealed in
            if revealed, accessibility.movesFocusToEachPage {
                isTitleFocused = true
            }
        }
    }
}

/// The last page: one line at the center, and the button that begins.
struct WelcomeReadyText: View {
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize: CGFloat = 46
    @ScaledMetric(relativeTo: .largeTitle) private var compactTitleSize: CGFloat = 34
    @AccessibilityFocusState private var isTitleFocused: Bool

    let index: Int
    let pageCount: Int
    let title: Text
    let button: Text
    let isRevealed: Bool
    let isEnabled: Bool
    let isCompact: Bool
    let legibility: IntroLegibility
    let accessibility: FoyerAccessibility
    let onBegin: () -> Void

    var body: some View {
        VStack(spacing: 26) {
            WelcomePageDots(current: index, count: pageCount, isRevealed: isRevealed, legibility: legibility)
            title
                .font(.system(size: isCompact ? compactTitleSize : titleSize, weight: .semibold))
                .minimumScaleFactor(0.7)
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($isTitleFocused)
                .modifier(WelcomeReveal(isRevealed: isRevealed, order: 0))
            Button(action: onBegin) {
                button
                    .frame(minWidth: 160)
            }
            .introButtonStyle(prominent: true, solid: legibility.drawsSolidGlass)
            .controlSize(.large)
            .welcomeDefaultAction(isRevealed)
            .disabled(!isRevealed || !isEnabled)
            .modifier(WelcomeReveal(isRevealed: isRevealed, order: 1))
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(Color.white)
        .dynamicTypeSize(...accessibility.maximumDynamicTypeSize)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(isRevealed)
        .accessibilityHidden(!isRevealed)
        .onChange(of: isRevealed) { _, revealed in
            if revealed, accessibility.movesFocusToEachPage {
                isTitleFocused = true
            }
        }
    }
}
