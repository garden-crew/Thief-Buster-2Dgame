//
//  Thief.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// Thief.swift – logika untuk maling (spawn, animasi, collision).
import SpriteKit

enum ThiefState {
    case idle
    case move
    case flee
}

class Thief: SKSpriteNode {
    var state: ThiefState = .idle
    var moveTextures: [SKTexture] = []
    var fleeTextures: [SKTexture] = []
    
    init() {
        let texture = SKTexture(imageNamed: "18") // placeholder
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = "thief"
        self.zPosition = 5
        self.setupTextures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupTextures() {
        moveTextures = [
            SKTexture(imageNamed: "18"),
            SKTexture(imageNamed: "19"),
            SKTexture(imageNamed: "20"),
            SKTexture(imageNamed: "19"),
            SKTexture(imageNamed: "18")
        ]
        fleeTextures = [
            SKTexture(imageNamed: "22"),
            SKTexture(imageNamed: "23")
        ]
    }
    
    func transition(to newState: ThiefState) {
        guard state != newState else { return }
        state = newState
        
        // Hapus semua animasi agar transisi bersih
        self.removeAllActions()
        
        switch state {
        case .idle:
            // Bisa pakai texture pertama (tidak animasi)
            self.texture = moveTextures.first
            
        case .move:
            // Animasi jalan
            let animation = SKAction.repeatForever(
                SKAction.animate(with: moveTextures, timePerFrame: 0.15)
            )
            self.run(animation)
            
        case .flee:
            // Animasi hilang
            let sequence = SKAction.sequence([
                SKAction.animate(with: fleeTextures, timePerFrame: 0.1),
                SKAction.fadeOut(withDuration: 0.2),
                SKAction.removeFromParent()
            ])
            self.run(sequence)
        }
    }
}
