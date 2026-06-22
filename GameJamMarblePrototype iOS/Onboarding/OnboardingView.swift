//
//  OnboardingView.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

private let onboardingSlides: [InstructionSlide] = [
    InstructionSlide(
        title: "Willkommen!",
        body: "Ich bin Toni Tinte, dein tentakelstarker Trainingspartner",
        symbol: "fish.fill",
        imageName: "toni"
    ),
    InstructionSlide(
        title: "",
        body: """
            Gemeinsam üben wir Denkaufgaben und Körperaufgaben gleichzeitig auszuführen. 
            Der Alltag verlangt genau das ständig von uns: Telefonieren beim Kochen, Treppensteigen und den Tag planen.
            """,
        symbol: "umbrella.fill"
    ),
    InstructionSlide(
        title: "",
        body: """
            Für unser Gehirn ist das Schwerstarbeit.
            Stell dir einen Topf vor: Er fasst nur eine begrenzte Menge an Ressourcen. Müssen Denken und Bewegen gleichzeitig daraus schöpfen, wird es schnell eng. Die gute Nachricht.
            """,
        symbol: "cube.box.fill"
    ),
    InstructionSlide(
        title: "",
        body: """
            Bei ADHS kann dieser Topf rascher leer sein, da die Aufmerksamkeitssteuerung viele Ressourcen beansprucht. Durch gezieltes Training, füllen wir die Ressourcen im vorhinein auf.
            """,
        symbol: "cube.box"
    )
]

struct OnboardingView: View {
    let onDone: () -> Void
    
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                let slide = onboardingSlides[currentIndex]
                if let imageName = slide.imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 48)
                } else if let symbol = slide.symbol {
                    Image(systemName: symbol)
                        .font(.system(size: 80))
                        .foregroundStyle(.accent)
                        .padding(.bottom, 48)
                }
                
                Text(onboardingSlides[currentIndex].title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Text(onboardingSlides[currentIndex].body)
                    .font(.system(size: 20))
                    .foregroundStyle(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 64)
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
                
                Button(currentIndex < onboardingSlides.count - 1 ? "Tauch ein!" : "Los geht's!") {
                    if currentIndex < onboardingSlides.count - 1 {
                        withAnimation(.easeInOut) { currentIndex += 1 }
                    } else {
                        onDone()
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.accent)
                .padding(.bottom, 56)
            }
        }
    }
}
