//
//  Plant.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 29/04/24.
//

import Foundation
import SpriteKit

class Plant: SKNode {
    init(image: SKSpriteNode, _ scale: CGFloat, _ pos: CGPoint, _ num: CGFloat) {
        super.init()
        
        self.setScale(scale)
        
        self.position = pos
        
        let size = CGSize(width: image.size.width * num, height: image.size.height * num)
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bibit"), size: size)
        self.physicsBody?.categoryBitMask = CollisionTypes.plant.rawValue
        self.physicsBody?.contactTestBitMask = CollisionTypes.droplets.rawValue | CollisionTypes.waterSphere.rawValue
        
        self.zPosition = 1
        
        self.physicsBody?.isDynamic = false
        
        self.addChild(image)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
