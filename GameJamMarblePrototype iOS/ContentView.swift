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
    var score        = 0
    var tapCount     = 0
    var timeRemaining = 180   // seconds; 3 minutes per game
}

struct ContentView: View {
    @State private var motionManager = MotionManager()
    @State private var model         = GameModel()
    @State private var scene: GameScene?
    @State private var viewSize: CGSize = .zero

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black

                if let scene {
                    SpriteView(scene: scene)
                        .frame(width: geo.size.width, height: geo.size.height)
                }

                // ── HUD bar — sits just below the notch / Dynamic Island ──
                VStack(spacing: 0) {
                    hudBar
                        .padding(.top, geo.safeAreaInsets.top + 4)
                    Spacer()
                }

                // ── Bottom controls — sits above home indicator ──
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
                    resetGame()  // time's up — new round, taps don't increment
                }
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - HUD bar

    private var hudBar: some View {
        HStack(spacing: 0) {
            hudCell(symbol: "trophy.fill",   value: "\(model.score)",    accent: .yellow)
            hudDivider
            hudCell(symbol: "timer",         value: timerText,
                    accent: model.timeRemaining < 30 ? .red : .white)
            hudDivider
            hudCell(symbol: "checkmark",     value: "\(model.tapCount)", accent: .green)
        }
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
    }

    private var hudDivider: some View {
        Rectangle()
            .frame(width: 1, height: 20)
            .foregroundStyle(.white.opacity(0.25))
    }

    private func hudCell(symbol: String, value: String, accent: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: symbol)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(accent)
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .monospacedDigit()
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity)
    }

    private var timerText: String {
        let m = model.timeRemaining / 60
        let s = model.timeRemaining % 60
        return String(format: "%d:%02d", m, s)
    }

    // MARK: - Tap button (replaces Reset)

    private var tapButton: some View {
        Button {
            model.tapCount += 1
            resetGame()
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "checkmark")
                    .fontWeight(.bold)
                Text("\(model.tapCount)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .contentTransition(.numericText())
            }
            .foregroundStyle(.white)
            .padding(10)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
        }
    }

    // MARK: - Scene management

    private func buildScene(size: CGSize) -> GameScene {
        let s = GameScene(size: size)
        s.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        s.scaleMode = .resizeFill
        s.motionManager = motionManager
        let m = model   // capture class reference — safe across struct recreations
        s.onScoreChanged = { newScore in m.score = newScore }
        // MARK: - Multiplayer handoff: inject GameSession here
        return s
    }

    private func resetGame() {
        model.score         = 0
        model.timeRemaining = 180
        let size = viewSize.width > 0 ? viewSize : UIScreen.main.bounds.size
        scene = buildScene(size: size)
    }
}
