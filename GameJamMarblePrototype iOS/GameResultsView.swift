//
//  GameResultsView.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

struct GameResultsView: View {
    let game: GameDefinition
    let result: GameResult
    let onContinue: () -> Void

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.07, blue: 0.16)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Image(systemName: "star.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(Color(red: 1.0, green: 0.78, blue: 0.0))
                    .padding(.bottom, 24)

                Text("Gut gemacht!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.bottom, 8)

                Text(game.title)
                    .font(.system(size: 17))
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(.bottom, 48)

                HStack(spacing: 24) {
                    statCell(
                        symbol: "trophy.fill",
                        label: "Punkte",
                        value: "\(result.score)",
                        accent: Color(red: 1.0, green: 0.78, blue: 0.0)
                    )
                    statCell(
                        symbol: "arrow.counterclockwise",
                        label: "Neustarts",
                        value: "\(result.tapCount)",
                        accent: Color(red: 0.25, green: 0.88, blue: 0.65)
                    )
                }
                .padding(.horizontal, 32)

                Spacer()

                Button("Weiter") {
                    onContinue()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(game.accentColor)
                .padding(.bottom, 56)
            }
        }
    }

    private func statCell(symbol: String, label: String, value: String, accent: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.system(size: 28))
                .foregroundStyle(accent)
            Text(value)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
    }
}
