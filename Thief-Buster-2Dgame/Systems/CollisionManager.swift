//
//  CollisionManager.swift
//  Thief-Buster-2Dgame
//
//  Created by Edward Suwandi on 11/07/25.
//

import Foundation
import SpriteKit

class CollisionManager {
    var gamescene: GameScene

    init(gamescene: GameScene) {
        self.gamescene = gamescene
    }

    func handleTouches(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if gamescene.isOverlayShown {
            return
        }
        
        let location = touch.location(in: gamescene)
        
        func checkAlignment(with target: SKShapeNode) {
            let targetCenterY = target.position.y
            let targetHalfHeight = target.frame.size.height
            let perfectThreshold: CGFloat = 40.0
            
            let nodes = gamescene.nodes(at: target.position)
            let obstacles = nodes.compactMap { $0 as? Obstacle }
            
            obstacles.forEach { obstacle in
                let enemyPosition = obstacle.position.y
                let distance = abs(enemyPosition - targetCenterY)
                
                if distance <= perfectThreshold {
                    if obstacle is Thief {
                        obstacle.onDie = {
                            self.gamescene.score += 10
                            self.gamescene.run(SKAction.playSoundFileNamed("PerfectHit.mp3", waitForCompletion: false))
                            
                            // Kamera shake
                            let shake = SKAction.sequence([
                                SKAction.moveBy(x: 10, y: 0, duration: 0.05),
                                SKAction.moveBy(x: -20, y: 0, duration: 0.1),
                                SKAction.moveBy(x: 10, y: 0, duration: 0.05)
                            ])
                            self.gamescene.cameraNode.run(shake)
                            
                            // Container node untuk menampung text dan effect
                            let container = SKNode()
                            container.position = CGPoint(
                                x: obstacle.position.x,
                                y: obstacle.position.y + 100
                            )
                            container.zPosition = ZPosition.inGameUI.rawValue
                            
                            // PERFECT text
                            let perfectNode = GradedTextNode(
                                text: "PERFECT",
                                fontName: "Pixellari",
                                fontSize: 20,
                                gradientColors: [.yellow, .orange, .red]
                            )
                            perfectNode.position = .zero // di tengah container
                            
                            // PERFECT effect
                            let perfectEffect = SKSpriteNode(imageNamed: "PerfectEffect")
                            perfectEffect.position = .zero // di tengah container
                            
                            // Tambahkan ke container
                            container.addChild(perfectEffect)
                            container.addChild(perfectNode)
                            
                            self.gamescene.addChild(container)
                            
                            // Jalankan animasi bersamaan
                            let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                            let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
                            let wait = SKAction.wait(forDuration: 0.5)
                            let fadeOut = SKAction.fadeOut(withDuration: 0.3)
                            let remove = SKAction.removeFromParent()
                            
                            let textSequence = SKAction.sequence([fadeIn, scaleUp, wait, fadeOut, remove])
                            let effectSequence = SKAction.sequence([fadeIn, scaleUp, wait, fadeOut, remove])
                            
                            perfectNode.run(textSequence)
                            perfectEffect.run(effectSequence)
                        }
                    }
                    obstacle.die()
                    return
                }
                
                if distance <= targetHalfHeight {
                    if obstacle is Thief {
                        obstacle.onDie = {
                            self.gamescene.score += 5
                            self.gamescene.run(SKAction.playSoundFileNamed("Punch.mp3", waitForCompletion: false))
                            
                            let goodNode = GradedTextNode(
                                text: "GOOD",
                                fontName: "Pixellari",
                                fontSize: 16,
                                gradientColors: [.blue, .cyan, .white]
                            )
                            goodNode.position = CGPoint(
                                x: obstacle.position.x,
                                y: obstacle.position.y + 100
                            )
                            goodNode.zPosition = ZPosition.inGameUI.rawValue
                            self.gamescene.addChild(goodNode)
                            goodNode.run(
                                SKAction.sequence([
                                    SKAction.fadeIn(withDuration: 0.2),
                                    SKAction.scale(to: 1.2, duration: 0.1),
                                    SKAction.wait(forDuration: 0.5),
                                    SKAction.fadeOut(withDuration: 0.3),
                                    SKAction.removeFromParent(),
                                ])
                            )
                        }
                    }
                    obstacle.die()
                    return
                }
            }
        }
        
        // Check button tapped
        if gamescene.attackButtonLeft.contains(location) {
            self.gamescene.run(SKAction.playSoundFileNamed("Whoosh.mp3", waitForCompletion: false))
            HapticManager.shared.vibrateLight()
            checkAlignment(with: gamescene.targetLeft)
        } else if gamescene.attackButtonCenter.contains(location) {
            self.gamescene.run(SKAction.playSoundFileNamed("Whoosh.mp3", waitForCompletion: false))
            HapticManager.shared.vibrateLight()
            checkAlignment(with: gamescene.targetMid)
        } else if gamescene.attackButtonRight.contains(location) {
            self.gamescene.run(SKAction.playSoundFileNamed("Whoosh.mp3", waitForCompletion: false))
            HapticManager.shared.vibrateLight()
            checkAlignment(with: gamescene.targetRight)
        }
    }
}
