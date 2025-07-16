//
//  ContentView.swift
//  Trying BishiBashi
//
//  Created by Edward Suwandi on 10/07/25.
//

import SwiftUI
import SpriteKit
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query var highscores: [Highscore]
    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .resizeFill
        scene.modelContext = modelContext
        
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea() // Fullscreen
    }
}


#Preview {
    ContentView()
}
