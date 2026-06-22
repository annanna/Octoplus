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
    case tips(GameResult, Bool)
}

@Observable
final class AppState {
    var appPhase: AppPhase = .onboarding
    var gameFlowPhase: GameFlowPhase = .instructions
    var pendingAxesSwapped: Bool = false

    func startGame(_ game: GameDefinition) {
        pendingAxesSwapped = false
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

    func continueToTips(result: GameResult, wasEasy: Bool) {
        gameFlowPhase = .tips(result, wasEasy)
    }

    func restartGame(axesSwapped: Bool = false) {
        pendingAxesSwapped = axesSwapped
        gameFlowPhase = .playing
    }

    func finishGame() {
        appPhase = .gameList
    }
}
