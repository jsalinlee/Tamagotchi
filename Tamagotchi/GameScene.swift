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
import CoreData

class GameScene: SKScene {
    let blob = Blob()
    var background = SKSpriteNode(imageNamed: "colored_castle")
    let ground = Ground()
    let hud = HUD()
    let cam = SKCameraNode()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var playerStats:Player?

    
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
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        do {
            let result = try context.fetch(request)
            let player = result as! [Player]
            if player.count == 0 {
                playerStats = Player(context: context)
                playerStats?.hunger = 50
                playerStats?.health = 100
                playerStats?.lastFeed = Date() as NSDate?
                playerStats?.lastPlay = Date() as NSDate?
                playerStats?.lastCheck = Date() as NSDate?
                do {
                    try context.save()
                } catch { print("Error") }
            }
            else {
                playerStats = player[0]
            }
        } catch {
            playerStats = Player(context: context)
            playerStats?.hunger = 50
            playerStats?.health = 100
            playerStats?.lastFeed = Date() as NSDate?
            playerStats?.lastPlay = Date() as NSDate?
            playerStats?.lastCheck = Date() as NSDate?
            do {
                try context.save()
            } catch { print("Error") }
        }
        hud.setHungerDisplay(newHealth: Int((playerStats?.hunger)!))

        let elapsed = Date().timeIntervalSince(playerStats!.lastCheck! as Date)
        print("\(elapsed/60) minutes")
        playerStats?.hunger -= Int(elapsed/360)
        if (playerStats?.hunger)! > 100 {
            playerStats?.hunger = 100
        }
        if (playerStats?.hunger)! < 0 {
            playerStats?.hunger = 0
            blob.statusText.text = "\(blob.gender[0]) is starving!"
        } else if (playerStats?.hunger)! < 50 {
            blob.statusText.text = "\(blob.gender[0]) is very hungry."
        } else if (playerStats?.hunger)! < 70 {
            blob.statusText.text = "\(blob.gender[0]) is a little hungry..."
        } else {
            blob.statusText.text = "\(blob.gender[0]) is feeling fine!"
        }
        hud.setHungerDisplay(newHealth: Int((playerStats?.hunger)!))
        playerStats!.lastCheck = NSDate()
        do {
            try context.save()
        } catch { print("Error!") }
        
    }
   
    enum thePhysics:UInt32 {
        case blob = 1
        case wall = 2
    }

}
