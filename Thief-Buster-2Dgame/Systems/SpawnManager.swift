//
//  SpawnManager.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// SpawnManager.swift – handle kemunculan thief, customer, power-up.

import Foundation
import SpriteKit

// Manages spawning of game obstacles (Thief, Customer, PowerUp) at random intervals and positions.
class SpawnManager {
    var scene: GameScene
    
    private var baseObstacleSpeed: Double = 50
    private var baseObstacleSpawnRate: Double = 0.3

    var calculatedObstacleSpeed: Double {
        let score = Double(scene.score)
        let speed = baseObstacleSpeed + (score / 10)
        return max(200, speed)
    }

    // Returns adjusted spawn rate, clamped to max 1.0.
    var calculatedObstacleSpawnRate: Double {
        
        let score = Double(scene.score)
        
        if score < 30 {
            return 0.2
        }
        
        let spawnRate: Double = baseObstacleSpawnRate + score/1000
        
        return min(0.8, spawnRate)
    }

    var obstacleMoveTime: Double {
        endHeight / calculatedObstacleSpeed
    }

    var endHeight: Double {
        scene.size.height * 1.0
    }

    var timer: Timer?
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    // Starts spawning obstacles on a timer loop. Called once from GameScene.
    func generate() {
        timer?.invalidate()
        timer = nil
        
        // Repeat every 0.5 second
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.5,
            repeats: true,
            block: { _ in

                let num: Int = Int.random(in: 1...100)

                if (Double(num) / 100.0) > self.calculatedObstacleSpawnRate {
                    return
                }

                let laneWidth = ((self.scene.size.width) - (16 * 4)) / 3
                let width = laneWidth * 0.7
                
                // Determine obstacle type
                var obstacle : Obstacle
                
                let randomObstacleTypeNumber: Int = Int.random(in: (self.scene.score > 300) ? 1...100 : 6...100)
                
                if randomObstacleTypeNumber <= 5 {
                    obstacle = PowerUp(width: width)
                } else if randomObstacleTypeNumber < 30 {
                    obstacle = Customer(width: width)
                } else {
                    obstacle = Thief(width: width)
                    obstacle.onDie = {
                        self.scene.score += 5
                    }
                }
                
                obstacle.name = "obstacle"
                obstacle.zPosition = 5
                
                let lane = Int.random(in: 1...3)
                let laneX = self.scene.size.width * CGFloat(lane) / 4.0

                obstacle.position = CGPoint(x: laneX, y: -obstacle.size.height)

                let endPoint = CGPoint(x: laneX, y: self.endHeight)

                let moveAction = SKAction.move(
                    to: endPoint,
                    duration: self.obstacleMoveTime
                )
                
                var actions = [moveAction]
                
                if obstacle is Thief {
                    
                    let gameOverAction = SKAction.customAction(withDuration: 1, actionBlock: { _, _ in
                        self.scene.gameManager.gameOver()
                    })
                    
                    actions.append(gameOverAction)
                }
                
                let sequenceAction = SKAction.sequence(actions)

                obstacle.run(sequenceAction)

                self.scene.addChild(obstacle)
            }
        )

    }
    
}

