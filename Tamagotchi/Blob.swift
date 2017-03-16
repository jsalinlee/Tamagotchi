//
//  Blob.swift
//  iBlob
//
//  Created by Samuel on 3/14/17.
//  Copyright © 2017 braggeInc. All rights reserved.
//

import Foundation
import SpriteKit

class Blob:SKSpriteNode {
    
    let initialSize = CGSize(width: 100, height: 100)
    let textureAtlas = SKTextureAtlas(named: "Blobs")
    

    
    
    init(){
        
        let texture = textureAtlas.textureNamed("blobBoy")
        super.init(texture: texture, color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(texture: texture, size: initialSize)
        self.position = CGPoint(x:0, y: 0)

    }
    
 
    
    
    func contact(){}
    
    func onTap(){}
    
    required init (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
