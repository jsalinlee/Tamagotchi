//
//  HUD.swift
//  Tamagotchi
//
//  Created by Jonathan Salin Lee on 3/16/17.
//  Copyright © 2017 Jonathan Salin Lee. All rights reserved.
//

import SpriteKit
import UIKit

class HUD: SKNode {
    var hungerBar: [SKSpriteNode] = []
    var happinessBar: [SKSpriteNode] = []
    var backHungerBar: [SKSpriteNode] = []
    var backHappyBar: [SKSpriteNode] = []
    let textureAtlas = SKTextureAtlas(named: "HUD")
    var hungerStatus = SKSpriteNode()
    var happyStatus = SKSpriteNode()
    
    func createHudNodes(screenSize: CGSize) {
        let cameraOrigin = CGPoint(
            x: screenSize.width / 2,
            y: screenSize.height / 2)

        print(cameraOrigin)
        
        hungerStatus = SKSpriteNode(texture: textureAtlas.textureNamed("hungerFull"))
        hungerStatus.size = CGSize(width: 30, height: 40)
        hungerStatus.position = CGPoint(x: cameraOrigin.x - 310, y: cameraOrigin.y - 94)

        self.addChild(hungerStatus)
        for index in 0..<100 {
            var backHungerBarNode = SKSpriteNode()
            var hungerBarNode = SKSpriteNode()
            if index == 0 {
                backHungerBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("barBackLeft"))
                hungerBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("barGreenLeft"))
            } else if index == 99 {
                backHungerBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("barBackRight"))
                hungerBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("barGreenRight"))
            } else {
                backHungerBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("barBackMid"))
                hungerBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("barGreenMid"))
            }
            backHungerBarNode.size = CGSize(width: 1, height: 10)
            hungerBarNode.size = CGSize(width: 1, height: 10)

            let xPos = cameraOrigin.x + CGFloat(index * 2) - 270
            let yPos = cameraOrigin.y - 94
            
            backHungerBarNode.position = CGPoint(x: xPos, y: yPos)
            hungerBarNode.position = CGPoint(x: xPos, y: yPos)
            hungerBar.append(hungerBarNode)
            self.addChild(backHungerBarNode)
            self.addChild(hungerBarNode)
        }
        
        happyStatus = SKSpriteNode(texture: textureAtlas.textureNamed("happyMed"))
        happyStatus.size = CGSize(width: 30, height: 30)
        happyStatus.position = CGPoint(x: cameraOrigin.x - 310, y: cameraOrigin.y - 144)
        self.addChild(happyStatus)

        for index in 0 ..< 100 {
            var backHappyBarNode = SKSpriteNode()
            var happinessBarNode = SKSpriteNode()
            if index == 0 {
                backHappyBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("barBackLeft"))
                happinessBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("barRedLeft"))
            } else if index == 99 {
                backHappyBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("barBackRight"))
                happinessBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("barRedRight"))
            } else {
                backHappyBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("barBackMid"))
                happinessBarNode = SKSpriteNode(texture: textureAtlas.textureNamed("barRedMid"))
            }
            backHappyBarNode.size = CGSize(width: 1, height: 10)
            happinessBarNode.size = CGSize(width: 1, height: 10)

            let xPos = cameraOrigin.x + CGFloat(index * 2) - 270
            let yPos = cameraOrigin.y - 144


            backHappyBarNode.position = CGPoint(x: xPos, y: yPos)
            happinessBarNode.position = CGPoint(x: xPos, y: yPos)
            happinessBar.append(happinessBarNode)
            self.addChild(backHappyBarNode)
            self.addChild(happinessBarNode)
        }
    }
    func setHungerDisplay(newHealth: Int) {
        let fadeAction = SKAction.fadeAlpha(to: 0.2, duration: 0.3)
        for index in 0 ..< hungerBar.count {
            if index < newHealth {
                hungerBar[index].alpha = 1
            } else {
                hungerBar[index].run(fadeAction)
            }
        }
    }
    func setHappinessDisplay(newHappiness: Int) {
        let fadeAction = SKAction.fadeAlpha(to: 0.2, duration: 0.3)
        for index in 0 ..< happinessBar.count {
            if index < newHappiness {
                happinessBar[index].alpha = 1
            } else {
                happinessBar[index].run(fadeAction)
            }
        }
    }
}

