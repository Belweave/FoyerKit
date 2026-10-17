# AGENTS.md

Guidance for coding agents working in this repository. Human contributors should read [CONTRIBUTING.md](CONTRIBUTING.md); this file adds what an agent needs to work safely here.

## The project

FoyerKit is a Swift package: a first-launch intro for SwiftUI apps on iOS 26+ and macOS 26+, made with Liquid Glass and a Metal shader. It has no dependencies. See [Documentation/Architecture.md](Documentation/Architecture.md) for how it is built.

| Path | What is there |
|---|---|
| `Sources/FoyerKit/API` | The public API: `Foyer`, `FoyerPage`, `FoyerGraph`, `FoyerScene`, `FoyerMark`, `FoyerAccessibility`, the modifiers, and Xcode previews |
| `Sources/FoyerKit/Launch` | The launch and the hand-over to the app |
| `Sources/FoyerKit/Welcome` | The welcome: `Model` (player, content), `Motions` (one folder per picture), `Rendering`, `Text`, `Backdrop` |
| `Sources/FoyerKit/Shaders` | The Metal scene |
| `Sources/FoyerKit/FoyerKit.docc` | DocC articles, the tutorial, and the tutorial's code snippets |
| `Tests/FoyerKitTests` | Swift Testing suites, including frame-by-frame continuity tests |
| `Examples/FoyerKitDemo` | The demo app (Xcode project, local package reference) |
| `Documentation` | Markdown guides |

## Commands

```sh
swift build                                          # build the package
swift test -c release -Xswiftc -enable-testing       # all tests; several minutes, run them in release
swift test -c release -Xswiftc -enable-testing --filter GraphLayoutTests   # one suite
xcodebuild docbuild -scheme FoyerKit -destination 'generic/platform=macOS'   # docs; must have no warnings
xcodebuild build -project Examples/FoyerKitDemo/FoyerKitDemo.xcodeproj -scheme FoyerKitDemo -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO
```

Debug test runs are many times slower than release; use release. Builds must have no warnings.

## Conventions

- Swift 6 language mode with `MainActor` default isolation. Pure data and drawing types are `nonisolated`; extensions of them are `nonisolated extension`.
- Every Swift and Metal file starts with the license header used throughout the repository, its first line padded with dashes to 82 characters.
- One responsibility per file, one picture per folder under `Welcome/Motions`. Split files that grow past a few hundred lines.
- Comments explain intent and constraints, not syntax. American English throughout.
- Public API is small, and every public declaration has a DocC comment, with every parameter documented.
- A user-visible change updates the README or `Documentation`, the DocC catalog, and `CHANGELOG.md`.

## Rules

- Do not weaken, skip, or delete tests, or raise the continuity tests' tolerance, to make a change pass. A failing continuity test means a frame jumps; fix the motion.
- A new picture or option needs tests, including continuity to and from the other pictures.
- Symbols used by defaults must not be restricted SF Symbols; `SymbolRestrictionTests` checks them.
- The package makes no network requests and stores only one `UserDefaults` Boolean. Keep it that way.
- Do not run git commands that change history or publish anything, unless the maintainer, Preetham Kyanam, asks.
- Keep license compliance intact: never remove `LICENSE`, `NOTICE`, `CHANGES.md`, or the "Portions derived from…" / "Modified by belweave" header lines in derived files.

## Pitfalls

- **Leading-dot lines continue the previous line.** A result builder of pages written as one `.greeting(...)` per line parses as a single chained call. Pages are an array for that reason.
- **Outlines are drawn off the main actor.** Closures such as a custom mark's `outline` are `@Sendable`; a helper they call must be `nonisolated`.
- **Pictures are laid out for the canvas they began on.** A window resized mid-turn is handled by fitting the frame, then laying the page out again at rest through `WelcomeContent.restingMotion`, which rebuilds the hand-over chain.
- **Rasterizing in tests is serialized.** Core Graphics occasionally draws wrongly when many bitmaps are drawn at once; frames are computed in parallel but drawn one at a time.
- **Symbol tracing must be deterministic.** Iterate dictionaries in sorted order when tracing outlines, or outlines differ from launch to launch.
