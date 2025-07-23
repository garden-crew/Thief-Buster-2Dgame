//
//  PowerUp.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// PowerUp.swift – logika power-up (muncul dan efeknya).

import Foundation
import SpriteKit

class PowerUp : Obstacle {
    
    // Defines the power up's walking animation textures.
    override var walkTextures: [SKTexture] {
        (1...2).map { i in
            SKTexture(imageNamed: "PowerMove\(i)")
        }
    }
    
    override var WindTextures: [SKTexture] {
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
        SoundManager.shared.play(sound: .powerUp)
        HapticManager.shared.vibratePowerUp()
        super.die()
        
        // Bunuh semua thief
        self.parent?.children.forEach { node in
            if node.name == "obstacle" && node is Thief {
                (node as! Thief).die()
            }
        }
        
        // Animasi angin
        let windAnimation = SKAction.animate(with: WindTextures, timePerFrame: 0.1)
        let removeAction = SKAction.removeFromParent()
        
        let windNode = SKSpriteNode(texture: WindTextures.first)
        if let scene = self.scene {
            windNode.position = CGPoint(x: scene.size.width / 2, y: self.position.y)
        }
        windNode.zPosition = self.zPosition + 1
        
        self.parent?.addChild(windNode)
        windNode.run(SKAction.sequence([windAnimation, removeAction]))
    }
    
    override var dieTextures: [SKTexture] {
        return[SKTexture(imageNamed: "PowerHit")]
    }
    
   
}
