//===--- ScatterBubbleFrame+Glass.swift - FoyerKit --------------------------===//
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

nonisolated extension ScatterBubbleFrame {
    /// The bubble as a piece of glass in the shape of its symbol, placed on
    /// the canvas. Until the symbol is traced it is a small circle.
    func glassPiece(outline: Path?) -> GlassPiece {
        let rect = CGRect(
            x: center.x - diameter / 2,
            y: center.y - diameter / 2,
            width: diameter,
            height: diameter
        )
        return GlassPiece(
            id: "bubble.\(id)",
            path: SymbolGlassShape(outline: outline).path(in: rect),
            blur: blur
        )
    }
}
