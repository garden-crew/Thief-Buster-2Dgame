//  GameScene.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//

import SpriteKit
import SwiftData
import SwiftUI

// Main game scene handling all rendering and gameplay updates.
class GameScene: SKScene {

    var modelContext: ModelContext?
    var highscoreLabel: SKLabelNode!
    var highscore: Int = 0

    var isInGame = false

    var muteMusic: Bool = false

    var musicButton: SKSpriteNode!

    var pauseButton: SKSpriteNode!
    var gamePaused: Bool = false

    var backgroundNode: BackgroundNode!
    var borderScore: SKSpriteNode!
    var isGameOver = false
    var isOverlayShown = false

    var player: Guard!

    let cameraNode = SKCameraNode()

    // Manages spawning of obstacles (thieves, customers, power-ups).
    lazy var spawnManager: SpawnManager = SpawnManager(scene: self)
    lazy var gameManager: GameManager = GameManager(scene: self)

    // Handles collision detection between player and obstacles.
    var helper: CollisionManager?

    var gameViewMaxY: CGFloat = 1000

    var gameViewMinY: CGFloat {
        return gameViewMaxY - viewSize.height
    }

    var gameViewCenterY: CGFloat {
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

    override func didMove(to view: SKView) {
        loadHighscore()
        setUpBackground()
        setupGuard()
        setupBorderScore()

        gameViewMaxY = player.position.y + (player.size.height * 2)

        setupAttackButtons()

        setupTargets()
        setupScoreLabel()
        setupHighscoreLabel()
        setupPauseButton()
        setupMusicButton()

        helper = CollisionManager(gamescene: self)

        self.camera = cameraNode
        cameraNode.position = CGPoint(
            x: size.width / 2,
            y: size.height - viewSize.height / 2
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
    }

    // Button for pause the game
    func setupPauseButton() {
        pauseButton = SKSpriteNode(imageNamed: "PauseButton")
        pauseButton.anchorPoint = CGPoint(x: 0, y: 1.5)
        pauseButton.name = "pauseButton"
        pauseButton.size = CGSize(width: 60, height: 60)
        pauseButton.position = CGPoint(
            x: size.width - 24 - pauseButton.size.width,
            y: gameViewMaxY - 40
        )
        pauseButton.zPosition = ZPosition.inGameUI.rawValue
        addChild(pauseButton)
    }

    func setupMusicButton() {
        musicButton = SKSpriteNode(imageNamed: "MusicButton")
        musicButton.anchorPoint = CGPoint(x: 0, y: 1.5)
        musicButton.name = "musicButton"
        musicButton.size = CGSize(width: 60, height: 60)
        musicButton.position = CGPoint(
            x: size.width - 24 - musicButton.size.width,
            y: gameViewMaxY - 120
        )
        musicButton.zPosition = ZPosition.inGameUI.rawValue
        addChild(musicButton)
    }

    // Show the score
    func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Pixellari")
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .clear
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        let paddingTop: CGFloat = 85
        scoreLabel.position = CGPoint(x: 8, y: gameViewMaxY - paddingTop)
        scoreLabel.zPosition = ZPosition.inGameUI.rawValue
        addChild(scoreLabel)
    }

    // Show the high score
    func setupHighscoreLabel() {
        highscoreLabel = SKLabelNode(fontNamed: "Pixellari")
        highscoreLabel.fontSize = 16
        highscoreLabel.fontColor = .clear
        highscoreLabel.text = "Highscore: \(highscore)"
        highscoreLabel.horizontalAlignmentMode = .left
        highscoreLabel.verticalAlignmentMode = .top
        let paddingTop: CGFloat = 115
        highscoreLabel.position = CGPoint(x: 8, y: gameViewMaxY - paddingTop)
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

    func setupBorderScore() {
        borderScore = SKSpriteNode(imageNamed: "BorderScore")
        borderScore.anchorPoint = CGPoint(x: 0, y: 0.5)
        borderScore.size = CGSize(width: 170, height: 70)

        let paddingTop: CGFloat = 170
        let yPosition = gameViewMaxY - paddingTop
        borderScore.position = CGPoint(x: 0, y: yPosition)
        borderScore.zPosition = ZPosition.inGameUI.rawValue - 1
        borderScore.alpha = 0
        addChild(borderScore)
    }

    func setUpBackground() {
        backgroundNode = BackgroundNode(sceneSize: self.size)
        addChild(backgroundNode)
    }

    func setupGuard() {
        player = Guard()
        player.anchorPoint = CGPoint(x: 0.5, y: 0)
        player.position = CGPoint(
            x: size.width / 2,
            y: backgroundNode.bankImageBottomY + 12
        )
        player.zPosition = ZPosition.player.rawValue

        let width = size.width / 2.5
        let aspectRatio: CGFloat = player.size.width / player.size.height
        let height = width / aspectRatio

        player.size = CGSize(width: width, height: height)

        addChild(player)
    }

    func setupAttackButtons() {

        let space: CGFloat = size.width / 4
        let gap: CGFloat = 16

        let buttonDeck = SKSpriteNode(imageNamed: "BottomDeck")

        let deckWidth: CGFloat = size.width
        let aspectRatio = buttonDeck.size.width / buttonDeck.size.height

        let deckheight: CGFloat = deckWidth / aspectRatio

        buttonDeck.size = CGSize(width: size.width, height: deckheight + 40)
        buttonDeck.anchorPoint = CGPoint(x: 0.5, y: 0)
        buttonDeck.position = CGPoint(x: size.width / 2, y: gameViewMinY)
        buttonDeck.zPosition = ZPosition.inGameUI.rawValue
        addChild(buttonDeck)

        // Ukuran dan jarak antar tombol
        let buttonSize = CGSize(width: 100, height: 100)
        let buttonY: CGFloat = gameViewMinY + 110

        // Kiri
        attackButtonLeft = SKSpriteNode(imageNamed: "FootAttack")
        attackButtonLeft.name = "attackLeft"
        attackButtonLeft.size = buttonSize
        attackButtonLeft.position = CGPoint(x: space - gap, y: buttonY)
        attackButtonLeft.zPosition = ZPosition.inGameUI.rawValue
        addChild(attackButtonLeft)

        // Tengah
        attackButtonCenter = SKSpriteNode(imageNamed: "HandAttack")
        attackButtonCenter.name = "attackCenter"
        attackButtonCenter.size = buttonSize
        attackButtonCenter.position = CGPoint(
            x: space * 2,
            y: buttonY
        )
        attackButtonCenter.zPosition = ZPosition.inGameUI.rawValue
        addChild(attackButtonCenter)

        // Kanan
        attackButtonRight = SKSpriteNode(imageNamed: "HandAttack")
        attackButtonRight.name = "attackRight"
        attackButtonRight.size = buttonSize
        attackButtonRight.position = CGPoint(
            x: space * 3 + gap,
            y: buttonY
        )
        attackButtonRight.zPosition = ZPosition.inGameUI.rawValue
        addChild(attackButtonRight)
    }

    func setupHighlight() {
        
        func fadeInOutAnimation(duration: TimeInterval = 2.0) -> SKAction {
            let fadeOut = SKAction.fadeAlpha(to: 0.2, duration: duration / 2)
            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: duration / 2)
            let fade = SKAction.sequence([fadeOut, fadeIn])
            let fadeLoop = SKAction.repeat(fade, count: 4)
            let sequenceAction = SKAction.sequence([
                fadeLoop, SKAction.fadeOut(withDuration: 0.3),
                .removeFromParent(),
            ])
            return sequenceAction
        }

        let hitBoxHighlight = SKSpriteNode(
            color: .white.withAlphaComponent(0.4),
            size: CGSize(
                width: size.width,
                height: backgroundNode.tileSize.width
            )
        )

        hitBoxHighlight.anchorPoint = CGPoint(x: 0, y: 1)
        hitBoxHighlight.position = CGPoint(
            x: 0,
            y: backgroundNode.bankImageBottomY
        )
        hitBoxHighlight.zPosition = ZPosition.obstacle.rawValue
        addChild(hitBoxHighlight)

        hitBoxHighlight.run(fadeInOutAnimation())

        let attackButtons = [
            attackButtonLeft, attackButtonCenter, attackButtonRight,
        ]

        attackButtons.forEach { button in
            let buttonHighlight = SKSpriteNode(
                color: .white.withAlphaComponent(0.4),
                size: button!.size
            )
            buttonHighlight.setScale(1.1)
            buttonHighlight.zPosition = ZPosition.inGameUI.rawValue
            buttonHighlight.position = button!.position

            addChild(buttonHighlight)
            buttonHighlight.run(fadeInOutAnimation())
        }

        let laneWidth: Double = size.width / 4

        (1...3).forEach { i in
            let position = CGPoint(
                x: laneWidth * Double(i),
                y: backgroundNode.stairBottomY
            )

            let laneHighlight = SKSpriteNode(
                color: .white.withAlphaComponent(0.4),
                size: CGSize(
                    width: laneWidth - 8,
                    height: backgroundNode.stairBottomY
                )
            )

            laneHighlight.anchorPoint = CGPoint(x: 0.5, y: 1)
            laneHighlight.position = position
            addChild(laneHighlight)
            laneHighlight.run(fadeInOutAnimation())

        }

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

    func resumeGame() {
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

        if self.muteMusic == false {
            self.playMusicAccordingToScene()
        }
    }

    func hideGameOverlay() {
        self.childNode(withName: "gameOverlay")?.removeFromParent()
    }

    func hidePauseOverlay() {
        self.childNode(withName: "pauseOverlay")?.removeFromParent()
    }

    func updateMusicButtonsTexture(to imageName: String) {
        if let startButton = self.childNode(withName: "//musicButtonStart")
            as? SKSpriteNode
        {
            startButton.texture = SKTexture(imageNamed: imageName)
        }
        if let gameButton = self.childNode(withName: "//musicButton")
            as? SKSpriteNode
        {
            gameButton.texture = SKTexture(imageNamed: imageName)
        }
    }

    func playMusicAccordingToScene() {
        if muteMusic {
            updateMusicButtonsTexture(to: "NoMusicButton")
            return
        }

        if isInGame {
            SoundManager.shared.stopStartMusic()
            SoundManager.shared.playBackgroundMusic()
        } else {
            SoundManager.shared.stopBackgroundMusic()
            SoundManager.shared.playStartMusic()
        }
    }

    func stopAllMusic() {
        if SoundManager.shared.backgroundPlayer?.isPlaying == true {
            SoundManager.shared.stopBackgroundMusic()
        }
        if SoundManager.shared.startPlayer?.isPlaying == true {
            SoundManager.shared.stopStartMusic()
        }
    }

    func toggleBackgroundMusic() {
        muteMusic.toggle()

        if muteMusic {
            stopAllMusic()
            updateMusicButtonsTexture(to: "NoMusicButton")
        } else {
            playMusicAccordingToScene()
            updateMusicButtonsTexture(to: "MusicButton")
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

            case "tutorialButton":
                if let windowScene = UIApplication.shared.connectedScenes.first
                    as? UIWindowScene,
                    let window = windowScene.windows.first,
                    let rootVC = window.rootViewController
                {

                    let tutorialView = UIHostingController(
                        rootView: TutorialView()
                    )
                    tutorialView.modalPresentationStyle = .fullScreen

                    rootVC.present(
                        tutorialView,
                        animated: true,
                        completion: nil
                    )
                }

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
                toggleBackgroundMusic()

            case "musicButtonStart":
                toggleBackgroundMusic()

            default:
                break
            }
        }
    }
}

#Preview {
    ContentView()
}
