//
//  PauseView.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 22/07/25.
//
// PauseView.swift – Tampilan saat game di-pause
import SpriteKit

struct PauseView {
    static func show(on scene: SKScene) {
        let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.6), size: scene.size)
        overlay.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        overlay.zPosition = ZPosition.overlay.rawValue
        overlay.name = "pauseOverlay"

        let pauseLabel = SKLabelNode(text: "Paused")
        pauseLabel.fontName = "Pixellari"
        pauseLabel.fontSize = 50
        pauseLabel.fontColor = .white
        pauseLabel.position = CGPoint(x: 0, y: 100)
        overlay.addChild(pauseLabel)

        let resumeLabel = SKSpriteNode(imageNamed: "ResumeButton")
        resumeLabel.position = CGPoint(x: 0, y: 0)
        resumeLabel.size = CGSize(width: 150, height: 50)
        resumeLabel.name = "resumeButton"
        overlay.addChild(resumeLabel)

        let restartLabel = SKSpriteNode(imageNamed: "RestartButton")
        restartLabel.position = CGPoint(x: 0, y: -60)
        restartLabel.size = CGSize(width: 150, height: 50)
        restartLabel.name = "restartButton"
        overlay.addChild(restartLabel)
        
        let musicButton = SKSpriteNode(imageNamed: "MusicButton")
        musicButton.size = CGSize(width: 60, height: 60)
        musicButton.position = CGPoint(x: 150, y: 110)
        musicButton.name = "musicButton"
        overlay.addChild(musicButton)

        let quitLabel = SKSpriteNode(imageNamed: "QuitButton")
        quitLabel.position = CGPoint(x: 0, y: -170)
        quitLabel.size = CGSize(width: 150, height: 50)
        quitLabel.name = "quitButton"
        overlay.addChild(quitLabel)

        scene.addChild(overlay)
    }
}
