//
//  GameOverView.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// Tampilan ketika game over
// GameOverView.swift – Tampilan saat game over
import SpriteKit

struct GameOverView {
    static func show(on scene: SKScene, score: Int, highscore: Int) {
        let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.6), size: scene.size)
        overlay.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        overlay.zPosition = 300
        overlay.name = "gameOverlay"

        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontName = "Arial-BoldMT"
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: 0, y: 100)
        overlay.addChild(gameOverLabel)

        let scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontName = "Arial-BoldMT"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 0, y: 0)
        overlay.addChild(scoreLabel)

        let highestScoreLabel = SKLabelNode(text: "Highest: \(highscore)")
        highestScoreLabel.fontName = "Arial-BoldMT"
        highestScoreLabel.fontSize = 40
        highestScoreLabel.fontColor = .white
        highestScoreLabel.position = CGPoint(x: 0, y: -60)
        overlay.addChild(highestScoreLabel)

        let restartLabel = SKSpriteNode(imageNamed: "RestartButton")
        restartLabel.size = CGSize(width: 150, height: 50)
        restartLabel.position = CGPoint(x: 0, y: -100)
        restartLabel.zPosition = 301
        restartLabel.name = "restartButton"
        overlay.addChild(restartLabel)

        let menuLabel = SKSpriteNode(imageNamed: "MenuButton")
        menuLabel.size = CGSize(width: 150, height: 50)
        menuLabel.position = CGPoint(x: 0, y: -160)
        menuLabel.zPosition = 301
        menuLabel.name = "menuButton"
        overlay.addChild(menuLabel)

        scene.addChild(overlay)
        
        if let gameScene = scene as? GameScene {
            gameScene.isOverlayShown = true 
        }
    }
}
