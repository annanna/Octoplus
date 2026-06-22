//
//  GameListView.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

private let allGames: [GameDefinition] = [
    mazeGame,
    GameDefinition(
        id: "bubbles",
        title: "Bubble Pop",
        subtitle: "Demnächst verfügbar",
        accentColor: Color(red: 202/256, green: 157/256, blue: 113/256),
        isUnlocked: false,
        instructionSlides: [],
        tips: GameTips(easier: [], harder: []),
        makeView: { _ in AnyView(EmptyView()) }
    ),
    GameDefinition(
        id: "gravity",
        title: "Gravity Flip",
        subtitle: "Demnächst verfügbar",
        accentColor: Color(red: 1.0, green: 0.47, blue: 0.0),
        isUnlocked: false,
        instructionSlides: [],
        tips: GameTips(easier: [], harder: []),
        makeView: { _ in AnyView(EmptyView()) }
    ),
]

struct GameListView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.07, blue: 0.16)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Mini-Spiele")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.top, 24)

                    ForEach(allGames) { game in
                        GameCard(game: game) {
                            appState.startGame(game)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
}

private struct GameCard: View {
    let game: GameDefinition
    let onTap: () -> Void

    var body: some View {
        Button(action: { if game.isUnlocked { onTap() } }) {
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(game.accentColor.opacity(game.isUnlocked ? 0.25 : 0.1))
                    .frame(width: 56, height: 56)
                    .overlay {
                        Image(systemName: game.isUnlocked ? "gamecontroller.fill" : "lock.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(game.accentColor.opacity(game.isUnlocked ? 1 : 0.4))
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(game.title)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(game.isUnlocked ? .white : .white.opacity(0.4))
                    Text(game.subtitle)
                        .font(.system(size: 14))
                        .foregroundStyle(game.isUnlocked ? .white.opacity(0.6) : .white.opacity(0.3))
                }

                Spacer()

                if game.isUnlocked {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.4))
                } else {
                    Text("Coming Soon")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.4))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 6))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white.opacity(game.isUnlocked ? 0.08 : 0.04))
            )
        }
        .disabled(!game.isUnlocked)
    }
}
