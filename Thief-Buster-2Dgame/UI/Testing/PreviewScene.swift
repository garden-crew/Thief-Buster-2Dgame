//
//  PreviewScene.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 22/07/25.
//
// PreviewScene.swift

import SpriteKit

class PreviewScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        // Tampilkan StartView
        let overlay = StartView.build(on: self)
        addChild(overlay)
    }
}

