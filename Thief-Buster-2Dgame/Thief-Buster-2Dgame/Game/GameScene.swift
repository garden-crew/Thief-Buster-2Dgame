//
//  GameScene.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//

// GameScene.swift – file utama SpriteKit yang mengatur tampilan dan update setiap frame.
//
//  GameScene.swift
//  nyoba nyoba game
//
//  Created by Juan Hubert Liem on 10/07/25.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    var player: SKSpriteNode!
    var maling: SKSpriteNode!
    var gameover: SKSpriteNode!

    override func didMove(to view: SKView) {
        SoundManager.shared.playBackgroundMusic()
        setupPlayer()
        setupMaling()
        setupGameOver()
    }

    func setupPlayer() {
        player = SKSpriteNode(imageNamed: "1")
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        player.zPosition = 1
        player.size = CGSize(width: 150, height: 150)
        player.name = "player"
        addChild(player)
    }

    func setupMaling() {
        maling = SKSpriteNode(imageNamed: "20")
        maling.position = CGPoint(x: size.width / 2, y: size.height / 4)
        maling.zPosition = 1
        maling.size = CGSize(width: 150, height: 150)
        maling.name = "maling"
        addChild(maling)
    }

    func setupGameOver() {
        gameover = SKSpriteNode(imageNamed: "14")
        gameover.position = CGPoint(x: size.width - 100, y: 100)
        gameover.zPosition = 1
        gameover.size = CGSize(width: 150, height: 150)
        gameover.name = "gameover"
        addChild(gameover)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if player.contains(location) {
            SoundManager.shared.play(sound: .powerUp)

            player.run(SKAction.sequence([
                SKAction.scale(to: 1.1, duration: 0.05),
                SKAction.scale(to: 1.0, duration: 0.05)
            ]))
        }

        if maling.contains(location) {
            SoundManager.shared.play(sound: .hitThief)

            maling.run(SKAction.sequence([
                SKAction.scale(to: 1.1, duration: 0.05),
                SKAction.scale(to: 1.0, duration: 0.05)
            ]))
        }

        if gameover.contains(location) {
            SoundManager.shared.play(sound: .gameOver)

            gameover.run(SKAction.sequence([
                SKAction.scale(to: 1.1, duration: 0.05),
                SKAction.scale(to: 1.0, duration: 0.05)
            ]))
        }
    }
}
