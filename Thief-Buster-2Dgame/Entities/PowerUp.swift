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
        (1...3).map { i in
            SKTexture(imageNamed: "ObstacleWalk2")
        }
    }
    
    // Initializes the power up with specific width and default texture.
    init(width: CGFloat) {
        super.init(initialTexture: "ObstacleWalk2", width: width)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func die() {
        super.die()
        self.parent?.children.forEach { node in
            if node.name == "obstacle" && node is Thief {
                node.removeFromParent()
            }
        }
    }
    
}
