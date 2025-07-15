//
//  Customer.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// Customer.swift – logika pelanggan (jangan dipukul).

import Foundation
import SpriteKit

class Customer : Obstacle {
    
    override var walkTextures: [SKTexture] {
        (1...3).map { i in
            SKTexture(imageNamed: "ObstacleWalk3")
        }
    }
    
    init(width: CGFloat) {
        super.init(initialTexture: "ObstacleWalk3", width: width)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
