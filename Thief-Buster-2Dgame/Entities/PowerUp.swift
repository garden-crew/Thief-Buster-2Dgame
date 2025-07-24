//
//  PowerUp.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// PowerUp.swift – logika power-up (muncul dan efeknya).

import Foundation
import SpriteKit
import SwiftUI

class PowerUp: Obstacle {

    // Defines the power up's walking animation textures.
    override var walkTextures: [SKTexture] {
        (1...2).map { i in
            SKTexture(imageNamed: "PowerMove\(i)")
        }
    }

    var windTextures: [SKTexture] {
        (1...6).map { i in
            SKTexture(imageNamed: "WindAnimation\(i)")
        }
    }

    // Initializes the power up with specific width and default texture.
    init(width: CGFloat) {
        super.init(initialTexture: "PowerMove1", width: width)
        self.setScale(0.7)
    }

    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func die() {
        
        if !active { return }
        
        HapticManager.shared.vibratePowerUp()
        super.die()

        showSuperPunchEffect()

        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            print("DELAYEDD")
            self.parent?.children.forEach { node in
                if node.name == "obstacle" && node is Thief {
                    (node as! Thief).die()
                }
            }
        }
        
        self.run(SKAction.playSoundFileNamed("PowerUp.mp3", waitForCompletion: false))
    }

    override var dieTextures: [SKTexture] {
        return [SKTexture(imageNamed: "PowerHit")]
    }

    func showSuperPunchEffect() {
        let windAnimation = SKAction.animate(
            with: windTextures,
            timePerFrame: 0.15
        )
        let removeAction = SKAction.removeFromParent()
        let fade = SKAction.fadeOut(withDuration: 0.15)

        let windNode = SKSpriteNode(texture: windTextures.first)

        if let scene = self.scene {
            windNode.position = CGPoint(
                x: scene.size.width / 2,
                y: self.position.y * 1.2
            )
            windNode.anchorPoint = CGPoint(x: 0.5, y: 1)
            windNode.size = CGSize(
                width: scene.size.width,
                height: self.position.y
            )
        }

        windNode.zPosition = ZPosition.obstacle.rawValue + 1

        self.parent?.addChild(windNode)
        windNode.run(SKAction.sequence([windAnimation, fade, removeAction]))
    }

}

#Preview {
    ContentView()
}
