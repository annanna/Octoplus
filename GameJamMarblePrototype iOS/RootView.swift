//
//  RootView.swift
//  GameJamMarblePrototype iOS
//

import SwiftUI

struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        switch appState.appPhase {
        case .onboarding:
            OnboardingView {
                appState.appPhase = .gameList
            }
        case .gameList:
            GameListView()
        case .gameFlow(let game):
            GameFlowView(game: game)
        }
    }
}
