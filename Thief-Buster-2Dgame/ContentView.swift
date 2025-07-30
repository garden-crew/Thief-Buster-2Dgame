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
    @State private var showDeveloperModal = false

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
            .statusBarHidden()
            .onLongPressGesture(minimumDuration: 3) {  // 3 second long press to show developer modal
                showDeveloperModal = true
            }
            .sheet(isPresented: $showDeveloperModal) {
                DeveloperModalView(scene: scene)
            }
    }
}

#Preview {
    ContentView()
}
