//
//  Obstacle.swift
//  Thief-Buster-2Dgame
//
//  Created by Ilham Wisnu on 14/07/25.
//

import Foundation
import SpriteKit

// Base class for all obstacle types (Thief, Customer, PowerUp).
class Obstacle: SKSpriteNode {

    var alive = true

    var onDie: (() -> Void)?

    // Textures used for walking animation.
    // Subclasses should override this to provide their own animation frames.
    var walkTextures: [SKTexture] {
        (1...3).map { SKTexture(imageNamed: "ObstacleWalk\($0)") }
    }

    var dieTextures: [SKTexture] {
        []
    }

    var walkTimePerFrame: TimeInterval { 0.2 }

    init(
        initialTexture: String = "ObstacleWalk1",
        width: CGFloat,
        onDie: (() -> Void)? = nil
    ) {
        let texture = SKTexture(imageNamed: initialTexture)

        let originalSize = texture.size()

        let aspectRatio = originalSize.height / originalSize.width

        let height = width * aspectRatio

        let scaledSize = CGSize(width: width, height: height)

        super.init(texture: texture, color: .clear, size: scaledSize)

        setupWalkAnimaton()
    }

    func setupWalkAnimaton() {
        let walk = SKAction.animate(
            with: walkTextures,
            timePerFrame: walkTimePerFrame
        )
        run(.repeatForever(walk))
    }

    func die() {

        if !alive { return }
        
        alive = false

        onDie?()
        removeAllActions()

        let dieAnimation = SKAction.animate(
            with: walkTextures,
            timePerFrame: walkTimePerFrame
        )

        let sequenceAction = SKAction.sequence([
            dieAnimation,
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent(),
        ])

        run(sequenceAction)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
