//
//  ContentView.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = GameScene()
        scene.size = UIScreen.main.bounds.size // Ukuran scene = ukuran layar
        scene.scaleMode = .aspectFill          // Supaya ikut ukuran device
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
