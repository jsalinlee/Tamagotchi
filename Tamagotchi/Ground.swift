//
//  Ground.swift
//  Tamagotchi
//
//  Created by Jackie Thind on 3/17/17.
//  Copyright © 2017 Jonathan Salin Lee. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "Environment")
    func createChildren() {
        self.anchorPoint = CGPoint(x:0, y:1)
        let texture = textureAtlas.textureNamed("ground")
        var tileCount:CGFloat = 0
        let tileSize = CGSize(width:35, height:300)
        while tileCount * tileSize.width < self.size.width {
            let tileNode = SKSpriteNode(texture:texture)
            tileNode.size = tileSize
            tileNode.position.x = tileCount * tileSize.width
            tileNode.anchorPoint = CGPoint(x:0,y:1)
            self.addChild(tileNode)
            tileCount += 1
        }
        let pointTopLeft = CGPoint(x:0,y:0)
        let pointTopRight = CGPoint(x:size.width, y:0)
        self.physicsBody = SKPhysicsBody(edgeFrom: pointTopLeft, to: pointTopRight)
    }
    func onTap() {}
}
