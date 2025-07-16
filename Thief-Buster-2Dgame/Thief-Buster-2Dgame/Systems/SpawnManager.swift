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
    var scene: SKScene
    
    // Base speed of obstacles (pixels per second).
    private var obstacleSpeed: Double = 50
    // Base spawn probability (0.0 - 1.0).
    private var obstacleSpawnChance: Double = 0.5

    // Returns adjusted speed, ensuring a minimum value of 200.
    var calculatedObstacleSpeed: Double {
        max(200, obstacleSpeed)
    }

    // Returns adjusted spawn chance, clamped to max 1.0.
    var calculatedObstacleSpawnChance: Double {
        min(1, obstacleSpawnChance)
    }

    var obstacleMoveTime: Double {
        endHeight / calculatedObstacleSpeed
    }

    var endHeight: Double {
        scene.size.height * 1.0
    }

    var timer: Timer?
    
    init(scene: SKScene) {
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
//                print(num)

                if (Double(num) / 100.0) > self.calculatedObstacleSpawnChance {
                    return
                }

                let laneWidth = ((self.scene.size.width) - (16 * 4)) / 3
                let width = laneWidth * 0.7
                
                // Determine obstacle type
                var obstacle : Obstacle
                let randomObstacleTypeNumber: Int = Int.random(in: 1...100)
                
                if randomObstacleTypeNumber < 5 {
                    obstacle = PowerUp(width: width)
                } else if randomObstacleTypeNumber < 30 {
                    obstacle = Customer(width: width)
                } else {
                    obstacle = Thief(width: width)
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
                

                let sequenceAction = SKAction.sequence([
                    moveAction
                ])

                obstacle.run(sequenceAction)

                self.scene.addChild(obstacle)
            }
        )

    }
    
}

