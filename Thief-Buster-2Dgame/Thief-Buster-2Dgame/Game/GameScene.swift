//
//  MyGameScene.swift
//  TryEnemiesRandomGeneration
//
//  Created by Ilham Wisnu on 10/07/25.
//

import SpriteKit
import SwiftUI

class MyGameScene: SKScene {

    lazy var spawnManager: SpawnManager = SpawnManager(
        scene: self
    )

    override func didMove(to view: SKView) {
        backgroundColor = .black

        spawnManager.generate()

        let buttonTexture = SKTexture(imageNamed: "play_button")  // or use nil for solid color
        let button = SKButton(
            texture: buttonTexture,
            size: CGSize(width: 100, height: 50)
        ) {
            self.isPaused.toggle()
        }
        button.position = CGPoint(x: size.width / 2, y: size.height / 2)

        addChild(button)
    }

    override func willMove(from view: SKView) {
    }

}

class SKButton: SKSpriteNode {
    var action: (() -> Void)?

    init(texture: SKTexture?, size: CGSize, action: (() -> Void)? = nil) {
        super.init(texture: texture, color: .clear, size: size)
        self.isUserInteractionEnabled = true
        self.action = action
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 0.7  // visual feedback
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 1.0
        action?()
    }

    override func touchesCancelled(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        self.alpha = 1.0
    }
}

#Preview {
    ContentView()
}
