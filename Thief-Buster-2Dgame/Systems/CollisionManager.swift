//
//  CollisionManager.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// CollisionManager.swift – deteksi tabrakan.

//
//  Cobacoba.swift
//  Trying BishiBashi
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
        let location = touch.location(in: gamescene)

        // Thresholds to determine how close the obstacle is to the center of hit zone
        let perfectThreshold: CGFloat =
            gamescene.targetMid.frame.size.height / 4
        let goodThreshold: CGFloat = gamescene.targetMid.frame.size.height / 2

        // Helper function to check distance between obstacle and center of target area.
        // If within threshold, it's a hit (Perfect or Good). Otherwise, Miss.

        func checkAlignment(with target: SKShapeNode) {

            let targetCenterY = target.position.y
            let nodes = gamescene.nodes(at: target.position)

            // Filter to get obstacles only
            let obstacles =
                nodes.filter { node in
                    node.name == "obstacle"
                } as! [Obstacle]

            // Check distance and handle collision
            obstacles.forEach { obstacle in

                let enemyPosition =
                    obstacle.frame.minY + (obstacle.frame.size.height / 2)

                let distance = abs(enemyPosition - targetCenterY)
                
                if distance > goodThreshold {
                    return
                }
                
                if obstacle is Thief{
                    var score = 0
                    
                    if distance <= perfectThreshold {
                        score += 5
                    }
                    score += 5
                    obstacle.onDie = {
                        self.gamescene.score += score
                    }
                }
                
                print("die")
                obstacle.die()
            }

        }

        // Determine which attack button was touched and check corresponding lane
        if gamescene.attackButtonLeft.contains(location) {
            checkAlignment(with: gamescene.targetLeft)
        } else if gamescene.attackButtonCenter.contains(location) {
            checkAlignment(with: gamescene.targetMid)
        } else if gamescene.attackButtonRight.contains(location) {
            checkAlignment(with: gamescene.targetRight)
        }
    }
}
