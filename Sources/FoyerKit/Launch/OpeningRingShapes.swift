//===--- OpeningRingShapes.swift - FoyerKit ---------------------------------===//
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

/// A ring traced from angle zero through `progress` of a turn, clockwise on
/// screen. Drawn from the same angle as `OpeningRingTip`, so the two always
/// meet.
nonisolated struct OpeningRingArc: Shape {
    var progress: Double

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let turn = min(max(progress, 0), 1) * 2 * .pi
        guard turn > 0 else {
            return path
        }
        let segments = max(Int(turn / (2 * .pi) * 180), 2)
        path.move(to: Self.point(at: 0, in: rect))
        for step in 1...segments {
            path.addLine(to: Self.point(at: turn * Double(step) / Double(segments), in: rect))
        }
        return path
    }

    static func point(at angle: Double, in rect: CGRect) -> CGPoint {
        CGPoint(
            x: rect.midX + rect.width / 2 * cos(angle),
            y: rect.midY + rect.height / 2 * sin(angle)
        )
    }
}

/// The point at the leading end of a `OpeningRingArc`. Absent until the ring
/// starts to draw.
nonisolated struct OpeningRingTip: Shape {
    var progress: Double
    let diameter: CGFloat

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let clamped = min(max(progress, 0), 1)
        guard clamped > 0 else {
            return Path()
        }
        let center = OpeningRingArc.point(at: clamped * 2 * .pi, in: rect)
        return Path(ellipseIn: CGRect(
            x: center.x - diameter / 2,
            y: center.y - diameter / 2,
            width: diameter,
            height: diameter
        ))
    }
}

extension Animation {
    /// The construction drawing's curve: a measured start and a crisp,
    /// unhurried finish, like a line drawn with a steady hand. It leaves at
    /// about the speed a landing point arrives, so the handover never stalls.
    nonisolated static func openingDrawing(duration: Double) -> Animation {
        .timingCurve(0.4, 0.1, 0.2, 1, duration: duration)
    }
}
