import FoyerKit
import SwiftUI

@main
struct OrbitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .foyer(
                    appName: "Orbit",
                    pages: [
                        .greeting("Welcome to Orbit", message: "Plan trips with the people you travel with."),
                    ]
                )
        }
    }
}
