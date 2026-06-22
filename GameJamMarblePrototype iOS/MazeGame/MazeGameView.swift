//
//  MazeGameView.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI
import SpriteKit
internal import Combine

@Observable
private final class MazeGameModel {
    var score         = 0
    var tapCount      = 0
    var timeRemaining = 30
}

struct MazeGameView: View {
    let onComplete: (GameResult) -> Void

    @State private var motionManager = MotionManager()
    @State private var model         = MazeGameModel()
    @State private var scene: GameScene?
    @State private var viewSize: CGSize = .zero
    @State private var selectedLevel: GameLevel = .normal
    @State private var didComplete = false

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                topChrome(safeTop: geo.safeAreaInsets.top)

                ZStack(alignment: .bottom) {
                    if let scene {
                        SpriteView(scene: scene)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }

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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onAppear {
                viewSize = geo.size
                if scene == nil { scene = buildScene(size: geo.size) }
            }
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                guard !didComplete else { return }
                if model.timeRemaining > 0 {
                    model.timeRemaining -= 1
                } else {
                    didComplete = true
                    onComplete(GameResult(
                        score: model.score,
                        timeUsed: 30,
                        tapCount: model.tapCount
                    ))
                }
            }
            .sensoryFeedback(.success, trigger: model.tapCount)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }

    // MARK: - Top chrome

    private func topChrome(safeTop: CGFloat) -> some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: safeTop)

            HStack(spacing: 0) {
                hudCell(symbol: "trophy.fill",
                        value:  "\(model.score)",
                        accent: Color(red: 1.0, green: 0.78, blue: 0.0))
                chromeDivider
                hudCell(symbol: "timer",
                        value:  timerText,
                        accent: model.timeRemaining < 30 ? .red : .white)
                chromeDivider
                hudCell(symbol: "checkmark.circle.fill",
                        value:  "\(model.tapCount)",
                        accent: Color(red: 0.25, green: 0.88, blue: 0.65))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color(red: 0.04, green: 0.07, blue: 0.16, opacity: 1.0)
                .ignoresSafeArea(edges: .top)
        )
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
            resetScene()
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "arrow.counterclockwise")
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
        s.anchorPoint   = CGPoint(x: 0.5, y: 0.5)
        s.scaleMode     = .resizeFill
        s.motionManager = motionManager
        s.level         = selectedLevel
        let m = model
        s.onScoreChanged = { newScore in m.score = newScore }
        // MARK: - Multiplayer handoff: inject GameSession here
        return s
    }

    private func resetScene() {
        let size = viewSize.width > 0 ? viewSize : UIWindow.layoutFittingExpandedSize
        scene = buildScene(size: size)
    }
}
