//
//  GameResultsView.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

// MARK: - Particle data (stable, computed once at load)

private struct ConfettiItem: Identifiable {
    let id: Int
    let xFrac: CGFloat
    let size: CGFloat
    let color: Color
    let delay: Double
    let duration: Double
    let spin: Double
}

private struct BubbleItem: Identifiable {
    let id: Int
    let xFrac: CGFloat
    let diameter: CGFloat
    let delay: Double
    let duration: Double
}

// MARK: - View

struct GameResultsView: View {
    let game: GameDefinition
    let result: GameResult
    let onContinue: () -> Void
    
    private let confettiItems: [ConfettiItem] = {
        let colors: [Color] = [
            Color(red: 1.0, green: 0.78, blue: 0.0),
            Color(red: 0.25, green: 0.88, blue: 0.65),
            Color(red: 1.0, green: 0.45, blue: 0.60),
            .cyan, .orange, .white
        ]
        return (0..<30).map { (i: Int) in
            ConfettiItem(
                id: i,
                xFrac: CGFloat(i % 10) / 10.0 + 0.05,
                size: CGFloat(7 + i % 5),
                color: colors[i % colors.count],
                delay: Double(i % 8) * 0.25,
                duration: 2.2 + Double(i % 5) * 0.3,
                spin: Double(90 + (i % 4) * 90)
            )
        }
    }()
    
    private let bubbleItems: [BubbleItem] = {
        (0..<10).map { (i: Int) in
            BubbleItem(
                id: i,
                xFrac: CGFloat(i % 5) / 5.0 * 0.8 + 0.1,
                diameter: CGFloat(14 + (i % 4) * 7),
                delay: Double(i) * 0.45,
                duration: 2.8 + Double(i % 4) * 0.5
            )
        }
    }()

    @State private var appeared = false
    @State private var toniWiggle = false
    @State private var toniScale: CGFloat = 0
    @State private var headerOpacity: Double = 0

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.07, blue: 0.16).ignoresSafeArea()

            particlesLayer

            VStack(spacing: 0) {
                Spacer()
                toniHeader
                statsSection
                Spacer()
                continueButton
            }
        }
        .onAppear {
            appeared = true
            toniWiggle = true
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55)) {
                toniScale = 1
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.3)) {
                headerOpacity = 1
            }
        }
    }

    // MARK: - Particles

    private var particlesLayer: some View {
        GeometryReader { geo in
            // Bubbles float upward
            ForEach(bubbleItems) { b in
                Circle()
                    .strokeBorder(.cyan.opacity(0.5), lineWidth: 1.5)
                    .background(Circle().fill(.white.opacity(0.04)))
                    .frame(width: b.diameter, height: b.diameter)
                    .position(
                        x: b.xFrac * geo.size.width,
                        y: appeared ? -b.diameter : geo.size.height + b.diameter
                    )
                    .animation(
                        .linear(duration: b.duration)
                        .repeatForever(autoreverses: false)
                        .delay(3 + b.delay),
                        value: appeared
                    )
            }

            // Confetti falls downward, tumbling
            ForEach(confettiItems) { c in
                RoundedRectangle(cornerRadius: 2)
                    .fill(c.color.opacity(0.9))
                    .frame(width: c.size, height: c.size * 1.5)
                    .rotationEffect(.degrees(appeared ? c.spin : 0))
                    .position(
                        x: c.xFrac * geo.size.width,
                        y: appeared ? geo.size.height + c.size : -c.size
                    )
                    .animation(
                        .linear(duration: c.duration)
                        .repeatCount(1, autoreverses: false)
                        .delay(c.delay),
                        value: appeared
                    )
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Header

    private var toniHeader: some View {
        VStack(spacing: 4) {
            Image("toni")
                .resizable()
                .scaledToFit()
                .frame(height: 240)
                .rotationEffect(.degrees(toniWiggle ? 14 : -14))
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: toniWiggle)
                .scaleEffect(toniScale)
                .animation(.spring(response: 0.5, dampingFraction: 0.55), value: toniScale)

            Text("Gut gemacht!")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .opacity(headerOpacity)
                .padding(.top, 6)

            Text("Ich bin stolz auf dich!")
                .font(.system(size: 17))
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(.bottom, 40)
    }

    // MARK: - Stats

    private var statsSection: some View {
        HStack(spacing: 24) {
            statCell(
                symbol: nil,
                image: "schnecke",
                label: "Schnecken",
                value: "\(result.score)",
                accent: Color(red: 1.0, green: 0.78, blue: 0.0)
            )
            statCell(
                symbol: "doc.append",
                image: nil,
                label: "Wörter",
                value: "\(result.tapCount)",
                accent: Color(red: 0.25, green: 0.88, blue: 0.65)
            )
        }
        .padding(.horizontal, 32)
    }

    // MARK: - Button

    private var continueButton: some View {
        Button("Weiter") { onContinue() }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(game.accentColor)
            .padding(.bottom, 56)
    }

    // MARK: - Stat cell

    private func statCell(symbol: String?, image: String?, label: String, value: String, accent: Color) -> some View {
        VStack(spacing: 8) {
            if let symbol {
                Image(systemName: symbol)
                    .font(.system(size: 28))
                    .foregroundStyle(accent)
            } else if let image {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 36)
            }
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

#Preview {
    GameResultsView(game: mazeGame, result: .init(score: 10, timeUsed: 40, tapCount: 3)) {}
}
