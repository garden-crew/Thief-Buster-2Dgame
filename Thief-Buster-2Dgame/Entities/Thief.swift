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
    
    // Defines the thief's walking animation textures.
    override var walkTextures: [SKTexture] {
        (1...3).map { i in
            SKTexture(imageNamed: "ThiefWalk\(i)")
        }
    }
    
    // Initializes the thief with specific width and default texture.
    init(width: CGFloat) {
        super.init(initialTexture: "ThiefWalk1", width: width)
        self.setScale(0.75)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
