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
        overlay.position = CGPoint(x: 0, y: 0)
        overlay.zPosition = ZPosition.overlay.rawValue
        overlay.anchorPoint = .zero
        overlay.color = .clear
        overlay.name = "startOverlay"

//        let borderScore = SKSpriteNode(imageNamed: "BorderScore")
//        borderScore.anchorPoint = CGPoint(x: 0, y: 0.5)
//        borderScore.size = CGSize(width: 170, height: 70)
//        borderScore.position = CGPoint(x: 20, y: overlay.size.height - 80)
//        borderScore.zPosition = 1
//        overlay.addChild(borderScore)
//        
//        let highscoreLabel = SKLabelNode(text: "Highscore: \(UserDefaults.standard.integer(forKey: "highscore"))")
//        highscoreLabel.fontName = "Pixellari"
//        highscoreLabel.fontSize = 28
//        highscoreLabel.fontColor = .black
//        highscoreLabel.horizontalAlignmentMode = .left
//        highscoreLabel.verticalAlignmentMode = .top
//        highscoreLabel.zPosition = 2
//        highscoreLabel.position = CGPoint(
//            x: 20,
//            y: overlay.size.height - 80
//        )
//        overlay.addChild(highscoreLabel)

        var musicImage = "MusicButton"
        if let gameScene = scene as? GameScene {
            if gameScene.muteMusic {
                musicImage = "NoMusicButton"
            }
        }

        let musicButton = SKSpriteNode(imageNamed: musicImage)
        musicButton.size = CGSize(width: 60, height: 60)
        musicButton.position = CGPoint(
            x: overlay.size.width - 50,
            y: overlay.size.height - 100
        )
        musicButton.name = "musicButtonStart"
        overlay.addChild(musicButton)

        let titleLabel = SKSpriteNode(imageNamed: "GameLogo")
        titleLabel.size = CGSize(width: 350, height: 150)
        titleLabel.position = CGPoint(x: overlay.size.width/2, y: overlay.size.height - 220)
        overlay.addChild(titleLabel)

        let startLabel = SKSpriteNode(imageNamed: "StartButton")
        startLabel.position = CGPoint(x: overlay.size.width / 2, y: scene.size.height / 2 - 40)
        startLabel.name = "startButton"
        startLabel.size = CGSize(width: 250, height: 60)
        overlay.addChild(startLabel)

        let tutorialLabel = SKSpriteNode(imageNamed: "TutorialButton")
        tutorialLabel.position = CGPoint(x: overlay.size.width / 2, y: scene.size.height / 2 - 120)
        tutorialLabel.size = CGSize(width: 250, height: 60)
        tutorialLabel.name = "tutorialButton"
        overlay.addChild(tutorialLabel)

        return overlay
    }
}
