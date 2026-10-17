//===--- View+Foyer.swift - FoyerKit ----------------------------------------===//
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

extension View {
    /// Plays an intro of `pages` over this view when it first appears.
    ///
    /// The launch plays once per process, in the first window that shows
    /// it; the welcome plays on the first launch.
    ///
    /// ```swift
    /// ContentView()
    ///     .foyer(
    ///         appName: "Orbit",
    ///         mark: .symbol("globe.americas.fill", color: .blue),
    ///         pages: [
    ///             .greeting("Welcome to Orbit", message: "Plan trips together."),
    ///             .mark("Simple, by Design", message: "Everything in one place."),
    ///         ]
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - appName: The app's name, the last word of the ending by default.
    ///   - mark: The app's mark; by default ``FoyerMark/standard``.
    ///   - pages: The welcome's pages, in any order.
    ///   - finale: The words of the ending; by default "Welcome", "to", and
    ///     `appName`. Pass `[]` for none.
    public func foyer(
        appName: String,
        mark: FoyerMark = .standard,
        pages: [FoyerPage],
        finale: [String]? = nil
    ) -> some View {
        foyer(Foyer(appName: appName, mark: mark, pages: pages, finale: finale))
    }

    /// Plays `intro` over this view when it first appears.
    public func foyer(_ intro: Foyer) -> some View {
        modifier(FoyerModifier(intro: intro, isPresented: nil))
    }

    /// Plays `intro` over this view whenever `isPresented` becomes true,
    /// welcome included unless its schedule is `never`, and sets it back to
    /// false when the intro ends.
    public func foyer(_ intro: Foyer, isPresented: Binding<Bool>) -> some View {
        modifier(FoyerModifier(intro: intro, isPresented: isPresented))
    }
}

/// One play of the intro.
private struct FoyerRun {
    let id: Int
    let mode: LaunchSequenceMode
    let presentsWelcome: Bool
}

private struct FoyerModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var accessibilityReduceMotion

    let intro: Foyer
    let isPresented: Binding<Bool>?

    @State private var run: FoyerRun?
    @State private var phase = LaunchPresentationPhase.complete
    @State private var runCount = 0
    @State private var skipRequest = 0

    func body(content: Content) -> some View {
        let presentation = LaunchWorkspacePresentation(
            phase: phase,
            reducesMotion: accessibilityReduceMotion
        )
        let isRunning = run != nil

        workspace(content, presentation: presentation, isRunning: isRunning)
            .overlay {
                if let run {
                    // The launch covers the whole window, title bar included.
                    GeometryReader { proxy in
                        LaunchSequenceView(
                            intro: intro,
                            mode: run.mode,
                            canvasSize: proxy.size,
                            presentsWelcome: run.presentsWelcome,
                            skipRequest: skipRequest,
                            phase: $phase,
                            onCompletion: complete
                        )
                        .id(run.id)
                    }
                    .ignoresSafeArea()
                }
            }
            .background {
                if isRunning {
                    Rectangle()
                        .fill(intro.background)
                        .ignoresSafeArea()
                }
            }
            .foyerWindowChromeHidden(isRunning && presentation.hidesWindowChrome)
            .foyerExitCommand(isRunning && intro.accessibility.allowsEscapeToSkip ? { skipRequest &+= 1 } : nil)
            .onAppear {
                guard isPresented == nil, runCount == 0 else {
                    return
                }
                startAutomaticRun()
            }
            .onChange(of: isPresented?.wrappedValue ?? false, initial: true) { _, shows in
                guard shows, run == nil else {
                    return
                }
                start(mode: .full, presentsWelcome: intro.welcome != .never && !intro.pages.isEmpty)
            }
    }

    private func workspace(
        _ content: Content,
        presentation: LaunchWorkspacePresentation,
        isRunning: Bool
    ) -> some View {
        content
            .opacity(isRunning ? presentation.workspaceOpacity : 1)
            .blur(radius: isRunning ? presentation.workspaceBlurRadius : 0)
            .animation(accessibilityReduceMotion ? .easeOut(duration: 0.14) : .smooth(duration: 0.55), value: phase)
            .accessibilityHidden(isRunning && !accessibilityReduceMotion && !presentation.isWorkspaceAvailable)
    }

    private func startAutomaticRun() {
        let presentsWelcome = intro.isWelcomePending
        let mode = LaunchProcessState.shared.claimSequence(
            isAnimationEnabled: intro.playsLaunchAnimation || presentsWelcome
        )
        guard mode == .full else {
            runCount += 1
            return
        }
        start(mode: mode, presentsWelcome: presentsWelcome)
    }

    private func start(mode: LaunchSequenceMode, presentsWelcome: Bool) {
        runCount += 1
        var transaction = Transaction()
        transaction.disablesAnimations = true
        // Opening on the mark, the app is already beneath the frosted glass
        // the mark comes up on.
        let opensOnMark = mode == .full && intro.opening == .mark && !accessibilityReduceMotion
        withTransaction(transaction) {
            phase = opensOnMark ? .logo : .background
            run = FoyerRun(id: runCount, mode: mode, presentsWelcome: presentsWelcome)
        }
    }

    private func complete(_ outcome: Foyer.Outcome) {
        if isPresented == nil {
            LaunchProcessState.shared.completeSequence()
        }
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            phase = .complete
            run = nil
        }
        isPresented?.wrappedValue = false
        intro.onFinish?(outcome)
    }
}

private extension View {
    /// Hides the window's title and toolbar on macOS, where they sit above
    /// the intro in the title bar; elsewhere the intro covers them.
    @ViewBuilder
    func foyerWindowChromeHidden(_ isHidden: Bool) -> some View {
        #if os(macOS)
        toolbar(removing: isHidden ? .title : nil)
            .toolbar(isHidden ? .hidden : .automatic, for: .windowToolbar)
        #else
        self
        #endif
    }

    @ViewBuilder
    func foyerExitCommand(_ action: (() -> Void)?) -> some View {
        #if os(macOS)
        onExitCommand(perform: action)
        #else
        self
        #endif
    }
}
