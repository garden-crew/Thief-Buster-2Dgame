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
    
    private var obstacleSpeed: Double = 200
    private var obstacleSpawnChance: Double = 1

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
        scene.size.height * 1
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
                print(num)

                if (Double(num) / 100.0) > self.calculatedObstacleSpawnChance {
                    return
                }

                let width = ((self.scene.size.width) - (16 * 4)) / 3
                
                var obstacle : Obstacle
                var randomObstacleTypeNumber: Int = Int.random(in: 1...100)
                
                if randomObstacleTypeNumber < 5 {
                    obstacle = PowerUp(width: width)
                } else if randomObstacleTypeNumber < 30 {
                    obstacle = Customer(width: width)
                } else {
                    obstacle = Thief(width: width)
                }
                
                obstacle.name = "obstacle"

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

