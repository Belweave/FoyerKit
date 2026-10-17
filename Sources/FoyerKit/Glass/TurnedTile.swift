//===--- TurnedTile.swift - FoyerKit ----------------------------------------===//
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

/// A rounded tile turned about its center: the outline glass follows as a
/// node falls, tumbles, and is gathered back up.
nonisolated enum TurnedTile {
    static func path(size: CGSize, cornerRadius: CGFloat, angle: Double, center: CGPoint) -> Path {
        Path(
            roundedRect: CGRect(
                x: -size.width / 2,
                y: -size.height / 2,
                width: size.width,
                height: size.height
            ),
            cornerRadius: cornerRadius,
            style: .continuous
        )
        .applying(
            CGAffineTransform(translationX: center.x, y: center.y)
                .rotated(by: angle)
        )
    }
}
