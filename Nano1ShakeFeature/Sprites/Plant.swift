//
//  Plant.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 29/04/24.
//

import Foundation
import SpriteKit

class Plant: SKNode {
    init(image: SKSpriteNode) {
        super.init()
        
//        let tumbuhan = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
//        image.size = CGSize(width: 100, height: 86)
        self.setScale(0.1)
//        self.setScale(1)
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bibit"), size: CGSize(width: image.size.width * 0.1, height: image.size.height * 0.1))
//        self.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 - 120)
        self.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3 - 30)
        
        self.physicsBody?.categoryBitMask = CollisionTypes.plant.rawValue
        self.physicsBody?.contactTestBitMask = CollisionTypes.droplets.rawValue
        
        self.physicsBody?.isDynamic = false
        
        self.addChild(image)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
