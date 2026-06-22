//
//  GameTipsView.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

struct GameTipsView: View {
    let game: GameDefinition
    let result: GameResult
    let wasEasy: Bool
    let onRetry: (Bool) -> Void
    let onDone: () -> Void

    @State private var selectedChallenges: Set<String> = []

    private var tealColor: Color { Color(red: 0.18, green: 0.84, blue: 0.75) }

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.07, blue: 0.16)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        headerSection
                            .padding(.top, 32)

                        if wasEasy {
                            ForEach(game.tips.forEasy) { tip in
                                challengeRow(tip)
                            }
                        } else {
                            ForEach(game.tips.forHard) { tip in
                                tipRow(tip)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }

                bottomButtons
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 10) {
            Text(wasEasy ? "⭐️" : "🌊")
                .font(.system(size: 48))
            Text(wasEasy ? "Wow, du bist ein Profi!" : "Das war herausfordernd!")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            Text(wasEasy
                 ? "Wähle Erschwerungen für den nächsten Durchgang:"
                 : "Völlig normal – hier sind Tipps für den nächsten Versuch:")
                .font(.system(size: 15))
                .foregroundStyle(.white.opacity(0.65))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 8)
    }

    // MARK: - Challenge row (easy mode)

    private func challengeRow(_ tip: GameTip) -> some View {
        let isSelected = selectedChallenges.contains(tip.id)
        return HStack(spacing: 14) {
            emojiIcon(tip.emoji)

            VStack(alignment: .leading, spacing: 3) {
                Text(tip.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Text(tip.subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.6))
            }

            Spacer()

            Button {
                if isSelected {
                    selectedChallenges.remove(tip.id)
                } else {
                    selectedChallenges.insert(tip.id)
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(isSelected ? tealColor : Color.white.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: isSelected ? "checkmark" : "plus")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(isSelected ? Color(red: 0.04, green: 0.07, blue: 0.16) : .white)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Tip row (hard mode)

    private func tipRow(_ tip: GameTip) -> some View {
        HStack(alignment: .top, spacing: 14) {
            emojiIcon(tip.emoji)

            VStack(alignment: .leading, spacing: 6) {
                Text(tip.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Text(tip.subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)

                if let label = tip.actionLabel {
                    Text(label)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(tealColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .overlay(
                            Capsule().stroke(tealColor.opacity(0.6), lineWidth: 1)
                        )
                        .padding(.top, 4)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Shared emoji icon

    private func emojiIcon(_ emoji: String) -> some View {
        Text(emoji)
            .font(.system(size: 22))
            .frame(width: 44, height: 44)
            .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Bottom buttons

    private var bottomButtons: some View {
        VStack(spacing: 12) {
            Divider().overlay(Color.white.opacity(0.12))
            VStack(spacing: 10) {
                Button {
                    let axesSwapped = selectedChallenges.contains(
                        game.tips.forEasy.first(where: { $0.challenge == .axesSwapped })?.id ?? ""
                    )
                    onRetry(axesSwapped)
                } label: {
                    Label("Nochmal versuchen", systemImage: "arrow.clockwise")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(tealColor)

                Button("Zur Aufgabenliste") {
                    onDone()
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(tealColor)
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color(red: 0.04, green: 0.07, blue: 0.16))
    }
}
