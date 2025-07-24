//
//  BackgroundScene.swift
//  Thief-Buster-2Dgame
//
//  Created by Ilham Wisnu on 22/07/25.
//

import SpriteKit    
import SwiftUI

class BackgroundScene: SKScene {

    var bankImageBottomY: CGFloat = 0.0
    var tileABottomY: CGFloat = 0.0
    var stairBottomY: CGFloat = 0.0

    var sceneCamera = SKCameraNode()

    var bgTopY: Double = 0.0
    var bgBottomY: Double = 0.0

    override func didMove(to view: SKView) {
        renderBank()
//        renderTileA()
        renderStairs()
        renderTileB()

        self.camera = sceneCamera
        

        bgTopY = (self.size.height - view.frame.height / 2) + 120

        bgBottomY = bgTopY - 200

        sceneCamera.position = CGPoint(x: size.width / 2, y: bgTopY)
        
        sceneCamera.setScale(0.7)
        
        addChild(sceneCamera)
    }
    
    func animateBackground() {
        let cameraDownAction = SKAction.moveTo(y: bgBottomY, duration: 1.0)
        
        let scaleAction = SKAction.scale(to: 1.0, duration: 1.0)
        
        let groupAction = SKAction.group([cameraDownAction, scaleAction])
        
        groupAction.timingMode = .easeOut
        
        sceneCamera.run(groupAction)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateBackground()
    }

    func renderBank() {
        let bankImage = SKSpriteNode(imageNamed: "Bank")
        bankImage.anchorPoint = CGPoint(x: 0.5, y: 1)  // top-center
        bankImage.position = CGPoint(x: size.width / 2, y: size.height)  // top of screen

        // Resize to fit screen width
        let targetWidth = size.width
        let aspectRatio =
            bankImage.texture!.size().height / bankImage.texture!.size().width
        bankImage.size = CGSize(
            width: targetWidth,
            height: targetWidth * aspectRatio
        )

        addChild(bankImage)

        bankImageBottomY = bankImage.position.y - bankImage.size.height
    }

    func renderTileA() {
        let columns: Int = 6
        let rows: Int = 2

        let tileWidth = size.width / Double(columns)

        let texture = SKTexture(imageNamed: "TileA")
        let tileDef = SKTileDefinition(
            texture: texture,
            size: CGSize(width: tileWidth, height: tileWidth)
        )
        let tileGroup = SKTileGroup(tileDefinition: tileDef)
        let tileSet = SKTileSet(tileGroups: [tileGroup])

        let tileSize = CGSize(width: tileWidth, height: tileWidth)
        let tileMap = SKTileMapNode(
            tileSet: tileSet,
            columns: columns,
            rows: rows,
            tileSize: tileSize
        )

        for col in 0..<columns {
            for row in 0..<rows {
                tileMap.setTileGroup(tileGroup, forColumn: col, row: row)
            }
        }

        tileMap.anchorPoint = CGPoint(x: 0, y: 1)
        tileMap.position = CGPoint(x: 0, y: bankImageBottomY)
        addChild(tileMap)

        tileABottomY = bankImageBottomY - tileMap.mapSize.height
    }

    func renderStairs() {
        let columns: Int = 6
        let rows: Int = 1

        let tileWidth = size.width / Double(columns)

        let texture = SKTexture(imageNamed: "Stair")
        let tileDef = SKTileDefinition(
            texture: texture,
            size: CGSize(width: tileWidth, height: tileWidth)
        )
        let tileGroup = SKTileGroup(tileDefinition: tileDef)
        let tileSet = SKTileSet(tileGroups: [tileGroup])

        let tileSize = CGSize(width: tileWidth, height: tileWidth)
        let tileMap = SKTileMapNode(
            tileSet: tileSet,
            columns: columns,
            rows: rows,
            tileSize: tileSize
        )

        for col in 0..<columns {
            for row in 0..<rows {
                tileMap.setTileGroup(tileGroup, forColumn: col, row: row)
            }
        }

        tileMap.anchorPoint = CGPoint(x: 0, y: 1)
        tileMap.position = CGPoint(x: 0, y: bankImageBottomY)
        addChild(tileMap)

        stairBottomY = bankImageBottomY - tileMap.mapSize.height
    }

    func renderTileB() {
        let columns: Int = 6

        let tileWidth = size.width / Double(columns)

        let rows = Int(stairBottomY / tileWidth) + 1

        let texture = SKTexture(imageNamed: "TileB")
        let tileDef = SKTileDefinition(
            texture: texture,
            size: CGSize(width: tileWidth, height: tileWidth)
        )
        let tileGroup = SKTileGroup(tileDefinition: tileDef)
        let tileSet = SKTileSet(tileGroups: [tileGroup])

        let tileSize = CGSize(width: tileWidth, height: tileWidth)
        let tileMap = SKTileMapNode(
            tileSet: tileSet,
            columns: columns,
            rows: rows,
            tileSize: tileSize
        )

        for col in 0..<columns {
            for row in 0..<rows {
                tileMap.setTileGroup(tileGroup, forColumn: col, row: row)
            }
        }

        tileMap.anchorPoint = CGPoint(x: 0, y: 1)
        tileMap.position = CGPoint(x: 0, y: stairBottomY)
        addChild(tileMap)
    }
}

#Preview {
    ContentView()
}
