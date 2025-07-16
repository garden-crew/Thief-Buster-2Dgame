//  GameScene.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
import SpriteKit

class GameScene: SKScene {

    var player: Guard!
    var background: SKSpriteNode!

    lazy var spawnManager: SpawnManager = SpawnManager(scene: self)

    var helper: Cobacoba?

    let redLine = SKSpriteNode(
        color: .red,
        size: CGSize(width: 500, height: 70)
    )

    var attackButtonLeft: SKSpriteNode!
    var attackButtonCenter: SKSpriteNode!
    var attackButtonRight: SKSpriteNode!

    let targetLeft = SKShapeNode(
        rectOf: CGSize(width: 50, height: 70),
        cornerRadius: 30
    )
    let targetMid = SKShapeNode(
        rectOf: CGSize(width: 50, height: 70),
        cornerRadius: 30
    )
    let targetRight = SKShapeNode(
        rectOf: CGSize(width: 50, height: 70),
        cornerRadius: 30
    )

    override func didMove(to view: SKView) {
        setUpBackground()
        setupGuard()
        setupAttackButtons()

        spawnManager.generate()

        helper = Cobacoba(gamescene: self)

        redLine.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        redLine.zPosition = 2
        addChild(redLine)

        func styleTarget(_ target: SKShapeNode) {
            target.fillColor = .blue
            target.strokeColor = .white
            target.lineWidth = 4
            target.zPosition = -1
        }

        styleTarget(targetLeft)
        styleTarget(targetMid)
        styleTarget(targetRight)

        targetLeft.position = CGPoint(
            x: attackButtonLeft.position.x,
            y: redLine.position.y
        )
        targetMid.position = CGPoint(
            x: attackButtonCenter.position.x,
            y: redLine.position.y
        )
        targetRight.position = CGPoint(
            x: attackButtonRight.position.x,
            y: redLine.position.y
        )
        addChild(targetLeft)
        addChild(targetMid)
        addChild(targetRight)
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
        player = Guard()
        player.setScale(0.2)
        player.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        addChild(player)
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
        attackButtonLeft.zPosition = 100
        addChild(attackButtonLeft)

        // Tengah
        attackButtonCenter = SKSpriteNode(imageNamed: "attack center")
        attackButtonCenter.name = "attackCenter"
        attackButtonCenter.size = buttonSize
        attackButtonCenter.position = CGPoint(
            x: startX + buttonSize.width + spacing,
            y: 80
        )
        attackButtonCenter.zPosition = 100
        addChild(attackButtonCenter)

        // Kanan
        attackButtonRight = SKSpriteNode(imageNamed: "attack right")
        attackButtonRight.name = "attackRight"
        attackButtonRight.size = buttonSize
        attackButtonRight.position = CGPoint(
            x: startX + (buttonSize.width + spacing) * 2,
            y: 80
        )
        attackButtonRight.zPosition = 100
        addChild(attackButtonRight)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        helper?.handleTouches(touches, with: event)

        touches.forEach { touch in
            let location = touch.location(in: self)
            let node = atPoint(location)

            switch node.name {
            case "attackLeft":
                player.transition(to: .attack)
                print("Attack left tapped")
            // Tambahkan logika attack ke lane kiri
            case "attackCenter":
                player.transition(to: .attack)

                print("Attack center tapped")
            // Tambahkan logika attack ke lane tengah
            case "attackRight":
                player.transition(to: .attack)

                print("Attack right tapped")
            // Tambahkan logika attack ke lane kanan
            default:
                break
            }
        }
    }
}
