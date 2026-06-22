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
        easier: [
            "Lege das Gerät auf eine feste Unterlage",
            "Mache kleine, ruhige Bewegungen",
            "Atme tief durch – Ruhe überträgt sich auf die Steuerung",
        ],
        harder: [
            "Versuche es mit einer Hand",
            "Halte das Gerät über Kopfhöhe",
            "Setze dir ein Punkteziel für die nächste Runde",
        ]
    ),
    makeView: { onComplete in
        AnyView(MazeGameView(onComplete: onComplete))
    },
    imageName: "TintenLabyrinth"
)
