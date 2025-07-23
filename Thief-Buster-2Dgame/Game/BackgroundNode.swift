//
//  BackgroundNode.swift
//  Thief-Buster-2Dgame
//
//  Created by Ilham Wisnu on 23/07/25.
//

import SpriteKit

class BackgroundNode: SKNode {

    var bankImageBottomY: CGFloat = 0.0
    var stairBottomY: CGFloat = 0.0
    var tileSize: CGSize = .zero

    init(sceneSize: CGSize) {
        super.init()

        renderBank(sceneSize: sceneSize)
        renderStairs(sceneSize: sceneSize)
        renderTile(sceneSize: sceneSize)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func renderBank(sceneSize: CGSize) {
        let bankImage = SKSpriteNode(imageNamed: "Bank")
        bankImage.anchorPoint = CGPoint(x: 0.5, y: 1)
        bankImage.position = CGPoint(
            x: sceneSize.width / 2,
            y: sceneSize.height
        )

        let targetWidth = sceneSize.width
        let aspectRatio =
            bankImage.texture!.size().height / bankImage.texture!.size().width
        bankImage.size = CGSize(
            width: targetWidth,
            height: targetWidth * aspectRatio
        )

        addChild(bankImage)

        bankImageBottomY = bankImage.position.y - bankImage.size.height
    }

    private func renderStairs(sceneSize: CGSize) {
        let columns = 6
        let rows = 1
        let tileWidth = sceneSize.width / CGFloat(columns)

        let texture = SKTexture(imageNamed: "Stair")
        let tileSizeDef: CGSize = CGSize(width: tileWidth, height: tileWidth)
        let tileDef = SKTileDefinition(
            texture: texture,
            size: tileSizeDef
        )
        tileSize = tileSizeDef
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

    private func renderTile(sceneSize: CGSize) {
        let columns = 6
        let tileWidth = sceneSize.width / CGFloat(columns)
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
