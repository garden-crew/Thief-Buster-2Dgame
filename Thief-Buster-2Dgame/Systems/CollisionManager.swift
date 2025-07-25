//
//  CollisionManager.swift
//  Thief-Buster-2Dgame
//
//  Created by Edward Suwandi on 11/07/25.
//

import Foundation
import SpriteKit

// Manages touch input and collision detection between the guard and obstacles (Thief, Customer, PowerUp).
class CollisionManager {
    var gamescene: GameScene

    init(gamescene: GameScene) {
        self.gamescene = gamescene
    }

    // Handles player touch input and performs collision check against active obstacles in relevant lane.
    func handleTouches(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }
        
        if gamescene.isOverlayShown {
            return
        }
        
        let location = touch.location(in: gamescene)


        // Helper function to check distance between obstacle and center of target area.
        // If within threshold, it's a hit (Perfect or Good). Otherwise, Miss.

        func checkAlignment(with target: SKShapeNode) {

            let targetCenterY = target.position.y
            let targetHalfHeight = target.frame.size.height
            let perfectThreshold: CGFloat = 40.0

            let nodes = gamescene.nodes(at: target.position)

            // Filter to get obstacles only
            let obstacles =
                nodes.filter { node in
                    node.name == "obstacle"
                } as! [Obstacle]

            // Check distance and handle collision
            obstacles.forEach { obstacle in

                let enemyPosition = obstacle.position.y

                let distance = abs(enemyPosition - targetCenterY)

                if distance <= perfectThreshold {
                    if obstacle is Thief {
                        obstacle.onDie = {
                            self.gamescene.score += 10
                            self.gamescene.run(SKAction.playSoundFileNamed("Punch.mp3", waitForCompletion: false))
                            self.gamescene.run(
                                SKAction.sequence([
                                    SKAction.wait(forDuration: 0.2),
                                    SKAction.run {
                                        let perfectNode = GradedTextNode(
                                            text: "PERFECT",
                                            fontName: "Pixellari",
                                            fontSize: 16,
                                            gradientColors: [
                                                .yellow, .orange, .red,
                                            ]
                                        )
                                        perfectNode.position = CGPoint(
                                            x: obstacle.position.x,
                                            y: obstacle.position.y + 100
                                        )
                                        perfectNode.zPosition = ZPosition.inGameUI.rawValue
                                        self.gamescene.addChild(perfectNode)
                                        perfectNode.run(
                                            SKAction.sequence([
                                                SKAction.fadeIn(
                                                    withDuration: 0.2
                                                ),
                                                SKAction.scale(
                                                    to: 1.2,
                                                    duration: 0.1
                                                ),
                                                SKAction.wait(forDuration: 0.5),
                                                SKAction.fadeOut(
                                                    withDuration: 0.3
                                                ),
                                                SKAction.removeFromParent(),
                                            ])
                                        )
                                    },
                                ])
                            )
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
                            self.gamescene.run(
                                SKAction.sequence([
                                    SKAction.wait(forDuration: 0.2),
                                    SKAction.run {
                                        let goodNode = GradedTextNode(
                                            text: "GOOD",
                                            fontName: "Pixellari",
                                            fontSize: 16,
                                            gradientColors: [
                                                .blue, .cyan, .white,
                                            ]
                                        )
                                        goodNode.position = CGPoint(
                                            x: obstacle.position.x,
                                            y: obstacle.position.y + 100
                                        )
                                        goodNode.zPosition = ZPosition.inGameUI.rawValue
                                        self.gamescene.addChild(goodNode)
                                        goodNode.run(
                                            SKAction.sequence([
                                                SKAction.fadeIn(
                                                    withDuration: 0.2
                                                ),
                                                SKAction.scale(
                                                    to: 1.2,
                                                    duration: 0.1
                                                ),
                                                SKAction.wait(forDuration: 0.5),
                                                SKAction.fadeOut(
                                                    withDuration: 0.3
                                                ),
                                                SKAction.removeFromParent(),
                                            ])
                                        )
                                    },
                                ])
                            )
                        }
                    }
                    obstacle.die()

                    return
                }
            }

        }

        // Determine which attack button was touched and check corresponding lane
        if gamescene.attackButtonLeft.contains(location) {
            self.gamescene.run(SKAction.playSoundFileNamed("Whoosh.mp3", waitForCompletion: false))
            checkAlignment(with: gamescene.targetLeft)
        } else if gamescene.attackButtonCenter.contains(location) {
            self.gamescene.run(SKAction.playSoundFileNamed("Whoosh.mp3", waitForCompletion: false))
            checkAlignment(with: gamescene.targetMid)
        } else if gamescene.attackButtonRight.contains(location) {
            self.gamescene.run(SKAction.playSoundFileNamed("Whoosh.mp3", waitForCompletion: false))
            checkAlignment(with: gamescene.targetRight)
        }
    }
}
