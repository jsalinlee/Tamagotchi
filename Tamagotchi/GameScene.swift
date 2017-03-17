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
    let hud = HUD()
    let cam = SKCameraNode()
    
    var touchPoint: CGPoint = CGPoint()
    var touching: Bool = false
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
    
    func touchesBegan(touches: Set<NSObject>, withEven event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.location(in: self)
        if blob.frame.contains(location) {
            touchPoint = location
            touching = true
        }
    }
    
    func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.location(in: self)
        touchPoint = location
    }
    
    func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        touching = false
    }
   
    enum thePhysics:UInt32 {
        case blob = 1
        case wall = 2
    }
    override func update(_ currentTime: CFTimeInterval) {
        if touching {
            let dt: CGFloat = 1.0/60.0
            let distance = CGVector(dx: touchPoint.x-blob.position.x, dy: touchPoint.y-blob.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            blob.physicsBody!.velocity = velocity
        }
    }
}
