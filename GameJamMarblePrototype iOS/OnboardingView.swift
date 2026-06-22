//
//  OnboardingView.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

private let onboardingSlides: [InstructionSlide] = [
    InstructionSlide(
        title: "Willkommen!",
        body: "Ich bin Ollie, euer Oktopus-Guide. Gemeinsam erkunden wir kleine Spiele, die zeigen, wie Stress entsteht – und wie ihr besser damit umgehen könnt.",
        symbol: "fish.fill"
    ),
    InstructionSlide(
        title: "Mini-Spiele",
        body: "Jedes Spiel dauert nur wenige Minuten. Danach bewertet ihr kurz, wie schwer es war – und bekommt Tipps für die nächste Runde.",
        symbol: "gamecontroller.fill"
    ),
    InstructionSlide(
        title: "Kein Richtig oder Falsch",
        body: "Es gibt keine Wertung, die zählt. Die Spiele sind dazu da, etwas über euch selbst herauszufinden – nicht um Highscores zu jagen.",
        symbol: "heart.fill"
    ),
]

struct OnboardingView: View {
    let onDone: () -> Void

    @State private var currentIndex = 0

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.07, blue: 0.16)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Image(systemName: onboardingSlides[currentIndex].symbol)
                    .font(.system(size: 80))
                    .foregroundStyle(Color(red: 0.56, green: 0.35, blue: 0.93))
                    .padding(.bottom, 48)

                Text(onboardingSlides[currentIndex].title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Text(onboardingSlides[currentIndex].body)
                    .font(.system(size: 17))
                    .foregroundStyle(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 16)

                Spacer()

                HStack(spacing: 8) {
                    ForEach(0..<onboardingSlides.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentIndex ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentIndex)
                    }
                }
                .padding(.bottom, 32)

                Button(currentIndex < onboardingSlides.count - 1 ? "Weiter" : "Los geht's!") {
                    if currentIndex < onboardingSlides.count - 1 {
                        withAnimation(.easeInOut) { currentIndex += 1 }
                    } else {
                        onDone()
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(Color(red: 0.56, green: 0.35, blue: 0.93))
                .padding(.bottom, 56)
            }
        }
    }
}
