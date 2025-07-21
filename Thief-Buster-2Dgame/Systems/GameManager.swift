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
        overlay.name = "gameOverOverlay"
        
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
    
}
