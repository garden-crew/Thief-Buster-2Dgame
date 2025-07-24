//  GameScene.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//

import AVFoundation
import GameplayKit
import SpriteKit
import SwiftData
import SwiftUI

// Main game scene handling all rendering and gameplay updates.
class GameScene: SKScene {
    
    var modelContext: ModelContext?
    var highscoreLabel: SKLabelNode!
    var highscore: Int = 0
    
    var muteMusic: Bool = false

    var pauseButton: SKSpriteNode!
    var gamePaused: Bool = false
    
    var backgroundNode : BackgroundNode!
    var isGameOver = false
    var isOverlayShown = false

    var player: Guard!
    
    let cameraNode = SKCameraNode()

    // Manages spawning of obstacles (thieves, customers, power-ups).
    lazy var spawnManager: SpawnManager = SpawnManager(scene: self)
    lazy var gameManager: GameManager = GameManager(scene: self)

    // Handles collision detection between player and obstacles.
    var helper: CollisionManager?

    // Visual marker for collision zone.
    var redLine : SKSpriteNode = SKSpriteNode(
        color: .red,
        size: CGSize(width: 0 , height: 0)
    )
    
    var gameViewMaxY: CGFloat = 1000
    
    var gameViewMinY : CGFloat {
        return gameViewMaxY - viewSize.height
    }
    
    var gameViewCenterY : CGFloat {
        return (gameViewMaxY + gameViewMinY) / 2
    }

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

    var obstacleEndY: CGFloat {
        backgroundNode.bankImageBottomY
    }
    
    var viewSize = CGSize.zero
    
    init(viewSize: CGSize, canvasSize: CGSize) {
        self.viewSize = viewSize
        super.init(size: canvasSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    func hideOverlay() {
        self.childNode(withName: "gameOverlay")?.removeFromParent()
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
        
        gameViewMaxY = player.position.y + (player.size.height * 2)
        
        setupAttackButtons()
        
        setupRedLine()
        setupTargets()
        setupScoreLabel()
        setupHighscoreLabel()
        setupPauseButton()

        helper = CollisionManager(gamescene: self)

        self.camera = cameraNode
        cameraNode.position = CGPoint(
            x: size.width / 2,
            y: size.height - viewSize.height/2
        )
        addChild(cameraNode)
        
        
//        let topLine = SKShapeNode(rect: CGRect(x: 0, y: gameViewMaxY, width: size.width, height: 4))
//        topLine.fillColor = .red
//        addChild(topLine)
//        
//        let bottomLine = SKShapeNode(rect: CGRect(x: 0, y: gameViewMinY, width: size.width, height: 4))
//        bottomLine.fillColor = .red
//        addChild(bottomLine)

        gameManager.startView()
        
        let moveDown = SKAction.moveTo(y: gameViewCenterY, duration: 1)
        moveDown.timingMode = .easeOut

        cameraNode.run(moveDown)

    }

    // Button for pause the game
    func setupPauseButton() {
        pauseButton = SKSpriteNode(imageNamed: "PauseButton")
        pauseButton.anchorPoint = CGPoint(x: 0, y: 1.5)
        pauseButton.name = "pauseButton"
        pauseButton.size = CGSize(width: 60, height: 60)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        pauseButton.position = CGPoint(x: size.width - 24 - pauseButton.size.width, y: gameViewMaxY - 40)
        pauseButton.zPosition = ZPosition.inGameUI.rawValue
        addChild(pauseButton)
    }

    // Show the score
    func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .clear
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: 24, y: gameViewMaxY - 16 - 4 - 64)
        scoreLabel.zPosition = ZPosition.inGameUI.rawValue
        addChild(scoreLabel)
    }

