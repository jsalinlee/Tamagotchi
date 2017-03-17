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
    let ground = Ground()
    
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
        
        ground.position = CGPoint(x:-self.size.width*2, y:-200)
        ground.size = CGSize(width: self.size.width*6, height: 0)
        ground.createChildren()
        self.addChild(ground)
        
        self.camera = cam
        self.addChild(self.camera!)
        self.camera!.zPosition = 50
        print(camera!.position)
        hud.createHudNodes(screenSize: self.size)
        self.camera!.addChild(hud)
        
    }
   
    enum thePhysics:UInt32 {
        case blob = 1
        case wall = 2
    }

}
