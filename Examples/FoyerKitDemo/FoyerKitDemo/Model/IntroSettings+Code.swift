//===--- IntroSettings+Code.swift - FoyerKit --------------------------------===//
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

import SwiftUI

extension IntroSettings {
    /// The Swift that plays the same intro, written as an app would.
    var code: String {
        var lines = [
            "@State private var showsIntro = true",
            "",
            "ContentView()",
            "    .foyer(Foyer(",
            "        appName: \(quoted(appName)),",
            "        mark: \(markSymbol.map { ".symbol(\(quoted($0)), color: \(markColor.code))" } ?? ".standard"),",
            "        pages: [",
        ]
        for kind in orderedPages {
            for line in pageCode(kind) {
                lines.append("            " + line)
            }
            lines[lines.count - 1] += ","
        }
        lines.append("        ]")
        var options: [String] = []
        if let words = finaleWords {
            options.append("finale: [\(words.map(quoted).joined(separator: ", "))]")
        }
        if !startTitle.isEmpty {
            options.append("startTitle: Text(\(quoted(startTitle)))")
        }
        if !startButton.isEmpty {
            options.append("startButton: Text(\(quoted(startButton)))")
        }
        if !continueButton.isEmpty {
            options.append("continueButton: Text(\(quoted(continueButton)))")
        }
        if opening == .stage {
            options.append("opening: .stage")
        }
        if allowsSkipping {
            options.append("allowsSkipping: true")
        }
        if !playsHaptics {
            options.append("playsHaptics: false")
        }
        for option in options {
            lines[lines.count - 1] += ","
            lines.append("        " + option)
        }
        lines.append("    ), isPresented: $showsIntro)")
        return lines.joined(separator: "\n")
    }

    private func pageCode(_ kind: PageKind) -> [String] {
        switch kind {
        case .greeting:
            let page = ".greeting(\(quoted("Welcome to \(appName)")), message: \(quoted("Everything you need, in one place.")))"
            return greetingOverLandscape ? [page, "    .background(.image(Image(\"Landscape\")))"] : [page]
        case .mark:
            return [".mark(\"Simple, by Design\", message: \"One calm place for all of it.\")"]
        case .symbols:
            return [".symbols(\"Everything in Reach\", message: \"Maps, photos, and music gather around you.\",", "    symbols: \(list(Self.scatterSymbols)))"]
        case .scene:
            switch sceneSource {
            case .rendered:
                var arguments = ["shape: .\(sceneShape)", "color: \(sceneColor.code)", "motion: .\(sceneMotion.rawValue)"]
                if !revealsRendering {
                    arguments.append("revealsRendering: false")
                }
                return [".scene(\"Seen in Depth\", message: \"A live 3D preview. Drag to turn it.\", scene: FoyerScene(\(arguments.joined(separator: ", "))))"]
            case .realityKit:
                return [".scene(\"Seen in Depth\", message: \"A RealityKit view of your own.\") {", "    RealitySceneView()", "}"]
            case .swiftUI:
                return [".scene(\"Seen in Depth\", message: \"Any SwiftUI view of your own.\") {", "    SpinningGlobeView()", "}"]
            }
        case .graph:
            let nodes = graphNodes
            let graph = switch graphShape {
            case .branch: ".branch(\(quoted(nodes[0])), into: \(list(Array(nodes.dropFirst()))))"
            case .chain: ".chain(\(list(nodes)))"
            case .diamond: ".diamond(\(quoted(nodes[0])), through: \(list(Array(nodes.dropFirst().dropLast()))), into: \(quoted(nodes[nodes.count - 1])))"
            }
            return [".graph(\"Connected\", message: \"A change in one place updates the rest.\",", "    graph: \(graph))"]
        case .physics:
            return [".physics(\"Feels Real\", message: \"Everything responds the way you expect.\",", "    nodes: \(list(physicsNodes)))"]
        case .icon:
            return [".icon(\"Ready When You Are\", message: \"Packed and ready to go.\", symbol: \(quoted(iconSymbol)))"]
        case .card:
            return [".card(\"Your Own View\", message: \"Any view can be a page.\") {", "    \(card.typeName)()", "}"]
        }
    }

    private func quoted(_ text: String) -> String {
        "\"" + text.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"") + "\""
    }

    private func list(_ texts: [String]) -> String {
        "[" + texts.map(quoted).joined(separator: ", ") + "]"
    }
}
