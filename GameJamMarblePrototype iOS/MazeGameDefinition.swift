//
//  MazeGameDefinition.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

let mazeGame = GameDefinition(
    id: "maze",
    title: "Marble Maze",
    subtitle: "Neige dein Gerät, um den Oktopus ans Ziel zu bringen",
    accentColor: Color(red: 0.56, green: 0.35, blue: 0.93),
    isUnlocked: true,
    instructionSlides: [
        InstructionSlide(
            title: "Ziel des Spiels",
            body: "Neige dein Gerät, um den Oktopus durch das Labyrinth zu steuern. Sammle so viele Portale wie möglich, bevor die Zeit abläuft!",
            symbol: "scope"
        ),
        InstructionSlide(
            title: "Steuerung",
            body: "Die Schwerkraft folgt deiner Handbewegung. Neige langsam – zu schnell, und der Oktopus verliert die Kontrolle.",
            symbol: "iphone.motion"
        ),
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
    }
)
