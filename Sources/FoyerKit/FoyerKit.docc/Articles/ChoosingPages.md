# Choosing Pages

Tell your app's story with eight pictures, in any order, each configured your way.

## Overview

Each page has a picture, a title, and a line beneath it. The page's picture plays, its text comes in, and **Continue** turns to the next page.

### The pictures

| Page | Picture |
|---|---|
| ``FoyerPage/greeting(_:message:)`` | The mark gathers into a pen and writes "hello" in glass. |
| ``FoyerPage/mark(_:message:)`` | The mark in glass, its detail opening. |
| ``FoyerPage/symbols(_:message:symbols:center:)`` | The mark melts into a symbol, and glass symbols scatter out of it. |
| ``FoyerPage/scene(_:message:scene:)`` | A glass lens opens over a live, ray-marched Metal scene. |
| ``FoyerPage/graph(_:message:graph:)`` | A wire shoots out of a glass point, and a graph grows. |
| ``FoyerPage/physics(_:message:nodes:)`` | Up to eight nodes fall onto a line under rigid-body physics. |
| ``FoyerPage/icon(_:message:symbol:badge:)`` | Glass gathers into an app icon, which is polished and badged. |
| ``FoyerPage/card(_:message:content:)`` | Your own SwiftUI view, on a card of glass. |

### How pages connect

Pages come in any order, as often as you like. Pictures made to follow one another — greeting, mark, symbols, scene, graph, physics, icon — carry straight on, the same glass continuing from one to the next. Any other two meet in a drop of glass: one gathers into it, and the next grows out of it.

### Graphs

A graph page grows any nodes, wired any way. Nodes are laid out left to right, each one column past the furthest node wired into it, and the graph is scaled to fit the window.

```swift
.graph("Connected", message: "…", nodes: ["calendar", "person.2.fill", "creditcard.fill"])
.graph("Pipeline", message: "…", graph: .chain(["tray.fill", "gearshape.fill", "paperplane.fill"]))
.graph("Trip", message: "…", graph: .diamond("airplane.departure", through: ["bed.double.fill", "fork.knife"], into: "airplane.arrival"))
.graph("Yours", message: "…", graph: FoyerGraph(
    nodes: ["envelope.fill", "calendar", "checklist", "bell.fill"],
    links: [.init(0, 2), .init(1, 2), .init(2, 3)]
))
```

Links run from an earlier node to a later one; a link that runs backward, repeats, or names a missing node is left out. A physics page right after a graph drops the graph's own nodes.

### Scenes

The scene renders an object on a studio floor:

```swift
.scene("Seen in Depth", message: "…", scene: FoyerScene(
    shape: .ring,            // .cube, .sphere, .ring, .capsule, .cylinder
    color: .orange,
    motion: .float,          // .turntable, .turntable(speed:), .tumble, .float, .still
    revealsRendering: false, // open fully lit, rather than level by level
    isDraggable: true
))
```

Or show a view of your own, such as a `RealityView`, through the same lens:

```swift
.scene("Your World", message: "…") {
    MyRealityView()
}
```

### Backgrounds and buttons

Each page can have its own background — the picture's own light, a colour, or an image — and its own button:

```swift
.greeting("Welcome to Orbit", message: "…")
    .background(.image(Image("Landscape")))
    .continueButton(Text("Let's Go"))
```

### SF Symbols

Symbols are traced into glass outlines. Some SF Symbols may only refer to particular Apple products and must not be modified; the SF Symbols app marks them. Don't pass those to a page. The default symbols are ones anyone may use, and a test checks them against the system's list.

## See Also

- ``FoyerPage``
- ``FoyerGraph``
- ``FoyerScene``
