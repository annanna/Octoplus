//
//  DifficultyRatingView.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

struct DifficultyRatingView: View {
    let game: GameDefinition
    let onSubmit: (Bool) -> Void

    @State private var selectedRating: Bool? = nil

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Text("Fiel dir die Aufgabe leicht?")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 36)
                
                HStack(spacing: 12) {
                    Button("Ja") {
                        selectDifficulty(true)
                    }
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 44)
                    .padding(.vertical, 34)
                    .background(.accent.opacity(0.8))
                    .clipShape(.circle)
                    .shadow(color: .black.opacity(0.3), radius: 16, y: 9)
                    
                    Button("Nein") {
                        selectDifficulty(false)
                    }       .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 44)
                        .padding(.vertical, 34)
                        .background(.accent.opacity(0.8))
                        .clipShape(.circle)
                        .shadow(color: .black.opacity(0.3), radius: 16, y: 9)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                Spacer()
            }
        }
    }
    
    func selectDifficulty(_ value: Bool) {
        selectedRating = value
        onSubmit(value)
    }
}

#Preview {
    DifficultyRatingView(game: mazeGame, onSubmit: {_ in })
}
