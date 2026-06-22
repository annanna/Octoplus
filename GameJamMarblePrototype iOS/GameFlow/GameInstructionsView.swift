//
//  GameInstructionsView.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

struct GameInstructionsView: View {
    let game: GameDefinition
    let onStart: () -> Void
    let onBack: () -> Void

    @State private var slideIndex = 0

    private var slides: [InstructionSlide] { game.instructionSlides }
    private var hasSlides: Bool { !slides.isEmpty }

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.07, blue: 0.16)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Back button
                HStack {
                    Button(action: onBack) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                            Text("Spiele")
                        }
                        .font(.system(size: 16))
                        .foregroundStyle(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)

                Spacer()

                if hasSlides {
                    slideContent
                } else {
                    readyContent
                }

                Spacer()

                bottomBar
            }
        }
    }

    private var slideContent: some View {
        VStack(spacing: 24) {
            Image(systemName: slides[slideIndex].symbol)
                .font(.system(size: 64))
                .foregroundStyle(game.accentColor)

            Text(slides[slideIndex].title)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Text(slides[slideIndex].body)
                .font(.system(size: 17))
                .foregroundStyle(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .animation(.easeInOut, value: slideIndex)
    }

    private var readyContent: some View {
        VStack(spacing: 24) {
            Image(systemName: "flag.checkered")
                .font(.system(size: 64))
                .foregroundStyle(game.accentColor)

            Text("Bereit?")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Tippe auf Start, wenn du loslegst.")
                .font(.system(size: 17))
                .foregroundStyle(.white.opacity(0.75))
        }
    }

    private var bottomBar: some View {
        VStack(spacing: 20) {
            if hasSlides {
                HStack(spacing: 8) {
                    ForEach(0..<slides.count, id: \.self) { i in
                        Circle()
                            .fill(i == slideIndex ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: slideIndex)
                    }
                }
            }

            let isLastSlide = !hasSlides || slideIndex == slides.count - 1

            Button(isLastSlide ? "Spiel starten" : "Weiter") {
                if isLastSlide {
                    onStart()
                } else {
                    withAnimation(.easeInOut) { slideIndex += 1 }
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(game.accentColor)
        }
        .padding(.bottom, 56)
    }
}
