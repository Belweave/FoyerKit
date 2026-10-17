# ``FoyerKit``

The easy Swift package for Liquid Glass: a first-launch intro for SwiftUI apps, made with Liquid Glass and Metal.

@Metadata {
    @Available(iOS, introduced: "26.0")
    @Available(macOS, introduced: "26.0")
    @PageColor(blue)
}

## Overview

FoyerKit plays an intro over your app with one modifier. The launch opens on your mark on frosted glass. On the first launch a welcome follows: the mark writes "hello" in glass, then turns, page by page, into the pictures your app's story needs. At the end a few words turn in, the mark fills with colour, and it dissolves over your app.

```swift
ContentView()
    .foyer(
        appName: "Orbit",
        pages: [
            .greeting("Welcome to Orbit", message: "Plan trips together."),
            .symbols("Everything in Reach", message: "Maps, photos, and notes."),
            .icon("Ready When You Are", message: "Packed and ready to go."),
        ]
    )
```

Pages come in any order. Each picture can be configured — a graph of your own nodes and wires, a 3D scene in your shape, colour, and motion, or a view of your own — and every pair of pictures joins without a jump.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:/tutorials/Tutorials>
- ``SwiftUICore/View/foyer(appName:mark:pages:finale:)``
- ``Foyer``

### Pages

- <doc:ChoosingPages>
- ``FoyerPage``
- ``FoyerGraph``
- ``FoyerScene``
- ``FoyerBackground``

### The Ending and the Mark

- <doc:CustomizingTheEnding>
- ``FoyerMark``
- ``FoyerMarkView``

### Playing the Intro

- <doc:PlayingTheIntro>
- ``SwiftUICore/View/foyer(_:)``
- ``SwiftUICore/View/foyer(_:isPresented:)``
- ``FoyerStorage``

### Accessibility and Outcomes

- ``FoyerAccessibility``
- ``Foyer/Outcome``
