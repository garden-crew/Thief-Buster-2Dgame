//
//  StartView.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// Tampilan mau mulai game
// StartView.swift – Tampilan awal game
import SpriteKit

struct StartView {
    static func build(on scene: SKScene) -> SKSpriteNode {
        let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.6), size: scene.size)
        overlay.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        overlay.zPosition = 300
        overlay.name = "startOverlay"

        let highscoreLabel = SKLabelNode(text: "Highscore: \(UserDefaults.standard.integer(forKey: "highscore"))")
        highscoreLabel.fontName = "Arial-BoldMT"
        highscoreLabel.fontSize = 28
        highscoreLabel.fontColor = .blue
        highscoreLabel.horizontalAlignmentMode = .left
        highscoreLabel.verticalAlignmentMode = .top
        highscoreLabel.position = CGPoint(x: -overlay.size.width/2 + 20, y: overlay.size.height/2 - 80)
        overlay.addChild(highscoreLabel)

        let musicButton = SKLabelNode(text: "♫")
        musicButton.fontName = "Arial-BoldMT"
        musicButton.fontSize = 36
        musicButton.fontColor = .yellow
        musicButton.horizontalAlignmentMode = .right
        musicButton.verticalAlignmentMode = .top
        musicButton.position = CGPoint(x: overlay.size.width/2 - 20, y: overlay.size.height/2 - 80)
        musicButton.name = "musicButton"
        overlay.addChild(musicButton)

        let titleLabel = SKLabelNode(text: "Thief\nBuster")
        titleLabel.fontName = "Arial-BoldMT"
        titleLabel.fontSize = 60
        titleLabel.numberOfLines = 2
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .center
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: 0, y: 100)
        overlay.addChild(titleLabel)

        let startLabel = SKLabelNode(text: "Start")
        startLabel.fontName = "Arial-BoldMT"
        startLabel.fontSize = 44
        startLabel.fontColor = .yellow
        startLabel.position = CGPoint(x: 0, y: -200)
        startLabel.name = "startButton"
        overlay.addChild(startLabel)

        let tutorialLabel = SKLabelNode(text: "Tutorial")
        tutorialLabel.fontName = "Arial-BoldMT"
        tutorialLabel.fontSize = 36
        tutorialLabel.fontColor = .yellow
        tutorialLabel.position = CGPoint(x: 0, y: -250)
        tutorialLabel.name = "tutorialButton"
        overlay.addChild(tutorialLabel)

        return overlay
    }
}
