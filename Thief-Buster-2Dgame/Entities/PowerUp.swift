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
        self.parent?.children.forEach { node in
            if node.name == "obstacle" && node is Thief {
                (node as! Thief).die()
            }
        }
    }
    
    override var dieTextures: [SKTexture] {
        return[SKTexture(imageNamed: "PowerHit")]
    }
    
}
