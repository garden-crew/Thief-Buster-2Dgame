//
//  PreviewView.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 22/07/25.
//
// PreviewView.swift

import SwiftUI
import SpriteKit

struct PreviewView: View {
    var scene: SKScene {
        let scene = PreviewScene(size: CGSize(width: 390, height: 844)) // ukuran iPhone
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

#Preview {
    PreviewView()
}


