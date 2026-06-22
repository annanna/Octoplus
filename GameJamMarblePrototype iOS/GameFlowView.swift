//
//  GameFlowView.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

struct GameFlowView: View {
    let game: GameDefinition
    @Environment(AppState.self) private var appState

    var body: some View {
        switch appState.gameFlowPhase {
        case .instructions:
            GameInstructionsView(game: game) {
                appState.gameDidBegin()
            } onBack: {
                appState.finishGame()
            }
        case .playing:
            game.makeView { result in
                appState.gameDidComplete(result: result)
            }
        case .results(let result):
            GameResultsView(game: game, result: result) {
                appState.continueToRating(result: result)
            }
        case .rating(let result):
            DifficultyRatingView(game: game) { _ in
                appState.continueToTips(result: result)
            }
        case .tips(let result):
            GameTipsView(game: game, result: result) {
                appState.finishGame()
            }
        }
    }
}
