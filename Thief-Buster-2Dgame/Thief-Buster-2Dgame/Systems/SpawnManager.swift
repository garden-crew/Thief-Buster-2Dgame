//
//  SpawnManager.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// SpawnManager.swift – handle kemunculan thief, customer, power-up.

import Foundation
import SpriteKit

class SpawnManager {
    var scene: SKScene
    
    private var obstacleSpeed: Double = 50
    private var obstacleSpawnChance: Double = 0.3

    var calculatedObstacleSpeed: Double {
        max(200, obstacleSpeed)
    }

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
    
    func generate() {
        timer?.invalidate()
        timer = nil

        timer = Timer.scheduledTimer(
            withTimeInterval: 0.2,
            repeats: true,
            block: { _ in

                let num: Int = Int.random(in: 1...100)
//                print(num)

                if (Double(num) / 100.0) > self.calculatedObstacleSpawnChance {
                    return
                }

                let width = ((self.scene.size.width) - (16 * 4)) / 3
                
                var obstacle : Obstacle
                let randomObstacleTypeNumber: Int = Int.random(in: 1...100)
                
                var gameOverAction: SKAction?
                
                if randomObstacleTypeNumber < 5 {
                    obstacle = PowerUp(width: width)
                } else if randomObstacleTypeNumber < 30 {
                    obstacle = Customer(width: width)
                } else {
                    obstacle = Thief(width: width)
                    gameOverAction = SKAction.customAction(withDuration: 1, actionBlock: { _, _ in
                        self.scene.isPaused = true
                    })
                    
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
                
                if gameOverAction != nil {
                    actions.append(gameOverAction!)
                }
                
                let sequenceAction = SKAction.sequence(actions)

                obstacle.run(sequenceAction)

                self.scene.addChild(obstacle)
            }
        )

    }
    
}

