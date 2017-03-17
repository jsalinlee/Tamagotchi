//
//  Blob.swift
//  iBlob
//
//  Created by Samuel on 3/14/17.
//  Copyright © 2017 braggeInc. All rights reserved.
//

import SpriteKit

class Blob:SKSpriteNode {
    
    let initialSize = CGSize(width: 100, height: 100)
    let textureAtlas = SKTextureAtlas(named: "Blobs")
    var gender = [String]()
    var statusText = SKLabelNode()
    var sitAnimation = SKAction()
    
    
    init(){
        
        let texture = textureAtlas.textureNamed("blobBoy")
        super.init(texture: texture, color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(texture: texture, size: initialSize)
        self.position = CGPoint(x:0, y: 0)
        self.gender = determineGender()

        createAnimation()
        self.run(sitAnimation)
        statusText.text = self.gender[0] + " looks a little hungry..."
        statusText.fontColor = UIColor.black
        statusText.fontName="Avenir"
        statusText.position = CGPoint(x: self.position.x, y: self.position.y + 200)

        addChild(statusText)
    }
    func createAnimation() {
        let sitFrames:[SKTexture] = [textureAtlas.textureNamed("blobBoy"), textureAtlas.textureNamed("blobBoyMove")]
        let sitAction = SKAction.animate(with: sitFrames, timePerFrame: 0.50)
        sitAnimation = SKAction.repeatForever(sitAction)
    }
    
    func determineGender() -> [String] {
        let genderNumber = arc4random_uniform(2)
        if genderNumber == 0 {
            return ["She", "her"]
        } else {
            return ["He", "his"]
        }
    }
    
    
    func contact(){}
    
    func onTap(){}
    
    required init (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
