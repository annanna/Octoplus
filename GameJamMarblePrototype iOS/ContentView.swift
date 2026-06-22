//
//  ContentView.swift
//  GameJamMarblePrototype iOS
//
//  Created by Anna Münster  on 09.06.26.
//

import SwiftUI
import SpriteKit
internal import Combine

@Observable
private final class GameModel {
    var score         = 0
    var tapCount      = 0
    var timeRemaining = 180   // seconds — 3 minutes per round
}

struct ContentView: View {
    @State private var motionManager  = MotionManager()
    @State private var model          = GameModel()
    @State private var scene: GameScene?
    @State private var viewSize: CGSize = .zero
    @State private var selectedLevel: GameLevel = .normal

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black

                if let scene {
                    SpriteView(scene: scene)
                        .frame(width: geo.size.width, height: geo.size.height)
                }

                // ── Top chrome ──────────────────────────────────────────────
                // A single opaque block that covers from y=0 (under the
                // notch / Dynamic Island) down to the bottom of the HUD row,
                // so no game content is ever visible in the system safe area.
                VStack(spacing: 0) {
                    topChrome(safeTop: geo.safeAreaInsets.top)
                    Spacer()
                }

                // ── Bottom controls ─────────────────────────────────────────
                VStack(spacing: 0) {
                    Spacer()
                    HStack(alignment: .bottom, spacing: 0) {
                        #if targetEnvironment(simulator)
                        SimulatorDPadView(motionManager: motionManager)
                            .frame(width: 160, height: 160)
                            .padding(.leading, 20)
                        #endif
                        Spacer()
                        tapButton
                            .padding(.trailing, 20)
                    }
                    .padding(.bottom, max(geo.safeAreaInsets.bottom, 8) + 8)
                }
            }
            .onAppear {
                viewSize = geo.size
                if scene == nil { scene = buildScene(size: geo.size) }
            }
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                if model.timeRemaining > 0 {
                    model.timeRemaining -= 1
                } else {
                    resetGame(resetScore: true)
                }
            }
            .sensoryFeedback(.success, trigger: model.tapCount)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }

    // MARK: - Top chrome

    /// safeTop comes from geo.safeAreaInsets.top — the height of the
    /// notch / Dynamic Island region that must remain clear of content.
    private func topChrome(safeTop: CGFloat) -> some View {
        VStack(spacing: 0) {
            // Blank region that sits behind the notch / Dynamic Island
            Color.clear.frame(height: safeTop)

            // HUD row
            HStack(spacing: 0) {
                hudCell(symbol: "trophy.fill",
                        value:  "\(model.score)",
                        accent: Color(red: 1.0, green: 0.78, blue: 0.0))      // gold
                chromeDivider
                hudCell(symbol: "timer",
                        value:  timerText,
                        accent: model.timeRemaining < 30 ? .red : .white)
                chromeDivider
                hudCell(symbol: "checkmark.circle.fill",
                        value:  "\(model.tapCount)",
                        accent: Color(red: 0.25, green: 0.88, blue: 0.65))    // teal-green
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)

            // Level picker
            Picker("Level", selection: $selectedLevel) {
                Text("Normal").tag(GameLevel.normal)
                Text("Advanced").tag(GameLevel.advanced)
                Text("Heavy").tag(GameLevel.heavy)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            .onChange(of: selectedLevel) { _, _ in resetGame() }
        }
        .frame(maxWidth: .infinity)
        // Fully opaque — hides game content behind notch AND behind HUD row
        .background(Color(red: 0.04, green: 0.07, blue: 0.16, opacity: 1.0))
        // Hairline separator between chrome and game
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.white.opacity(0.12))
        }
    }

    private var chromeDivider: some View {
        Rectangle()
            .frame(width: 1, height: 22)
            .foregroundStyle(Color.white.opacity(0.18))
    }

    private func hudCell(symbol: String, value: String, accent: Color) -> some View {
        HStack(spacing: 7) {
            Image(systemName: symbol)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(accent)
            Text(value)
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .monospacedDigit()
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity)
    }

    private var timerText: String {
        String(format: "%d:%02d", model.timeRemaining / 60, model.timeRemaining % 60)
    }

    // MARK: - Tap button

    private var tapButton: some View {
        Button {
            model.tapCount += 1
            resetGame()
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "checkmark")
                    .fontWeight(.bold)
            }
            .foregroundStyle(.white)
            .padding(10)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
        }
    }

    // MARK: - Scene management

    private func buildScene(size: CGSize) -> GameScene {
        let s = GameScene(size: size)
        s.anchorPoint   = CGPoint(x: 0.5, y: 0.5)
        s.scaleMode     = .resizeFill
        s.motionManager = motionManager
        s.level         = selectedLevel
        let m = model   // class reference — stable across struct re-creations
        s.onScoreChanged = { newScore in m.score = newScore }
        // MARK: - Multiplayer handoff: inject GameSession here
        return s
    }

    private func resetGame(resetScore: Bool = false) {
        if resetScore { model.score = 0 }
        model.timeRemaining = 180
        let size = viewSize.width > 0 ? viewSize : UIWindow.layoutFittingExpandedSize
        scene = buildScene(size: size)
    }
}
