//  GameScene.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//

import AVFoundation
import GameplayKit
import SpriteKit
import SwiftData

// Main game scene handling all rendering and gameplay updates.
class GameScene: SKScene {
    
    // Setting up SwiftData for Highscore
    var modelContext: ModelContext?
    var highscoreLabel: SKLabelNode!
    var highscore: Int = 0
    
    var pauseButton: SKSpriteNode!
    var gamePaused: Bool = false

    var player: Guard!
    var background: SKSpriteNode!

    // Manages spawning of obstacles (thieves, customers, power-ups).
    lazy var spawnManager: SpawnManager = SpawnManager(scene: self)
    
    lazy var gameManager: GameManager = GameManager(scene: self)

    // Handles collision detection between player and obstacles.
    var helper: CollisionManager?

    // Visual marker for collision zone.
    let redLine = SKSpriteNode(
        color: .red,
        size: CGSize(width: 500, height: 100)
    )

    // Button to attack
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

    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
            saveHigshcore(score)
        }
    }
    
    var obstacleEndY : CGFloat {
        self.size.height * 0.7
    }

    // Store high score
    func saveHigshcore(_ score: Int) {
        guard let modelContext = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<Highscore>()
            let highscores = try modelContext.fetch(descriptor)
            
            if let existing = highscores.first {
                if score > existing.value {
                    existing.value = score
                    try modelContext.save()
                    print("Updated highscore to \(score)")
                }
            } else {
                let newHighscore = Highscore(value: score)
                modelContext.insert(newHighscore)
                try modelContext.save()
                print("Created new highscore: \(score)")
            }
        } catch {
            print("Failed to save highscore: \(error)")
        }
    }
    
    // Restart the game
    func restartGame() {
        // Reset score
        score = 0
        
        // Reset highscore label (optional)
        highscoreLabel.text = "Highscore: \(highscore)"
        
        // Delete all obstacles from scene
        self.children.forEach { node in
            if node.name == "obstacle" {
                node.removeFromParent()
            }
        }
        
        // Unpause scene
        isPaused = false
        
        
        // Re-spawn
        spawnManager.generate(targetY: obstacleEndY)
        
        // Delete the overlay
        hideGameOverView()
        
        print("Game restarted")
    }
    
    func hideGameOverView() {
        self.childNode(withName: "gameOverOverlay")?.removeFromParent()
    }

    func goToStartView() {
//        if let view = self.view {
//            let startScene = StartView(size: view.bounds.size)
//            view.presentScene(startScene, transition: SKTransition.fade(withDuration: 0.5))
//            print("Go to start view")
//        }
    }
    
    override func didMove(to view: SKView) {
        SoundManager.shared.playBackgroundMusic()

        loadHighscore()
        setUpBackground()
        setupGuard()
        setupAttackButtons()
        setupRedLine()
        setupTargets()
        setupScoreLabel()
        setupHighscoreLabel()
        setupPauseButton()

        spawnManager.generate(targetY: obstacleEndY)
        helper = CollisionManager(gamescene: self)
    }
    
    // Button for pause the game
    func setupPauseButton() {
        pauseButton = SKSpriteNode(imageNamed: "attack left")
        pauseButton.name = "pauseButton"
        pauseButton.size = CGSize(width: 40, height: 40)
        pauseButton.position = CGPoint(x: size.width - 40, y: size.height - 100)
        pauseButton.zPosition = 100
        addChild(pauseButton)
    }
    
    // Show the score
    func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = .black
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: size.width - 30, y: size.height - 40)
        scoreLabel.zPosition = 100
        addChild(scoreLabel)
    }
    
    // Show the high score
    func setupHighscoreLabel() {
        highscoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        highscoreLabel.fontSize = 36
        highscoreLabel.fontColor = .black
        highscoreLabel.text = "Highscore: \(highscore)"
        highscoreLabel.horizontalAlignmentMode = .left
        highscoreLabel.verticalAlignmentMode = .top
        highscoreLabel.position = CGPoint(x: 30, y: size.height - 40)
        highscoreLabel.zPosition = 100
        addChild(highscoreLabel)
    }
    
    // Show new high score
    func loadHighscore() {
        guard let modelContext = modelContext else { return }
        do {
            let descriptor = FetchDescriptor<Highscore>()
            let highscores = try modelContext.fetch(descriptor)
            if let existing = highscores.first {
                highscore = existing.value
            } else {
                let newHighscore = Highscore(value: 0)
                modelContext.insert(newHighscore)
                try modelContext.save()
                highscore = 0
            }
        } catch {
            print("Failed to load highscore: \(error)")
        }
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
        player.setScale(2.0)
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

    func setupRedLine() {
        redLine.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        redLine.zPosition = 2
        addChild(redLine)
    }

    func styleTarget(_ target: SKShapeNode) {
        target.fillColor = .blue
        target.strokeColor = .white
        target.lineWidth = 4
        target.zPosition = -1
    }

    func setupTargets() {
        [targetLeft, targetMid, targetRight].forEach { styleTarget($0) }

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
    
    func togglePause() {
        gamePaused.toggle()
        isPaused = gamePaused
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
//        if gamePaused { return }
        
        helper?.handleTouches(touches, with: event)

        touches.forEach { touch in
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            switch node.name {
            case "attackLeft":
                player.transition(to: .attack)
                print("Attack left tapped")
            case "attackCenter":
                player.transition(to: .attack)
                print("Attack center tapped")
            case "attackRight":
                player.transition(to: .attack)
                print("Attack right tapped")
            case "restartButton":
                print("Restart tapped")
//                gameManager.hideGameOverView()
                restartGame()
            case "menuButton":
                print("Menu tapped")
//                gameManager.hideGameOverView()
                goToStartView()
            case "pauseButton":
                print("Pause tapped")
                togglePause()
            default:
                break
            }
        }
    }
}
