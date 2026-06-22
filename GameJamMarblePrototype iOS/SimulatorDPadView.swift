//
//  SimulatorDPadView.swift
//  GameJamMarblePrototype iOS
//
//  Created by Anna Münster  on 09.06.26.
//

import SwiftUI

#if targetEnvironment(simulator)
struct SimulatorDPadView: View {
    var motionManager: MotionManager

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Spacer().frame(width: 50, height: 50)
                dpadButton(symbol: "arrow.up",    tilt: CGVector(dx: 0,  dy:  1))
                Spacer().frame(width: 50, height: 50)
            }
            HStack(spacing: 4) {
                dpadButton(symbol: "arrow.left",  tilt: CGVector(dx: -1, dy:  0))
                Spacer().frame(width: 50, height: 50)
                dpadButton(symbol: "arrow.right", tilt: CGVector(dx:  1, dy:  0))
            }
            HStack(spacing: 4) {
                Spacer().frame(width: 50, height: 50)
                dpadButton(symbol: "arrow.down",  tilt: CGVector(dx: 0,  dy: -1))
                Spacer().frame(width: 50, height: 50)
            }
        }
    }

    private func dpadButton(symbol: String, tilt: CGVector) -> some View {
        Image(systemName: symbol)
            .font(.title2)
            .frame(width: 50, height: 50)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in motionManager.simulatedTilt = tilt }
                    .onEnded   { _ in motionManager.simulatedTilt = .zero }
            )
    }
}
#endif
