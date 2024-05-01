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
        
//        let tumbuhan = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
//        image.size = CGSize(width: 100, height: 86)
        self.setScale(scale)
//        self.setScale(1)
        
        self.position = pos
        
        let size = CGSize(width: image.size.width * num, height: image.size.height * num)
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bibit"), size: size)

//        self.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 - 120)
        
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
