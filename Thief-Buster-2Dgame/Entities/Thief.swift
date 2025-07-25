//
//  Thief.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// Thief.swift – logika untuk maling (spawn, animasi, collision).

import Foundation
import SpriteKit

class Thief : Obstacle {
    
    var lane: Int = 2
    
    // Defines the thief's walking animation textures.
    override var walkTextures: [SKTexture] {
        (1...3).map { i in
            SKTexture(imageNamed: "ThiefWalk\(i)")
        }
    }
    override var dieTextures: [SKTexture] {
        return [SKTexture(imageNamed: "ThiefCanHit")]
    }
    
    // Initializes the thief with specific width and default texture.
    init(width: CGFloat) {
        super.init(initialTexture: "ThiefWalk1", width: width)
        self.setScale(1.1)
        
    }
    
    var attackAction: SKAction {
        let textureName = (lane == 1) ? "ThiefNotHitFlip" : "ThiefNotHit"
        return SKAction.setTexture(SKTexture(imageNamed: textureName))
        
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
