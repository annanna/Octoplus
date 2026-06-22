//
//  DifficultyRatingView.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

struct DifficultyRatingView: View {
    let game: GameDefinition
    let onSubmit: (Int) -> Void

    @State private var selectedRating: Int? = nil

    private let labels = ["Sehr leicht", "Leicht", "Mittel", "Schwer", "Sehr schwer"]

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.07, blue: 0.16)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Text("Wie schwer war das?")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 8)

                Text("Deine Einschätzung hilft uns, das Spiel für dich anzupassen.")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 48)

                HStack(spacing: 12) {
                    ForEach(1...5, id: \.self) { rating in
                        ratingButton(rating)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)

                if let selected = selectedRating {
                    Text(labels[selected - 1])
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .transition(.opacity)
                }

                Spacer()

                Button("Weiter") {
                    onSubmit(selectedRating ?? 3)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(game.accentColor)
                .disabled(selectedRating == nil)
                .padding(.bottom, 56)
            }
            .animation(.easeInOut, value: selectedRating)
        }
    }

    private func ratingButton(_ rating: Int) -> some View {
        let isSelected = selectedRating == rating
        return Button {
            selectedRating = rating
        } label: {
            Text(ratingEmoji(rating))
                .font(.system(size: 36))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isSelected ? game.accentColor.opacity(0.3) : .white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(isSelected ? game.accentColor : Color.clear, lineWidth: 2)
                        )
                )
        }
        .buttonStyle(.plain)
    }

    private func ratingEmoji(_ rating: Int) -> String {
        switch rating {
        case 1: return "😌"
        case 2: return "🙂"
        case 3: return "😐"
        case 4: return "😅"
        case 5: return "😤"
        default: return "😐"
        }
    }
}
