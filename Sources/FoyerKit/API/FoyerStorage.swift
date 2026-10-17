//===--- FoyerStorage.swift - FoyerKit --------------------------------------===//
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

/// Where an intro records that its welcome was shown: a key in a user
/// defaults store.
///
/// Pass your own to keep the record in an app group, or to keep apart two
/// intros, such as one for each major version of your app:
///
/// ```swift
/// Foyer(appName: "Orbit", pages: pages, storage: FoyerStorage(key: "Orbit.welcome.2"))
/// ```
public struct FoyerStorage {
    /// The store the record is kept in.
    public let defaults: UserDefaults
    /// The key the record is kept under.
    public let key: String

    public init(defaults: UserDefaults = .standard, key: String = "Foyer.hasSeenWelcome") {
        self.defaults = defaults
        self.key = key
    }

    /// The record under `Foyer.hasSeenWelcome` in the standard user
    /// defaults.
    public static var standard: FoyerStorage {
        FoyerStorage()
    }

    /// Whether the welcome has been shown, or skipped while it played.
    public var hasSeenWelcome: Bool {
        get { defaults.bool(forKey: key) }
        nonmutating set { defaults.set(newValue, forKey: key) }
    }
}
