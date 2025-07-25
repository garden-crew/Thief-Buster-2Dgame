//
//  GameOverView.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
//  Tampilan saat game over

import SpriteKit

struct GameOverView {
    static func show(on scene: SKScene, score: Int, highscore: Int) {
        
        // Overlay gelap transparan
        let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.6), size: scene.size)
        overlay.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        overlay.zPosition = 300
        overlay.name = "gameOverlay"
        
        // Background border untuk label
        let backgroundPanel = SKSpriteNode(imageNamed: "BorderMenu")
        backgroundPanel.size = CGSize(width: 350, height: 500)
        backgroundPanel.position = CGPoint(x: 0, y: -100)
        backgroundPanel.zPosition = 301
        overlay.addChild(backgroundPanel)
        
        // Label "Game Over" dengan gradasi warna
        let gameOverLabel = GradedTextNode(
            text: "GAME OVER",
            fontName: "Pixellari",
            fontSize: 45,
            gradientColors: [.red, .orange, .yellow]
        )
        gameOverLabel.position = CGPoint(x: backgroundPanel.position.x, y: backgroundPanel.position.y + (backgroundPanel.size.height / 2) - 100)
        gameOverLabel.zPosition = 302
        overlay.addChild(gameOverLabel)
        
        // Label skor
        let scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontName = "Pixellari"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 0, y: -30)
        scoreLabel.zPosition = 302
        overlay.addChild(scoreLabel)

        // Label skor tertinggi
        let highscoreLabel = SKLabelNode(text: "Highest: \(highscore)")
        highscoreLabel.fontName = "Pixellari"
        highscoreLabel.fontSize = 30
        highscoreLabel.fontColor = .white
        highscoreLabel.position = CGPoint(x: 0, y: -70)
        highscoreLabel.zPosition = 302
        overlay.addChild(highscoreLabel)

        // Tombol restart
        let restartButton = SKSpriteNode(imageNamed: "RestartButton")
        restartButton.size = CGSize(width: 220, height: 60)
        restartButton.position = CGPoint(x: 0, y: -160)
        restartButton.zPosition = 303
        restartButton.name = "restartButton"
        overlay.addChild(restartButton)

        // Tombol kembali ke menu
        let menuButton = SKSpriteNode(imageNamed: "MenuButton")
        menuButton.size = CGSize(width: 220, height: 60)
        menuButton.position = CGPoint(x: 0, y: -230)
        menuButton.zPosition = 303
        menuButton.name = "menuButton"
        overlay.addChild(menuButton)

        // Tambahkan overlay ke scene
        scene.addChild(overlay)

        // Tandai bahwa overlay sedang ditampilkan
        if let gameScene = scene as? GameScene {
            gameScene.isOverlayShown = true
        }
    }
}
