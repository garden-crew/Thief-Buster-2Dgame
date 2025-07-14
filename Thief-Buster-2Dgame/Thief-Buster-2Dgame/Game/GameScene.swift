//
//  GameScene.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
import SpriteKit

class GameScene: SKScene {
    
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
