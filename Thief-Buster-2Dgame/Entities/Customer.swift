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
    // Defines the customer's walking animation textures.
    override var walkTextures: [SKTexture] {
        (1...3).map { i in
            SKTexture(imageNamed: "CustomerWalk\(i)")
        }
    }
    
    // Initializes the customer with specific width and default texture.
    init(width: CGFloat) {
        super.init(initialTexture: "CustomerWalk1", width: width)
        self.setScale(0.6)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func die() {
        
        if !active { return }
        
        SoundManager.shared.play(sound: .hitCust)
        
        super.die()
    }
    override var dieTextures: [SKTexture] {
        return [SKTexture(imageNamed: "CustomerHit")]
        
    }
}
