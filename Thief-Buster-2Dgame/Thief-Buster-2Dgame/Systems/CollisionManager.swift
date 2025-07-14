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

import Foundation
import SpriteKit

class Cobacoba {
    var gamescene: GameScene

    init(gamescene: GameScene) {
        self.gamescene = gamescene
    }

    func handleTouches(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: gamescene)

        let perfectThreshold: CGFloat =
            gamescene.targetMid.frame.size.height / 4
        let goodThreshold: CGFloat = gamescene.targetMid.frame.size.height / 2

        func checkAlignment(with target: SKShapeNode) {

            let targetCenterY = target.position.y
            let nodes = gamescene.nodes(at: target.position)

            let obstacles = nodes.filter { node in
                node.name == "obstacle"
            }

            let obstacle = obstacles.first as! Obstacle?

            if obstacle == nil {
                return
            }

            let enemyPosition =
                obstacle!.frame.minY + (obstacle!.frame.size.height / 2)

            let distance = abs(enemyPosition - targetCenterY)

            if distance <= perfectThreshold {
                print("Perfect! 🎉")
                obstacle!.die()
            } else if distance <= goodThreshold {
                print("Good!")
                obstacle!.die()
            } else {
                print("Miss")
            }
        }

        if gamescene.buttonLeft.contains(location) {

            checkAlignment(with: gamescene.targetLeft)
            //            gamescene.targetLeft.fillColor = .yellow
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //                self.gamescene.targetLeft.fillColor = .blue
            //            }

        } else if gamescene.buttonMid.contains(location) {

            checkAlignment(with: gamescene.targetMid)
            //            gamescene.targetMid.fillColor = .yellow
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //                self.gamescene.targetMid.fillColor = .blue
            //            }

        } else if gamescene.buttonRight.contains(location) {

            checkAlignment(with: gamescene.targetRight)
            //            gamescene.targetRight.fillColor = .yellow
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //                self.gamescene.targetRight.fillColor = .blue
            //            }
        }
    }
}
