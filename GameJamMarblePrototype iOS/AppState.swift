//
//  AppState.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

enum AppPhase {
    case onboarding
    case gameList
    case gameFlow(GameDefinition)
}

enum GameFlowPhase {
    case instructions
    case playing
    case results(GameResult)
    case rating(GameResult)
    case tips(GameResult)
}

@Observable
final class AppState {
    var appPhase: AppPhase = .onboarding
    var gameFlowPhase: GameFlowPhase = .instructions

    func startGame(_ game: GameDefinition) {
        gameFlowPhase = .instructions
        appPhase = .gameFlow(game)
    }

    func gameDidBegin() {
        gameFlowPhase = .playing
    }

    func gameDidComplete(result: GameResult) {
        gameFlowPhase = .results(result)
    }

    func continueToRating(result: GameResult) {
        gameFlowPhase = .rating(result)
    }

    func continueToTips(result: GameResult) {
        gameFlowPhase = .tips(result)
    }

    func finishGame() {
        appPhase = .gameList
    }
}
