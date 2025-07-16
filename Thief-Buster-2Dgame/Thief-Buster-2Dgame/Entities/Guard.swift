//
//  Guard.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//

import SpriteKit

// Represents the state of the player (Guard).
enum PlayerState {
    case idle
    case attack
    case fail
}

// This class manages texture loading and transitions between player states.
class Guard: SKSpriteNode {
    var state: PlayerState = .idle
    var idleTexture: SKTexture!
    var attackTextures: [SKTexture] = []
    var failTexture: SKTexture!
    
    // Initializes the guard with default texture and sets up animations.
    init() {
        let texture = SKTexture(imageNamed: "1") // placeholder
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = "guard"
        self.zPosition = 10
        self.setupTextures()
    }
    
    // Not used. Required by Swift when subclassing SKSpriteNode.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupTextures() {
        idleTexture = SKTexture(imageNamed: "1")
        attackTextures = [
            SKTexture(imageNamed: "4"),
            SKTexture(imageNamed: "5")
        ]
        failTexture = SKTexture(imageNamed: "14")
    }
    
    // Changes the guard's state and updates texture/animation accordingly.
    func transition(to newState: PlayerState) {
        print("Trans", newState)
        guard state != newState else { return }
        state = newState

        switch state {
        case .idle:
            self.texture = idleTexture
            self.removeAllActions()

        case .attack:
            let animation = SKAction.animate(with: attackTextures, timePerFrame: 0.1)
            let sequence = SKAction.sequence([
                animation,
                SKAction.run { [weak self] in self?.transition(to: .idle) }
            ])
            self.run(sequence)

        case .fail:
            self.texture = failTexture
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                SKAction.run { [weak self] in self?.transition(to: .idle) }
            ]))
        }
    }
}
