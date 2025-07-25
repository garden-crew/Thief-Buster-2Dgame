//
//  GameManager.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//

import SpriteKit

class GameManager {
    var scene: GameScene
    var startOverlay: SKSpriteNode?

    init(scene: GameScene) {
        self.scene = scene
    }

    func gameOver() {

        scene.run(
            SKAction.playSoundFileNamed(
                "GameOver.mp3",
                waitForCompletion: false
            )
        )
        SoundManager.shared.stopBackgroundMusic()
        scene.isPaused = true
        gameOverView()
    }

    func pauseView() {
        PauseView.show(on: scene)
        scene.isPaused = true
        scene.spawnManager.stop()
    }

    func startView() {
        scene.cameraNode.position = CGPoint(x: scene.size.width/2, y: scene.size.height - scene.viewSize.height/2)
        SoundManager.shared.stopBackgroundMusic()
        SoundManager.shared.playStartMusic()
        
        
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
        scene.highscoreLabel.fontColor = .clear
        scene.scoreLabel.fontColor = .clear
        scene.pauseButton.isHidden = true
    }

    func animateButtonTap(
        nodeName: String,
        tappedTexture: String,
        normalTexture: String,
        duration: TimeInterval = 0.2
    ) {
        // Cari node dengan nama
        if let button = scene.childNode(withName: "//\(nodeName)")
            as? SKSpriteNode
        {
            let changeToTap = SKAction.run {
                button.texture = SKTexture(imageNamed: tappedTexture)
            }
            let wait = SKAction.wait(forDuration: duration)
            let changeBack = SKAction.run {
                button.texture = SKTexture(imageNamed: normalTexture)
            }
            let sequence = SKAction.sequence([changeToTap, wait, changeBack])
            button.run(sequence)
        }
    }

    func animateStartAndRemoveOverlay() {
        SoundManager.shared.stopStartMusic()
        SoundManager.shared.playBackgroundMusic()
        
        scene.isPaused = false
        guard let overlay = startOverlay else { return }
        
        let moveDown = SKAction.moveTo(y: scene.gameViewCenterY, duration: 1)
        moveDown.timingMode = .easeOut

        scene.cameraNode.run(moveDown)

        scene.spawnManager.generate(targetY: scene.obstacleEndY)

        scene.isOverlayShown = false

        let fadeOut = SKAction.fadeOut(withDuration: 1)
        fadeOut.timingMode = .easeIn

        let showGameUI = SKAction.customAction(withDuration: 0) { _, _ in
            self.scene.scoreLabel.fontColor = .white
            self.scene.highscoreLabel.fontColor = .white
            self.scene.borderScore.alpha = 1
        }

        overlay.run(.sequence([fadeOut, showGameUI, .removeFromParent()]))
        scene.pauseButton.isHidden = false
    }

    private func gameOverView() {
        scene.spawnManager.stop()
        GameOverView.show(
            on: scene,
            score: scene.score,
            highscore: scene.highscore
        )
    }
}
