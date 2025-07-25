//
//  ContentView.swift
//  Trying BishiBashi
//
//  Created by Edward Suwandi on 10/07/25.
//

import SpriteKit
import SwiftData
import SwiftUI

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
    @Query var highscores: [Highscore]

    var scene: SKScene {
        let screenSize = UIScreen.main.bounds.size

        let canvasSize: CGSize = .init(
            width: screenSize.width,
            height: screenSize.height * 1.5
        )

        let scene = GameScene(
            viewSize: screenSize,
            canvasSize: canvasSize
        )

        scene.scaleMode = .aspectFill
        scene.modelContext = modelContext

        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea(.all)  // Fullscreen
    }
}

#Preview {
    ContentView()
}
