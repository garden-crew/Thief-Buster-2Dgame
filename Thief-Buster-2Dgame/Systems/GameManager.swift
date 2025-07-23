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
        SoundManager.shared.play(sound: .gameOver)
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

        scene.spawnManager.generate()
        scene.loadHighscore()
        scene.highscoreLabel.text = "Highscore: \(scene.highscore)"
    }

    func animateStartAndRemoveOverlay() {
        scene.isPaused = false
        guard let overlay = startOverlay else { return }
        
        scene.isOverlayShown = false
        
        let moveUp = SKAction.moveBy(x: 0, y: scene.size.height, duration: 1.0)
        moveUp.timingMode = .easeIn
        overlay.run(.sequence([moveUp, .removeFromParent()]))
    }

    private func gameOverView() {
        GameOverView.show(on: scene, score: scene.score, highscore: scene.highscore)
    }
}

