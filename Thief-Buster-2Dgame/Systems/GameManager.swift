//
//  GameManager.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// GameManager.swift – mengatur state game (berjalan, game over, restart).
import SpriteKit

class GameManager {
    var scene: GameScene
    var startOverlay: SKSpriteNode?

    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    
    func gameOver() {
        self.scene.isPaused = true
        
        gameOverView()
    }
    
    
    func gameOverView(){
        
        let finalScore = scene.score
        let highestScore = scene.highscore
        
        let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.6), size: scene.size)
        overlay.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        overlay.zPosition = 300
        overlay.name = "gameOverlay"
        
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontName = "Arial-BoldMT"
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: 0, y: 100)  // posisi di paling atas
        overlay.addChild(gameOverLabel)
        
        // Label untuk menampilkan skor
        let scoreLabel = SKLabelNode(text: "Score: \(finalScore)")
        scoreLabel.fontName = "Arial-BoldMT"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 0, y: 0)
        overlay.addChild(scoreLabel)
        
        
        let highestScoreLabel = SKLabelNode(text: "Highest: \(highestScore)")
        highestScoreLabel.fontName = "Arial-BoldMT"
        highestScoreLabel.fontSize = 40
        highestScoreLabel.fontColor = .white
        highestScoreLabel.position = CGPoint(x: 0, y: -60)
        overlay.addChild(highestScoreLabel)
        
        let restartLabel = SKLabelNode(text: "Restart")
        restartLabel.fontName = "Arial-BoldMT"
        restartLabel.fontSize = 36
        restartLabel.fontColor = .yellow
        restartLabel.position = CGPoint(x: 0, y: -100)
        restartLabel.name = "restartButton" // penting untuk diidentifikasi
        overlay.addChild(restartLabel)
        
        let menuLabel = SKLabelNode(text: "Menu")
        menuLabel.fontName = "Arial-BoldMT"
        menuLabel.fontSize = 36
        menuLabel.fontColor = .yellow
        menuLabel.position = CGPoint(x: 0, y: -160)
        menuLabel.name = "menuButton" // penting untuk diidentifikasi
        overlay.addChild(menuLabel)
        
        scene.addChild(overlay)
        
    }
    
    func pauseView(){
        
        let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.6), size: scene.size)
        overlay.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        overlay.zPosition = 300
        overlay.name = "gameOverlay"
        
        let pauseLabel = SKLabelNode(text: "Paused")
        pauseLabel.fontName = "Arial-BoldMT"
        pauseLabel.fontSize = 50
        pauseLabel.fontColor = .white
        pauseLabel.position = CGPoint(x: 0, y: 100)
        overlay.addChild(pauseLabel)
        
        let resumeLabel = SKLabelNode(text: "Resume")
        resumeLabel.fontName = "Arial-BoldMT"
        resumeLabel.fontSize = 36
        resumeLabel.fontColor = .yellow
        resumeLabel.position = CGPoint(x: 0, y: 0)
        resumeLabel.name = "resumeButton"
        overlay.addChild(resumeLabel)
        
        let restartLabel = SKLabelNode(text: "Restart")
        restartLabel.fontName = "Arial-BoldMT"
        restartLabel.fontSize = 36
        restartLabel.fontColor = .yellow
        restartLabel.position = CGPoint(x: 0, y: -60)
        restartLabel.name = "restartButton"
        overlay.addChild(restartLabel)
        
        let quitLabel = SKLabelNode(text: "Quit")
        quitLabel.fontName = "Arial-BoldMT"
        quitLabel.fontSize = 36
        quitLabel.fontColor = .yellow
        quitLabel.position = CGPoint(x: 0, y: -100)
        quitLabel.name = "quitButton" // penting untuk diidentifikasi
        overlay.addChild(quitLabel)
        scene.addChild(overlay)
        
        self.scene.isPaused.toggle()
        
        scene.attackButtonLeft.isUserInteractionEnabled = false
        scene.attackButtonCenter.isUserInteractionEnabled = false
        scene.attackButtonRight.isUserInteractionEnabled = false
        scene.pauseButton.isUserInteractionEnabled = false

    }
    
    func startView() {
        
        scene.childNode(withName: "gameOverlay")?.removeFromParent()
        
        scene.score = 0
        
        let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.6), size: scene.size)
        overlay.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        overlay.zPosition = 300
        overlay.name = "startOverlay"
        
        // Highscore kiri atas
        let highscoreLabel = SKLabelNode(text: "Highscore: \(scene.highscore)")
        highscoreLabel.fontName = "Arial-BoldMT"
        highscoreLabel.fontSize = 28
        highscoreLabel.fontColor = .blue
        highscoreLabel.horizontalAlignmentMode = .left
        highscoreLabel.verticalAlignmentMode = .top
        highscoreLabel.position = CGPoint(
            x: -overlay.size.width/2 + 20,
            y: overlay.size.height/2 - 80
        )
        overlay.addChild(highscoreLabel)
        
        // Tombol musik kanan atas
        let musicButton = SKLabelNode(text: "♫")
        musicButton.fontName = "Arial-BoldMT"
        musicButton.fontSize = 36
        musicButton.fontColor = .yellow
        musicButton.horizontalAlignmentMode = .right
        musicButton.verticalAlignmentMode = .top
        musicButton.position = CGPoint(
            x: overlay.size.width/2 - 20,
            y: overlay.size.height/2 - 80
        )
        musicButton.name = "musicButton"
        overlay.addChild(musicButton)
        
        // Judul game di tengah
        let titleLabel = SKLabelNode(text: "Thief\nBuster")
        titleLabel.fontName = "Arial-BoldMT"
        titleLabel.fontSize = 60
        titleLabel.numberOfLines = 2
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .center
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: 0, y: 100)
        overlay.addChild(titleLabel)
        
        // Tombol start
        let startLabel = SKLabelNode(text: "Start")
        startLabel.fontName = "Arial-BoldMT"
        startLabel.fontSize = 44
        startLabel.fontColor = .yellow
        startLabel.position = CGPoint(x: 0, y: -200)
        startLabel.name = "startButton"
        overlay.addChild(startLabel)
        
        // Tombol tutorial di bawah start
        let tutorialLabel = SKLabelNode(text: "Tutorial")
        tutorialLabel.fontName = "Arial-BoldMT"
        tutorialLabel.fontSize = 36
        tutorialLabel.fontColor = .yellow
        tutorialLabel.position = CGPoint(x: 0, y: -250)
        tutorialLabel.name = "tutorialButton"
        overlay.addChild(tutorialLabel)
        
        scene.addChild(overlay)
        self.startOverlay = overlay
        
        self.scene.isPaused = true
        
        scene.children.forEach { node in
            if node.name == "obstacle" {
                node.removeFromParent()
            }
        }
        
        scene.spawnManager.generate()
        
        scene.loadHighscore()
        scene.highscoreLabel.text = "Highscore: \(scene.highscore)"
        
        
    }
    
    func animateStartAndRemoveOverlay() {
        self.scene.isPaused = false
        guard let overlay = startOverlay else { return }

        // Buat animasi geser ke atas (misalnya 1 detik)
        let moveUp = SKAction.moveBy(x: 0, y: scene.size.height, duration: 1.0)
        moveUp.timingMode = .easeIn

        // Setelah animasi selesai, hapus overlay & resume game
        let remove = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([moveUp, remove])
        overlay.run(sequence)
    }
    
    
    
}
