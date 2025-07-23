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
        quitLabel.name = "quitButton"
        overlay.addChild(quitLabel)

        scene.addChild(overlay)
    }
}

