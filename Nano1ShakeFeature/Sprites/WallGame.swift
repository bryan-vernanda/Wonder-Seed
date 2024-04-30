//
//  WallGame.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 29/04/24.
//

import Foundation
import SpriteKit

class WallGame: SKNode {
    init(worldFrame: CGRect) {
        super.init()
        
        //set the size and position of the node
//        self.position = CGPoint(x: 20, y: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        
        self.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        self.physicsBody?.contactTestBitMask = CollisionTypes.droplets.rawValue
        self.physicsBody?.collisionBitMask = CollisionTypes.player.rawValue
        
        //apply a physics body to the node
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
