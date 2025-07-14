//
//  ContentView.swift
//  Trying BishiBashi
//
//  Created by Edward Suwandi on 10/07/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    // Buat scene SpriteKit
    var scene: SKScene {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        VStack {
            SpriteView(scene: scene)
                .border(Color.black)
        }
    }
}

#Preview {
    ContentView()
}
