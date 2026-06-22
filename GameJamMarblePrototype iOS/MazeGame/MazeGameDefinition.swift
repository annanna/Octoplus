//
//  MazeGameDefinition.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

let mazeGame = GameDefinition(
    id: "maze",
    title: "Tintenlabyrinth",
    subtitle: "Bring mich zur Schnecke und sammel Wörter",
    accentColor: .accent,
    isUnlocked: true,
    instructionSlides: [
        InstructionSlide(
            title: "Ziel des Spiels",
            body: "Neige dein Gerät, um mich durch das Labyrinth zu steuern. Sammle so viele Schnecken wie möglich, bevor die Zeit abläuft!",
            symbol: "scope"
        ),
        InstructionSlide(
            title: "Steuerung",
            body: "Die Schwerkraft folgt deiner Handbewegung.",
            symbol: "iphone.motion"
        ),
        InstructionSlide(
            title: "Wörterreihe",
            body: "Nenne währenddessen so viele Wört zu einem Thema, wie dir einfallen. Dabei gibt es kein Falsch oder Richtig, jede Antwort zählt! Wenn du eine Antwort ausgesprochen hast, tippe auf den Button unten rechts zum Zählen.",
            symbol: "waveform.path"
        )
    ],
    tips: GameTips(
        forEasy: [
            GameTip(id: "axes-swapped", emoji: "🔄", title: "Achsen tauschen",
                    subtitle: "Links/rechts-Neigung ist umgekehrt", challenge: .axesSwapped),
            GameTip(id: "one-leg", emoji: "🦵", title: "Auf einem Bein stehen",
                    subtitle: "Stehe auf einem Bein während der Übung"),
            GameTip(id: "radio-on", emoji: "📻", title: "Radio anschalten",
                    subtitle: "Erhöhe die akustische Ablenkung"),
        ],
        forHard: [
            GameTip(id: "no-noise", emoji: "🎧", title: "Geräusche ausschalten",
                    subtitle: "Setze Kopfhörer ein oder schalte das Radio neben dir aus, um Ablenkungen zu reduzieren."),
            GameTip(id: "meditation", emoji: "🧘", title: "1-Minuten-Meditation mit Toni",
                    subtitle: "Kurz durchatmen und den Kopf frei machen, bevor du neu startest.",
                    actionLabel: "Jetzt meditieren →"),
        ]
    ),
    makeView: { onComplete in
        AnyView(MazeGameView(onComplete: onComplete))
    },
    imageName: "TintenLabyrinth"
)
