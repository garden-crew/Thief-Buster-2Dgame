//
//  Thief_Buster_2DgameApp.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//

import SwiftUI
import SwiftData

@main
struct Thief_Buster_2DgameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Highscore.self)
    }
}
