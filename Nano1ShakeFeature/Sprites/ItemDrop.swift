//
//  ItemDrop.swift
//  Wonder Seed
//
//  Created by Bryan Vernanda on 06/05/24.
//

import Foundation
import SpriteKit
import UIKit

class ItemDrop: SKNode{
    init(image: SKSpriteNode) {
        super.init()
        
        //set the position of the node
        self.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        
        //set the size of the node
        self.setScale(0.25)
        
        //apply physics body to the node
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "apple"), size: CGSize(width: image.size.width * 0.25, height: image.size.height * 0.25))
        
        self.physicsBody?.categoryBitMask = CollisionTypes.itemDrop.rawValue
        self.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        self.zPosition = 3
        self.physicsBody?.isDynamic = true
        
//        self.physicsBody?.linearDamping = 5 //adjust how fast an object falls
//        self.physicsBody?.restitution = 2 //adjust how bouncy an object is
        
        //add the image to the object
        self.addChild(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
