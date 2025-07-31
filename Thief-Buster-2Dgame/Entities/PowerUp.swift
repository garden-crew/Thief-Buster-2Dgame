//
//  PowerUp.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// PowerUp.swift – logika power-up (muncul dan efeknya).

import Foundation
import SpriteKit
import SwiftUI
//halo
class PowerUp: Obstacle {

    // Defines the power up's walking animation textures.
    override var walkTextures: [SKTexture] {
        (1...2).map { i in
            SKTexture(imageNamed: "PowerMove\(i)")
        }
    }

    var windTextures: [SKTexture] {
        (1...6).map { i in
            SKTexture(imageNamed: "WindAnimation\(i)")
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
        
        if !active { return }
        
        HapticManager.shared.vibratePowerUp()
        super.die()

        showSuperPunchEffect()
        triggerJuicyEffects()

        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            print("DELAYEDD")
            self.parent?.children.forEach { node in
                if node.name == "obstacle" && node is Thief {
                    (node as! Thief).die()
                }
            }
        }
        
        self.run(SKAction.playSoundFileNamed("PowerUp.mp3", waitForCompletion: false))
    }

    override var dieTextures: [SKTexture] {
        return [SKTexture(imageNamed: "PowerHit")]
    }
    
    func triggerJuicyEffects() {
        guard let scene = self.scene as? GameScene else { return }

        // ⚡ Flash
        let flash = SKSpriteNode(color: .white, size: scene.size)
        flash.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        flash.zPosition = ZPosition.inGameUI.rawValue
        scene.addChild(flash)

        flash.run(.sequence([
            SKAction.fadeAlpha(to: 0.8, duration: 0.05),
            SKAction.fadeOut(withDuration: 0.2),
            .removeFromParent()
        ]))

        // 🎥 Camera shake
        let amplitudeX: CGFloat = 10
        let amplitudeY: CGFloat = 6
        let numberOfShakes = 5
        var actionsArray: [SKAction] = []
        for _ in 1...numberOfShakes {
            let moveX = CGFloat.random(in: -amplitudeX...amplitudeX)
            let moveY = CGFloat.random(in: -amplitudeY...amplitudeY)
            let shake = SKAction.moveBy(x: moveX, y: moveY, duration: 0.03)
            shake.timingMode = .easeOut
            actionsArray.append(shake)
            actionsArray.append(shake.reversed())
        }
        let shakeSequence = SKAction.sequence(actionsArray)
        scene.cameraNode.run(shakeSequence)

        // 🐢 Slow motion singkat
        scene.speed = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            scene.speed = 1.0
        }

        // 🏆 Label dramatis
//        let label = SKLabelNode(text: "WIND BLAST!")
//        label.fontName = "Pixellari"
//        label.fontSize = 40
//        label.fontColor = .cyan
//        label.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
//        label.zPosition = ZPosition.inGameUI.rawValue
//        scene.addChild(label)

//        label.run(.sequence([
//            SKAction.scale(to: 1.2, duration: 0.1),
//            SKAction.wait(forDuration: 0.4),
//            SKAction.fadeOut(withDuration: 0.3),
//            .removeFromParent()
//        ]))
    }


    func showSuperPunchEffect() {
        let windAnimation = SKAction.animate(
            with: windTextures,
            timePerFrame: 0.15
        )
        let removeAction = SKAction.removeFromParent()
        let fade = SKAction.fadeOut(withDuration: 0.15)

        let windNode = SKSpriteNode(texture: windTextures.first)

        if let scene = self.scene {
            windNode.position = CGPoint(
                x: scene.size.width / 2,
                y: self.position.y * 1.2
            )
            windNode.anchorPoint = CGPoint(x: 0.5, y: 1)
            windNode.size = CGSize(
                width: scene.size.width,
                height: self.position.y
            )
        }

        windNode.zPosition = ZPosition.obstacle.rawValue + 1

        self.parent?.addChild(windNode)
        
        self.run(SKAction.playSoundFileNamed("PowerUp.mp3", waitForCompletion: false))
        HapticManager.shared.vibratePowerUp()

        windNode.run(SKAction.sequence([windAnimation, fade, removeAction]))
    }

}

#Preview {
    ContentView()
}
