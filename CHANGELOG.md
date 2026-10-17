# Changelog

All notable changes to FoyerKit are listed here. For how FoyerKit differs from the project it was derived from, see [CHANGES.md](CHANGES.md).

## 0.1.0 (unreleased)

First release of FoyerKit, a belweave project.

- **Launch.** The launch opens on your mark on frosted glass and carries on into the welcome, or dissolves over your app. `opening: .stage` draws the opening stage first, in your `tint`. The launch plays once per process; `playsLaunchAnimation` turns it off when there is no welcome to show.
- **Welcome.** Eight pictures in Liquid Glass (`greeting`, `mark`, `symbols`, `scene`, `graph`, `physics`, `icon`, and `card`) in any order, as often as you like. Each page can have its own `background`, `continueButton`, and `pictureDescription`.
- **Scenes, graphs, and physics.** A live, ray-marched Metal scene or a view of your own through a glass lens; graphs of any nodes and links; up to eight nodes falling under rigid-body physics.
- **Ending and marks.** Up to three lines of glass words, then the mark fills with colour and dissolves over your app. `.standard`, `.symbol(_:color:)`, and `.custom(outline:view:)` marks.
- **Presentation.** `.foyer(appName:mark:pages:finale:)`, `.foyer(_:)`, and `.foyer(_:isPresented:)`. The welcome plays on the first launch, on every launch, or never, recorded in a `FoyerStorage`.
- **Skipping and outcomes.** `allowsSkipping` and `skipButton` add a Skip button; `onFinish` reports `.finished`, `.skipped`, or `.launchOnly`.
- **Accessibility.** Dynamic Type up to a configurable size, VoiceOver headings and focus on each page, picture descriptions, the VoiceOver escape gesture to skip, Reduce Motion, Reduce Transparency (solid glass and opaque frosting), and Increase Contrast, all tunable with `FoyerAccessibility`.
- **Haptics.** A light haptic as each page settles; `playsHaptics: false` turns it off.
- **Previews and docs.** Xcode previews of common setups, guides in `Documentation` (including Accessibility), a DocC catalog with a tutorial, and a demo app that tries every option and writes out its code.
- **CI.** GitHub Actions build and test on macOS 26, plus an iOS build.
