//
//  WinOverlayView.swift
//  GameJamMarblePrototype iOS
//
//  Created by Anna Münster  on 09.06.26.
//

import SwiftUI

struct WinOverlayView: View {
    let onRestart: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.65).ignoresSafeArea()
            VStack(spacing: 28) {
                Text("You escaped!")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text("The octopus finds freedom")
                    .foregroundStyle(.white.opacity(0.75))
                Button("Play Again", action: onRestart)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(.purple)
            }
        }
    }
}
