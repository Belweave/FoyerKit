//===--- SymbolRestrictionTests.swift - FoyerKit ----------------------------===//
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

import Foundation
import Testing
@testable import FoyerKit

/// The defaults must be symbols anyone may use. The system lists the
/// symbols that may only refer to particular Apple products.
@Suite struct SymbolRestrictionTests {
    nonisolated private static let restrictionsURL = URL(
        fileURLWithPath: "/System/Library/CoreServices/CoreGlyphs.bundle/Contents/Resources/symbol_restrictions.strings"
    )

    @Test(.enabled(if: FileManager.default.fileExists(atPath: restrictionsURL.path)))
    func defaultSymbolsAreUnrestricted() throws {
        let data = try Data(contentsOf: Self.restrictionsURL)
        let restrictions = try #require(
            try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: String]
        )
        #expect(restrictions["apple.logo"] != nil, "The restriction list was read.")
        var defaults = FoyerPage.defaultScatterSymbols + FoyerPage.defaultNodeSymbols
        defaults += ["shippingbox.fill", "checkmark", "sparkles"]
        for symbol in defaults {
            #expect(restrictions[symbol] == nil, "\(symbol) is restricted")
        }
    }
}
