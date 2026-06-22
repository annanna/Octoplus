//
//  GameDefinition.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

struct InstructionSlide: Identifiable {
    let id = UUID()
    let title: String
    let body: String
    let symbol: String?
    let imageName: String?
    
    init(title: String, body: String, symbol: String? = nil, imageName: String? = nil) {
        self.title = title
        self.body = body
        self.symbol = symbol
        self.imageName = imageName
    }
}

struct GameTips {
    let easier: [String]
    let harder: [String]
}

struct GameResult {
    let score: Int
    let timeUsed: Int
    let tapCount: Int
}

struct GameDefinition: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let accentColor: Color
    let isUnlocked: Bool
    let instructionSlides: [InstructionSlide]
    let tips: GameTips
    let makeView: (@escaping (GameResult) -> Void) -> AnyView
    var imageName: String
}