    // Show the high score
    func setupHighscoreLabel() {
        highscoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        highscoreLabel.fontSize = 14
        highscoreLabel.fontColor = .clear
        highscoreLabel.text = "Highscore: \(highscore)"
        highscoreLabel.horizontalAlignmentMode = .left
        highscoreLabel.verticalAlignmentMode = .top
        highscoreLabel.position = CGPoint(x: 24, y: gameViewMaxY - 16 - 24 - 8 - 64)
        highscoreLabel.zPosition = ZPosition.inGameUI.rawValue
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
        backgroundNode = BackgroundNode(sceneSize: self.size)
        addChild(backgroundNode)
    }

    func setupGuard() {
        player = Guard()
        player.anchorPoint = CGPoint(x: 0.5, y: 0)
        player.setScale(2.0)
        player.position = CGPoint(x: size.width / 2, y: backgroundNode.bankImageBottomY + 12)
        player.zPosition = ZPosition.player.rawValue
        addChild(player)
    }

    func setupAttackButtons() {
  
        // Ukuran dan jarak antar tombol
        let buttonSize = CGSize(width: 80, height: 80)
        let spacing: CGFloat = 40
        let totalWidth = (buttonSize.width * 3) + (spacing * 2)
        let startX = (size.width - totalWidth) / 2 + buttonSize.width / 2
        let buttonY : CGFloat = gameViewMinY + 80

        // Kiri
        attackButtonLeft = SKSpriteNode(imageNamed: "FootAttack")
        attackButtonLeft.name = "attackLeft"
        attackButtonLeft.size = buttonSize
        attackButtonLeft.position = CGPoint(x: startX, y: buttonY)
        attackButtonLeft.zPosition = ZPosition.inGameUI.rawValue
        addChild(attackButtonLeft)

        // Tengah
        attackButtonCenter = SKSpriteNode(imageNamed: "HandAttack")
        attackButtonCenter.name = "attackCenter"
        attackButtonCenter.size = buttonSize
        attackButtonCenter.position = CGPoint(
            x: startX + buttonSize.width + spacing,
            y: buttonY
        )
        attackButtonCenter.zPosition = ZPosition.inGameUI.rawValue
        addChild(attackButtonCenter)

        // Kanan
        attackButtonRight = SKSpriteNode(imageNamed: "HandAttack")
        attackButtonRight.name = "attackRight"
        attackButtonRight.size = buttonSize
        attackButtonRight.position = CGPoint(
            x: startX + (buttonSize.width + spacing) * 2,
            y: buttonY
        )
        attackButtonRight.zPosition = ZPosition.inGameUI.rawValue
        addChild(attackButtonRight)
    }

