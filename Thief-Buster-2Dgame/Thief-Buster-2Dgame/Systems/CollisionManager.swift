//
//  CollisionManager.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 10/07/25.
//
// CollisionManager.swift – deteksi tabrakan.

//
//  Cobacoba.swift
//  Trying BishiBashi
//
//  Created by Edward Suwandi on 11/07/25.
//

import SpriteKit
import Foundation

class Cobacoba {
    var gamescene: GameScene
    
    init(gamescene: GameScene) {
        self.gamescene = gamescene
    }
    
    func handleTouches(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: gamescene)

        let perfectThreshold: CGFloat = 25
        let goodThreshold: CGFloat = 50

        func checkAlignment(with target: SKShapeNode) {
            let enemyBottomY = gamescene.enemy.frame.minY
            let targetCenterY = target.position.y
            let distance = abs(enemyBottomY - targetCenterY)

            if distance <= perfectThreshold {
                print("Perfect! 🎉")
            } else if distance <= goodThreshold {
                print("Good!")
            } else {
                print("Miss")
            }
        }

        if gamescene.buttonLeft.contains(location) {
            gamescene.targetLeft.fillColor = .yellow
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.gamescene.targetLeft.fillColor = .blue
            }
            checkAlignment(with: gamescene.targetLeft)

        } else if gamescene.buttonMid.contains(location) {
            gamescene.targetMid.fillColor = .yellow
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.gamescene.targetMid.fillColor = .blue
            }
            checkAlignment(with: gamescene.targetMid)

        } else if gamescene.buttonRight.contains(location) {
            gamescene.targetRight.fillColor = .yellow
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.gamescene.targetRight.fillColor = .blue
            }
            checkAlignment(with: gamescene.targetRight)
        }
    }
}
