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
<<<<<<< HEAD
    let cam = SKCameraNode()
    let hud = HUD()
=======
    var background = SKSpriteNode(imageNamed: "colored_castle")
    let ground = Ground()
    let hud = HUD()
    let cam = SKCameraNode()
>>>>>>> origin/backgroundFinalized
    
    override func didMove(to view: SKView) {
        // adding a border along edges of screen.
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -5
        background.size = self.frame.size
        scene?.scaleMode = SKSceneScaleMode.aspectFill
        addChild(background)
        borderBody.friction = 0
        self.physicsBody = borderBody
        self.addChild(blob)
        
<<<<<<< HEAD
=======
        ground.position = CGPoint(x:-self.size.width*2, y:-200)
        ground.size = CGSize(width: self.size.width*6, height: 0)
        ground.createChildren()
        self.addChild(ground)
        
>>>>>>> origin/backgroundFinalized
        self.camera = cam
        self.addChild(self.camera!)
        self.camera!.zPosition = 50
        print(camera!.position)
        hud.createHudNodes(screenSize: self.size)
        self.camera!.addChild(hud)
<<<<<<< HEAD
=======
        
>>>>>>> origin/backgroundFinalized
    }
   
    enum thePhysics:UInt32 {
        case blob = 1
        case wall = 2
    }

}
