# Changes from the original work

FoyerKit is derived from an earlier project licensed under the Apache License 2.0, named in [NOTICE](NOTICE). Its original copyright and attribution notices are kept there. This file describes, as Section 4(b) of the [license](LICENSE) asks, how the files were changed. Every derived Swift and Metal file also carries a "Modified by belweave, 2026" header line.

## Renamed and rebranded

- The package, library product, module, and test target are now `FoyerKit` and `FoyerKitTests`; the demo app is `FoyerKitDemo`.
- Public types were renamed: the intro is `Foyer`, and its companions are `FoyerPage`, `FoyerMark`, `FoyerMarkView`, `FoyerGraph`, `FoyerScene`, `FoyerStorage`, and `FoyerBackground`. The modifiers are `.foyer(...)`.
- The default storage key is now `Foyer.hasSeenWelcome`.
- File headers, README, guides, DocC articles and tutorial, contributor documents, issue templates, and code comments were rewritten for FoyerKit and belweave. Repository links point to `github.com/Belweave/FoyerKit`.

## Added

- `FoyerAccessibility`: a maximum Dynamic Type size, Reduce Transparency and Increase Contrast adaptations, VoiceOver focus on each page, and escape-to-skip, each of which can be turned off.
- Dynamic Type: page titles use `@ScaledMetric` sizes and the page text follows the person's text size up to the configured limit.
- VoiceOver: titles are headings, focus moves to each new page's title, `.pictureDescription(_:)` describes a page's picture, and the escape gesture skips the intro.
- Reduce Transparency: glass is drawn as solid, outlined shapes, the frosted layer is opaque, and glass buttons become bordered buttons.
- Increase Contrast: brighter messages and page indicator.
- `allowsSkipping` and `skipButton` for an optional Skip button; `onFinish` with a `Foyer.Outcome` (`.finished`, `.skipped`, `.launchOnly`).
- `playsHaptics`: a light selection haptic as each page settles (quiet with Reduce Motion).
- Xcode previews (`FoyerPreviews.swift`), new tests (`AccessibilityTests.swift`), `Documentation/Accessibility.md`, a GitHub Actions workflow, `CHANGES.md`, and an explicit `swiftLanguageModes: [.v6]` in `Package.swift`.
- The demo app gained Skip Button and Haptics toggles, and writes them into its generated code.

## Removed

- The demo app's background picture, which the original NOTICE marked as not licensed for reuse, was deleted. It is replaced by `Landscape.imageset`, an original 3840x2160 dusk landscape made for FoyerKit, and the demo's toggle is now "Landscape Background". The NOTICE paragraph about the old picture was dropped because the picture no longer ships, and `Examples/…/ASSETS.md` was deleted.
- All screenshots, recordings, diagrams, and the icon from the documentation catalog, and the `Documentation/Tools` packages that drew and framed them. They showed the original branding and the removed picture. Image references in the guides and tutorial were removed with them.
- The original changelog and author credits, which describe the original project; its attribution is in NOTICE.

## Unchanged

- The rendering engine, motions, physics, Metal shader, symbol tracing, and the original test suites, apart from renaming and the plumbing for the options above.
- The "hello" handwriting stroke and the default mark design, which the original NOTICE lists as the original author's works under Apache 2.0.
