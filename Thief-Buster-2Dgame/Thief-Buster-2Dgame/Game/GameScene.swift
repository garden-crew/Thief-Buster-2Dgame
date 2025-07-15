//
//  GameScene.swift
//  Trying BishiBashi
//
//  Created by Edward Suwandi on 10/07/25.
//

import SpriteKit
import SwiftUICore

class GameScene: SKScene {
    
    lazy var spawnManager : SpawnManager = SpawnManager(scene: self)
    
    var helper: Cobacoba?   // Declare helper, instantiate later
    
    let player = SKSpriteNode(imageNamed: "1") // Pakai SF Symbol "leaf" sebagai placeholder
    
    let redLine = SKSpriteNode(color: .red, size: CGSize(width: 500, height: 70))
    
    let buttonLeft = SKShapeNode(rectOf: CGSize(width: 70, height: 70), cornerRadius: 30)
    let buttonMid = SKShapeNode(rectOf: CGSize(width: 70, height: 70), cornerRadius: 30)
    let buttonRight = SKShapeNode(rectOf: CGSize(width: 70, height: 70), cornerRadius: 30)
    
    let targetLeft = SKShapeNode(rectOf: CGSize(width: 50, height: 70), cornerRadius: 30)
    let targetMid = SKShapeNode(rectOf: CGSize(width: 50, height: 70), cornerRadius: 30)
    let targetRight = SKShapeNode(rectOf: CGSize(width: 50, height: 70), cornerRadius: 30)
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        spawnManager.generate()
        
        // Instantiate helper here, now self is ready
        helper = Cobacoba(gamescene: self)
        
        // Atur ukuran dan posisi
        player.size = CGSize(width: 130, height: 130)
        player.position = CGPoint(x: size.width / 2, y: size.height - player.size.height / 2 - 20)
        addChild(player)

        let targetPosition = CGPoint(
            x: player.position.x,
            y: player.position.y - 50
        )
        
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

//
//  GameScene.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
import SpriteKit

class GameScene2: SKScene {
    
    var guardNode: Guard!
    var background: SKSpriteNode!
    
    var attackButtonLeft: SKSpriteNode!
    var attackButtonCenter: SKSpriteNode!
    var attackButtonRight: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        setUpBackground()
        setupGuard()
        setupAttackButtons()
    }
    
    func setUpBackground() {
        background = SKSpriteNode(imageNamed: "25")
        background.size = self.size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = 0
        let scaleX = size.width / background.size.width
        let scaleY = size.height / background.size.height
        let scale = max(scaleX, scaleY)
        background.setScale(scale)
        
        addChild(background)
    }
    
    func setupGuard() {
        guardNode = Guard()
        guardNode.setScale(0.4)
        guardNode.position = CGPoint(x: 200, y: 600)
        addChild(guardNode)
    }
    
    func setupAttackButtons() {
        // Ukuran dan jarak antar tombol
        let buttonSize = CGSize(width: 80, height: 80)
        let spacing: CGFloat = 40
        let totalWidth = (buttonSize.width * 3) + (spacing * 2)
        let startX = (size.width - totalWidth) / 2 + buttonSize.width / 2
        
        // Kiri
        attackButtonLeft = SKSpriteNode(imageNamed: "attack left")
        attackButtonLeft.name = "attackLeft"
        attackButtonLeft.size = buttonSize
        attackButtonLeft.position = CGPoint(x: startX, y: 80)
        addChild(attackButtonLeft)
        
        // Tengah
        attackButtonCenter = SKSpriteNode(imageNamed: "attack center")
        attackButtonCenter.name = "attackCenter"
        attackButtonCenter.size = buttonSize
        attackButtonCenter.position = CGPoint(x: startX + buttonSize.width + spacing, y: 80)
        addChild(attackButtonCenter)
        
        // Kanan
        attackButtonRight = SKSpriteNode(imageNamed: "attack right")
        attackButtonRight.name = "attackRight"
        attackButtonRight.size = buttonSize
        attackButtonRight.position = CGPoint(x: startX + (buttonSize.width + spacing) * 2, y: 80)
        addChild(attackButtonRight)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        
        switch node.name {
        case "attackLeft":
            print("Attack left tapped")
            guardNode.transition(to: .attack)
            // Tambahkan logika attack ke lane kiri
        case "attackCenter":
            print("Attack center tapped")
            guardNode.transition(to: .attack)
            // Tambahkan logika attack ke lane tengah
        case "attackRight":
            print("Attack right tapped")
            guardNode.transition(to: .attack)
            // Tambahkan logika attack ke lane kanan
        default:
            break
        }
    }

}
