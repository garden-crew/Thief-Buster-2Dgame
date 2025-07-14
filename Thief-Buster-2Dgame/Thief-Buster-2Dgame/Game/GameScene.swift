//
//  GameScene.swift
//  Trying BishiBashi
//
//  Created by Edward Suwandi on 10/07/25.
//
import SpriteKit
import SwiftUICore

class GameScene: SKScene {
    
    var helper: Cobacoba?   // Declare helper, instantiate later
    
    let player = SKSpriteNode(imageNamed: "1") // Pakai SF Symbol "leaf" sebagai placeholder
    let enemy = SKSpriteNode(imageNamed: "15")
    
    let redLine = SKSpriteNode(color: .red, size: CGSize(width: 500, height: 50))
    
    let buttonLeft = SKShapeNode(rectOf: CGSize(width: 70, height: 70), cornerRadius: 30)
    let buttonMid = SKShapeNode(rectOf: CGSize(width: 70, height: 70), cornerRadius: 30)
    let buttonRight = SKShapeNode(rectOf: CGSize(width: 70, height: 70), cornerRadius: 30)
    
    let targetLeft = SKShapeNode(rectOf: CGSize(width: 50, height: 50), cornerRadius: 30)
    let targetMid = SKShapeNode(rectOf: CGSize(width: 50, height: 50), cornerRadius: 30)
    let targetRight = SKShapeNode(rectOf: CGSize(width: 50, height: 50), cornerRadius: 30)
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        // Instantiate helper here, now self is ready
        helper = Cobacoba(gamescene: self)
        
        // Atur ukuran dan posisi
        player.size = CGSize(width: 130, height: 130)
        player.position = CGPoint(x: size.width / 2, y: size.height - player.size.height / 2 - 20)
        addChild(player)

        enemy.size = CGSize(width: 130, height: 130)
        enemy.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(enemy)
        
        let targetPosition = CGPoint(
            x: player.position.x,
            y: player.position.y - 50
        )
        
        let moveUp = SKAction.move(to: targetPosition, duration: 3.0)
        enemy.run(moveUp)
        
        redLine.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
        redLine.zPosition = -1
        addChild(redLine)
        
        // Common button style
        func styleButton(_ button: SKShapeNode) {
            button.fillColor = .blue
            button.strokeColor = .white
            button.lineWidth = 4
            button.zPosition = 1
        }
        
        func styleTarget(_ target: SKShapeNode){
            target.fillColor = .blue
            target.strokeColor = .white
            target.lineWidth = 4
            target.zPosition = -1
        }

        styleButton(buttonLeft)
        styleButton(buttonMid)
        styleButton(buttonRight)

        // Position: left, center, right at bottom
        let buttonY = buttonLeft.frame.height/2 + 40
        buttonLeft.position = CGPoint(x: size.width/2 - 100, y: buttonY)
        buttonMid.position = CGPoint(x: size.width/2, y: buttonY)
        buttonRight.position = CGPoint(x: size.width/2 + 100, y: buttonY)

        addChild(buttonLeft)
        addChild(buttonMid)
        addChild(buttonRight)
        
        styleTarget(targetLeft)
        styleTarget(targetMid)
        styleTarget(targetRight)
        
        targetLeft.position = CGPoint(x: buttonLeft.position.x, y: redLine.position.y)
        targetMid.position = CGPoint(x: buttonMid.position.x, y: redLine.position.y)
        targetRight.position = CGPoint(x: buttonRight.position.x, y: redLine.position.y)
        addChild(targetLeft)
        addChild(targetMid)
        addChild(targetRight)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        helper?.handleTouches(touches, with: event)
    }
}

