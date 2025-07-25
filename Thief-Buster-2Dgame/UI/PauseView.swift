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

        let borderMenu = SKSpriteNode(imageNamed: "BorderMenu")
        borderMenu.size = CGSize(width: 350, height: 500)
        borderMenu.position = CGPoint(x: 0, y: -100)
        borderMenu.zPosition = 1
        borderMenu.name = "borderMenu"
        overlay.addChild(borderMenu)
        
        let pauseLabel = SKLabelNode(text: "PAUSED")
        pauseLabel.fontName = "Pixellari"
        pauseLabel.fontSize = 50
        pauseLabel.fontColor = .white
        pauseLabel.zPosition = 2
        pauseLabel.position = CGPoint(x: borderMenu.position.x, y: borderMenu.position.y + (borderMenu.size.height / 2) - 100)
        overlay.addChild(pauseLabel)

        let resumeLabel = SKSpriteNode(imageNamed: "ResumeButton")
        resumeLabel.position = CGPoint(x: 0, y: -40)
        resumeLabel.size = CGSize(width: 220, height: 60)
        resumeLabel.zPosition = 2
        resumeLabel.name = "resumeButton"
        overlay.addChild(resumeLabel)

        let restartLabel = SKSpriteNode(imageNamed: "RestartButton")
        restartLabel.position = CGPoint(x: 0, y: -120)
        restartLabel.size = CGSize(width: 220, height: 60)
        restartLabel.name = "restartButton"
        restartLabel.zPosition = 2
        overlay.addChild(restartLabel)
        
//        let musicButton = SKSpriteNode(imageNamed: "MusicButton")
//        musicButton.size = CGSize(width: 60, height: 60)
//        musicButton.position = CGPoint(x: 150, y: 110)
//        musicButton.name = "musicButton"
//        musicButton.zPosition = 2
//        overlay.addChild(musicButton)

        let quitLabel = SKSpriteNode(imageNamed: "QuitButton")
        quitLabel.position = CGPoint(x: 0, y: -200)
        quitLabel.size = CGSize(width: 220, height: 60)
        quitLabel.name = "quitButton"
        quitLabel.zPosition = 2
        overlay.addChild(quitLabel)

        scene.addChild(overlay)
    }
}

