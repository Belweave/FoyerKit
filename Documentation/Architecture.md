# Architecture

How FoyerKit is built, for contributors.

## Every picture is data

Each picture is an `IntroMotion`: given a time, it returns an `IntroFrame` — plain data describing glass outlines, symbols, the scene, the mark, and a card. It draws nothing itself.

| Type | Role | Where |
|---|---|---|
| `Foyer`, `FoyerPage` | The public configuration | `Sources/FoyerKit/API` |
| `WelcomeContent` | Each page's context: canvas, symbols, traced outlines | `Welcome/Model` |
| `IntroMotion` | One per picture: the frame at any time, and what it hands on | `Welcome/Motions/<Picture>` |
| `WelcomePlayer` | The timeline: carries a picture straight on, or through the drop of glass | `Welcome/Model` |
| `IntroFrame` | Plain data for one frame | `Welcome/Rendering` |
| `IntroFrameView` | The one renderer: Liquid Glass and the Metal scene | `Welcome/Rendering` |
| `LaunchSequenceView` | The launch, the welcome's host, and the hand-over to the app | `Launch` |

## How pictures join

When a page turns, the player asks the next picture whether it can carry on from what the current one hands on (an `IntroHandoff`). If it can, the next picture starts from it. Otherwise the current picture gathers into the seed, a drop of glass the size of the mark's body, and the next grows out of it. Before the last page, the picture lets go where it is.

## Tests

The tests rasterize `IntroFrame`s into small grey images and fail on any frame that jumps: every page after every other page, random welcomes, every graph shape, every scene, any number of falling nodes, phone and window sizes, and resized windows. Run them in release:

```sh
swift test -c release -Xswiftc -enable-testing
```

## Adding a picture

1. Add a folder under `Welcome/Motions` with a type that conforms to `PageMotion`.
2. Add a case to `FoyerPage.Visual` and to `IntroPicture`, and a factory on `FoyerPage`.
3. Decide what it hands on and what it can carry on from.
4. Add tests: its frames, and continuity to and from every other picture.

## Accessibility

What a frame looks like never depends on accessibility settings; how it is drawn does. `IntroLegibility` (in `API/FoyerAccessibility.swift`) turns the system settings and `FoyerAccessibility` into plain values: whether glass is drawn solid, and how bright secondary text is. `IntroFrameView` and the page text read it, and `AccessibilityTests` covers it without a view.

## Screenshots and video

The repository ships no screenshots or recordings yet. Record the demo app (the Simulator with `xcrun simctl io booted recordVideo`, the Mac window with `screencapture -v`) and add images to `Sources/FoyerKit/FoyerKit.docc/Resources` when they are ready.
