//
//  Droplets.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 29/04/24.
//

import Foundation
import SpriteKit
//import CoreMotion

class Droplets: SKNode{
    var check: Bool = false
    init(_ num: Bool,image: SKSpriteNode, _ pos: CGPoint) {
        super.init()
        
        self.check = num
        
        //set the position of the node
        self.position = pos
        
        //set the size of the node
        self.setScale(1)
        
        //apply physics body to the node
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "air"), size: CGSize(width: image.size.width, height: image.size.height))
        
        self.physicsBody?.categoryBitMask = CollisionTypes.droplets.rawValue
        self.physicsBody?.contactTestBitMask = CollisionTypes.plant.rawValue | CollisionTypes.wall.rawValue
        self.physicsBody?.collisionBitMask = 0
        
        self.zPosition = 1
        
        self.physicsBody?.linearDamping = 5 //adjust how fast an object falls
//        self.physicsBody?.restitution = 2 //adjust how bouncy an object is
        
        //add the image to the object
        self.addChild(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func checkImage() -> Bool {
        return self.check
    }
}
