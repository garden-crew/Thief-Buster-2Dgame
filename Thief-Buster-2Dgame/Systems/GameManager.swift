//
//  GameManager.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// GameManager.swift – mengatur state game (berjalan, game over, restart).
// GameManager.swift – Koordinator utama state game
import SpriteKit

class GameManager {
    var scene: GameScene
    var startOverlay: SKSpriteNode?

    init(scene: GameScene) {
        self.scene = scene
    }

    func gameOver() {

        scene.run(SKAction.playSoundFileNamed("GameOver.mp3", waitForCompletion: false))
        SoundManager.shared.stopBackgroundMusic()
        scene.isPaused = true
        gameOverView()
    }

    func pauseView() {
        PauseView.show(on: scene)
        scene.isPaused = true
    }

    func startView() {
       SoundManager.shared.playBackgroundMusic()
        scene.childNode(withName: "gameOverlay")?.removeFromParent()
        scene.score = 0
        let overlay = StartView.build(on: scene)
        scene.addChild(overlay)
        self.startOverlay = overlay
        scene.isPaused = true

        scene.children.forEach { node in
            if node.name == "obstacle" {
                node.removeFromParent()
            }
        }

        scene.loadHighscore()
        scene.highscoreLabel.text = "Highscore: \(scene.highscore)"
    }

    func animateStartAndRemoveOverlay() {
        scene.isPaused = false
        guard let overlay = startOverlay else { return }
        
        scene.spawnManager.generate(targetY: scene.obstacleEndY)
        
        scene.isOverlayShown = false
        
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        fadeOut.timingMode = .easeIn
        
        let showGameUI = SKAction.customAction(withDuration: 0) { _, _ in
            self.scene.scoreLabel.fontColor = .white
            self.scene.highscoreLabel.fontColor = .white
        }
        
        overlay.run(.sequence([fadeOut, showGameUI, .removeFromParent()]))
    }

    private func gameOverView() {
        GameOverView.show(on: scene, score: scene.score, highscore: scene.highscore)
    }
}

