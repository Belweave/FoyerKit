# Accessibility

FoyerKit adapts to the person watching without any setup. This guide lists what it does and how to tune it with `FoyerAccessibility`.

| Setting | What FoyerKit does |
|---|---|
| Dynamic Type | Titles and messages scale with the text size, up to `maximumDynamicTypeSize` (`.accessibility3` by default). Long titles shrink a little before wrapping. |
| VoiceOver | Each page's title is a heading, and focus moves to it as the page appears (`movesFocusToEachPage`). The page indicator reads "Page 2 of 5". The escape gesture skips the intro (`allowsEscapeToSkip`). |
| Picture descriptions | Pictures are decorative and hidden from VoiceOver. `.pictureDescription(_:)` on a page gives its picture a description. |
| Reduce Motion | The launch fades instead of animating, each page appears finished, and haptics stay quiet. |
| Reduce Transparency | Glass is drawn as solid, outlined shapes; the frosted layer turns opaque; buttons become solid bordered buttons (`adaptsToReduceTransparency`). |
| Increase Contrast | Messages and the page indicator are drawn brighter (`adaptsToIncreasedContrast`). |
| Keyboard | Return continues on the page on screen. On macOS, Escape skips. |

```swift
Foyer(
    appName: "Orbit",
    pages: [
        .greeting("Welcome to Orbit", message: "Plan trips together."),
        .card("Your Itinerary", message: "Every day, at a glance.") { ItineraryCard() }
            .pictureDescription(Text("A card listing three days of a trip to Lisbon.")),
    ],
    accessibility: FoyerAccessibility(maximumDynamicTypeSize: .accessibility2)
)
```

## Checking your intro

- Turn on VoiceOver and play the intro: every page should announce its title, and the escape gesture should leave the intro.
- In Xcode, use the "Largest text" preview in `FoyerPreviews.swift`, or set Dynamic Type to the largest accessibility size in the Simulator.
- Turn on Reduce Transparency and Increase Contrast in Settings › Accessibility › Display & Text Size (iOS) or System Settings › Accessibility › Display (macOS), and play the intro again.
