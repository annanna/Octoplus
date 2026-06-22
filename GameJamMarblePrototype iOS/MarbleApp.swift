//
//  MarbleApp.swift
//  GameJamMarblePrototype iOS
//
//  Created by Anna Münster  on 09.06.26.
//

import SwiftUI

@main
struct MarbleApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
        }
    }
}
