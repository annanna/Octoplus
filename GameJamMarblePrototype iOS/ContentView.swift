//
//  ContentView.swift
//  GameJamMarblePrototype iOS
//
//  Created by Anna Münster  on 09.06.26.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var motionManager = MotionManager()
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

                VStack {
                    Spacer()

                    #if targetEnvironment(simulator)
                    HStack {
                        SimulatorDPadView(motionManager: motionManager)
                            .frame(width: 160, height: 160)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    #endif

                    HStack {
                        Spacer()
                        Button("Reset") { resetGame() }
                            .padding(10)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                            .padding(.trailing, 20)
                    }
                    .padding(.bottom, 40)
                }
            }
            .onAppear {
                viewSize = geo.size
                if scene == nil { scene = buildScene(size: geo.size) }
            }
        }
        .ignoresSafeArea()
    }

    private func buildScene(size: CGSize) -> GameScene {
        let s = GameScene(size: size)
        s.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        s.scaleMode = .resizeFill
        s.motionManager = motionManager
        // MARK: - Multiplayer handoff: inject GameSession / wire onScoreChanged here
        return s
    }

    private func resetGame() {
        let size = viewSize.width > 0 ? viewSize : UIScreen.main.bounds.size
        scene = buildScene(size: size)
    }
}
