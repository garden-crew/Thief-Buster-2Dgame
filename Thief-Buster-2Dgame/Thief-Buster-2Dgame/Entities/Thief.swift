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
    
    override var walkTextures: [SKTexture] {
        (1...3).map { i in
            SKTexture(imageNamed: "ObstacleWalk1")
        }
    }
    
    init(width: CGFloat) {
        super.init(initialTexture: "ObstacleWalk1", width: width)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
