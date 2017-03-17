//
//  GameScene.swift
//  Tamagotchi
//
//  Created by Jonathan Salin Lee on 3/16/17.
//  Copyright © 2017 Jonathan Salin Lee. All rights reserved.
//
import UIKit
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let blob = Blob()
    var background = SKSpriteNode(imageNamed: "colored_castle")
   
    override func didMove(to view: SKView) {
        // adding a boder along edges of screen.
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -5
        background.size = self.frame.size
        scene?.scaleMode = SKSceneScaleMode.aspectFill
        addChild(background)
        borderBody.friction = 0
        self.physicsBody = borderBody
        self.addChild(blob)
        
    }
   
    enum thePhysics:UInt32 {
        case blob = 1
        case wall = 2
    }

}
