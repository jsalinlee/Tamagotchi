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
    var blobInstance: SKSpriteNode?
    let blob = Blob()
    var background = SKSpriteNode(imageNamed: "colored_castle")
    let ground = Ground()
    let hud = HUD()
    let cam = SKCameraNode()
    var touchPoint = CGPoint()
    
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
        
        ground.position = CGPoint(x:-self.size.width*2, y:-200)
        ground.size = CGSize(width: self.size.width*6, height: 0)
        ground.createChildren()
        self.addChild(ground)
        
        let player = Blob()
        blobInstance = player
        player.physicsBody?.allowsRotation = false
        self.addChild(player)
        
        self.camera = cam
        self.addChild(self.camera!)
        self.camera!.zPosition = 50
        print(camera!.position)
        hud.createHudNodes(screenSize: self.size)
        self.camera!.addChild(hud)
    }
    
    var touching = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            print(touch.location(in:self))
            let location = touch.location(in: self)
            let nodeTouched = atPoint(location)
            if let gameSprite = nodeTouched as? SKSpriteNode{
                touchPoint = location
                touching = true
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            touchPoint = location
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = false
    }
    override func update(_ currentTime: TimeInterval) {
        if touching {
            if touchPoint != blobInstance?.position
            {
                let dt:CGFloat = 0.15
                let distance = CGVector(dx: touchPoint.x-(blobInstance?.position.x)!, dy: touchPoint.y-(blobInstance?.position.y)!)
                let vel = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
                blobInstance?.physicsBody!.velocity = vel
            }
        }
    }
    
//    func update(currentTime: CFTimeInterval) {
//        if touching {
//            if touchPoint != blob.position
//            {
//                let pointA = touchPoint
//                let pointB = blob.position
//                let pointC = CGPoint(x: blob.position.x + 2, y: blob.position.y)
//                let angle_ab = atan2(pointA.y - pointB.y, pointA.x - pointB.x)
//                let angle_cb = atan2(pointC.y - pointB.y, pointC.x - pointB.x)
//                let angle_abc = angle_ab - angle_cb
//                let vectorx = cos(angle_abc)
//                let vectory = sin(angle_abc)
//                let dt:CGFloat = 15
//                let vel = CGVector(dx: vectorx * dt, dy: vectory * dt)
//                blob.physicsBody!.velocity = vel
//            }
//        }
//    }
//    
    enum thePhysics:UInt32 {
        case blob = 1
        case wall = 2
    }
}
