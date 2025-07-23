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
    
    private var baseObstacleSpeed: Double = 250
    private var baseObstacleSpawnRate: Double = 0.3

    var calculatedObstacleSpeed: Double {
        let score = Double(scene.score)
        let speed = baseObstacleSpeed + (score / 2)
        return min(400, speed)
    }

    // Returns adjusted spawn rate, clamped to max 1.0.
    var calculatedObstacleSpawnRate: Double {
        
        let score = Double(scene.score)
        
        if score < 20 {
            return 0.2
        }
        
        let spawnRate: Double = baseObstacleSpawnRate + score/100
        
        return min(0.9, spawnRate)
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
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    // Starts spawning obstacles on a timer loop. Called once from GameScene.
    func generate(targetY endY: Double? = nil) {
        timer?.invalidate()
        timer = nil
        
        // Repeat every 0.5 second
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.8,
            repeats: true,
            block: { _ in
                

                let num: Int = Int.random(in: 1...100)
                
                print(num)

                if (Double(num) / 100.0) > self.calculatedObstacleSpawnRate {
                    return
                }
                
                var obstacle : Obstacle
                var actions : [SKAction] = []

                let lane = Int.random(in: 1...3)
                let laneX = self.scene.size.width * CGFloat(lane) / 4.0

                let laneWidth = ((self.scene.size.width)) / 3
                let width = laneWidth
                
                
                let endPoint = CGPoint(x: laneX, y: endY ?? self.endHeight)
                let moveAction = SKAction.move(
                    to: endPoint,
                    duration: self.obstacleMoveTime
                )
                actions.append(moveAction)
                
                
                let randomObstacleTypeNumber: Int = Int.random(in: (self.scene.score > 100) ? 1...100 : 6...100)
                
                if randomObstacleTypeNumber <= 5 {
                    obstacle = PowerUp(width: width)
                    actions.append(SKAction.fadeOut(withDuration: 0.3))
                    actions.append(SKAction.removeFromParent())
                } else if randomObstacleTypeNumber < 30 {
                    obstacle = Customer(width: width)
                    obstacle.onDie = {
                        self.scene.run(SKAction.sequence([
                            
                            SKAction.wait(forDuration: 0.2),
                            SKAction.run {
                                self.scene.gameManager.gameOver()
                            }
                        ]))
                    }
                    actions.append(SKAction.fadeOut(withDuration: 0.3))
                    actions.append(SKAction.removeFromParent())
                } else {
                    obstacle = Thief(width: width)
                    obstacle.onDie = {
                        self.scene.score += 5
                    }
                    
                    let gameOverAction = SKAction.customAction(withDuration: 0.0, actionBlock: { _, _ in
                        self.scene.player.transition(to: .fail)
                        self.scene.gameManager.gameOver()
                       
                    })
                    
                    actions.append((obstacle as! Thief).attackAction)
                    actions.append(gameOverAction)
                }
                
                obstacle.anchorPoint = CGPoint(x: 0.5, y: 0)
                obstacle.name = "obstacle"
                obstacle.zPosition = ZPosition.obstacle.rawValue
                obstacle.position = CGPoint(x: laneX, y: -obstacle.size.height)
                
                let sequenceAction = SKAction.sequence(actions)

                obstacle.run(sequenceAction)

                self.scene.addChild(obstacle)
            }
        )

    }
    
}
