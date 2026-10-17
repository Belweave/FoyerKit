//===--- MarkSpriteView.swift - FoyerKit ------------------------------------===//
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

/// The mark in colour, drawn exactly as the launch stage draws the closed
/// mark, so the welcome takes over from the stage and hands back to it
/// without a visible change.
struct MarkSpriteView: View {
    let sprite: MarkSprite
    let mark: FoyerMark
    let canvas: IntroCanvas

    var body: some View {
        if let colour = sprite.colour {
            colouring(colour)
        } else {
            plain
        }
    }

    private var badge: some View {
        ZStack {
            Circle()
                .fill(mark.bodyColor)
                .frame(width: canvas.bodyDiameter, height: canvas.bodyDiameter)
            FoyerMarkView(mark)
                .frame(width: canvas.markDimension, height: canvas.markDimension)
        }
        .frame(width: canvas.markDimension, height: canvas.markDimension)
    }

    /// The body, with the detail coming into focus over it. Gathered down,
    /// the same body is the pen's point.
    private var plain: some View {
        ZStack {
            Circle()
                .fill(mark.bodyColor)
                .frame(width: canvas.bodyDiameter, height: canvas.bodyDiameter)
            FoyerMarkView(mark)
                .frame(width: canvas.markDimension, height: canvas.markDimension)
                .compositingGroup()
                .blur(radius: (1 - sprite.detail) * 10)
                .opacity(sprite.detail)
        }
        .scaleEffect(sprite.scale)
        .position(sprite.center)
        .opacity(sprite.opacity)
    }

    /// Colour spreading through the mark from its light, with a glow.
    private func colouring(_ colour: Double) -> some View {
        ZStack {
            badge
                .blur(radius: 28)
                .scaleEffect(1.15)
                .opacity(sprite.glow)
            badge
                .mask {
                    RadialGradient(
                        stops: [
                            .init(color: .black, location: 0),
                            .init(color: .black, location: 0.75),
                            .init(color: .clear, location: 1),
                        ],
                        center: mark.light,
                        startRadius: 0,
                        endRadius: max(canvas.markDimension * 1.2 * colour, 0.1)
                    )
                }
                .scaleEffect(sprite.swell)
        }
        .scaleEffect(sprite.scale)
        .position(sprite.center)
        .opacity(colour > 0 ? sprite.opacity : 0)
    }
}