    func setupRedLine() {
        redLine = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: backgroundNode.tileSize.width * 2))
        redLine.anchorPoint = CGPoint(x: 0, y: 1)
        redLine.position = CGPoint(x: 0, y: backgroundNode.bankImageBottomY)
        redLine.zPosition = ZPosition.obstacle.rawValue
        addChild(redLine)
    }

    func styleTarget(_ target: SKShapeNode) {
        target.fillColor = .blue
        target.strokeColor = .white
        target.lineWidth = 4
        target.zPosition = -10
    }

    func setupTargets() {
        [targetLeft, targetMid, targetRight].forEach { styleTarget($0) }
        
        let y = backgroundNode.bankImageBottomY

        targetLeft.position = CGPoint(
            x: attackButtonLeft.position.x,
            y: y
        )
        targetMid.position = CGPoint(
            x: attackButtonCenter.position.x,
            y: y
        )
        targetRight.position = CGPoint(
            x: attackButtonRight.position.x,
            y: y
        )

        addChild(targetLeft)
        addChild(targetMid)
        addChild(targetRight)
    }
    
    func resumeGame(){
        isPaused = false
        attackButtonLeft.isUserInteractionEnabled = false
        attackButtonCenter.isUserInteractionEnabled = false
        attackButtonRight.isUserInteractionEnabled = false
        pauseButton.isUserInteractionEnabled = false
        hidePauseOverlay()
        spawnManager.generate(targetY: obstacleEndY)
    }

    func togglePause() {
        gamePaused.toggle()
        isPaused = gamePaused
    }
    
    // Restart the game
    func restartGame() {
        SoundManager.shared.playBackgroundMusic()
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
        isGameOver = false
        isOverlayShown = false
        
        // Re-spawn
        spawnManager.generate(targetY: obstacleEndY)
        
        // Hapus overlay
        hideGameOverlay()
        hidePauseOverlay()
        
        // Muat ulang highscore & update label
        loadHighscore()
        highscoreLabel.text = "Highscore: \(highscore)"
        
        // Reset score
        score = 0
        
        print("Game restarted")
    }

    
    func hideGameOverlay() {
        self.childNode(withName: "gameOverlay")?.removeFromParent()
    }
    
    func hidePauseOverlay() {
        self.childNode(withName: "pauseOverlay")?.removeFromParent()
    }
    func toggleBackroundMusic(){
        muteMusic.toggle()

        if muteMusic {
            SoundManager.shared.stopBackgroundMusic()
            // cari node bernama "musicButton" lalu ubah texture
            if let button = self.childNode(withName: "//musicButton") as? SKSpriteNode {
                button.texture = SKTexture(imageNamed: "NoMusicButton")
            }
        } else {
            SoundManager.shared.playBackgroundMusic()
            if let button = self.childNode(withName: "//musicButton") as? SKSpriteNode {
                button.texture = SKTexture(imageNamed: "MusicButton")
            }
        }
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        helper?.handleTouches(touches, with: event)
        
        touches.forEach { touch in
            let location = touch.location(in: self)
            let node = atPoint(location)

            switch node.name {
            // Serangan hanya bisa dilakukan jika belum game over dan overlay tidak ditampilkan
            case "attackLeft":
                gameManager.animateButtonTap(
                    nodeName: "attackLeft",
                    tappedTexture: "FootAttackTap",
                    normalTexture: "FootAttack"
                )
                guard !isGameOver && !isOverlayShown else { return }
                player.transition(to: .attackLeft)
                print("\(node.name ?? "") tapped")
            
            case "attackCenter":
                gameManager.animateButtonTap(
                    nodeName: "attackCenter",
                    tappedTexture: "HandAttackTap",
                    normalTexture: "HandAttack"
                )
                guard !isGameOver && !isOverlayShown else { return }
                player.transition(to: .attackCenter)
                print("\(node.name ?? "") tapped")
                
            case "attackRight":
                gameManager.animateButtonTap(
                    nodeName: "attackRight",
                    tappedTexture: "HandAttackTap",
                    normalTexture: "HandAttack"
                )
                guard !isGameOver && !isOverlayShown else { return }
                player.transition(to: .attackRight)
                print("\(node.name ?? "") tapped")
                
            case "restartButton":
                gameManager.animateButtonTap(
                    nodeName: "restartButton",
                    tappedTexture: "RestartButtonTap",
                    normalTexture: "RestartButton"
                )
                restartGame()

            case "menuButton":
                gameManager.animateButtonTap(
                    nodeName: "menuButton",
                    tappedTexture: "MenuButtonTap",
                    normalTexture: "MenuButton"
                )
                gameManager.startView()

            case "pauseButton":
                gameManager.pauseView()
                isOverlayShown = true
                
            case "resumeButton":
                gameManager.animateButtonTap(
                    nodeName: "resumeButton",
                    tappedTexture: "ResumeButtonTap",
                    normalTexture: "ResumeButton"
                )
                resumeGame()
                isOverlayShown = false
                
            case "startButton":
                gameManager.animateButtonTap(
                    nodeName: "startButton",
                    tappedTexture: "StartButtonTap",
                    normalTexture: "StartButton"
                )
                gameManager.animateStartAndRemoveOverlay()
                print("Start tapped")

            case "quitButton":
                gameManager.animateButtonTap(
                    nodeName: "quitButton",
                    tappedTexture: "QuitButtonTap",
                    normalTexture: "QuitButton"
                )
                gameManager.startView()
                isOverlayShown = true
                hidePauseOverlay()
                
            case "musicButton":
                toggleBackroundMusic()

            default:
                break
            }
        }
    }
}
