//
//  GameTipsView.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

struct GameTipsView: View {
    let game: GameDefinition
    let result: GameResult
    let onDone: () -> Void

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.07, blue: 0.16)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tipps für dich")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            Text("Beim nächsten Mal kannst du das Spiel leichter oder schwerer machen.")
                                .font(.system(size: 15))
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        .padding(.top, 24)

                        if !game.tips.easier.isEmpty {
                            tipSection(
                                title: "Leichter machen",
                                symbol: "arrow.down.circle.fill",
                                accentColor: Color(red: 0.25, green: 0.88, blue: 0.65),
                                tips: game.tips.easier
                            )
                        }

                        if !game.tips.harder.isEmpty {
                            tipSection(
                                title: "Schwerer machen",
                                symbol: "arrow.up.circle.fill",
                                accentColor: Color(red: 1.0, green: 0.47, blue: 0.0),
                                tips: game.tips.harder
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }

                // Fixed bottom button
                VStack(spacing: 0) {
                    Divider().overlay(Color.white.opacity(0.12))
                    Button("Zur Spielübersicht") {
                        onDone()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(game.accentColor)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                }
                .background(Color(red: 0.04, green: 0.07, blue: 0.16))
            }
        }
    }

    private func tipSection(title: String, symbol: String, accentColor: Color, tips: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: symbol)
                    .font(.system(size: 18))
                    .foregroundStyle(accentColor)
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(tips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: 12) {
                        Circle()
                            .fill(accentColor.opacity(0.5))
                            .frame(width: 6, height: 6)
                            .padding(.top, 7)
                        Text(tip)
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
            }
            .padding(16)
            .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
        }
    }
}
