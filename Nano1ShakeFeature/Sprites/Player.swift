//
//  Player.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 29/04/24.
//

import Foundation
import SpriteKit

class Player: SKNode {
    private var destination : CGPoint!
    private let easing : CGFloat = 0.1
    
    init(image: SKSpriteNode) {
        super.init()
//        let player = Player(imageNamed: "siram")
        self.zPosition = 1
        
//        let path = UIBezierPath()
//        path.move(to: CGPoint())
//        path.addLine(to: CGPoint(x: -player.size.width / 2 - 30, y: 0))
//        path.addLine(to: CGPoint(x: 0, y: player.size.height / 2))
//        path.addLine(to: CGPoint(x: player.size.width / 2 + 30, y: 0))
        
        self.setScale(0.5)
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "penyiram"), size: CGSize(width: image.size.width * 0.5, height: image.size.height * 0.5))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        self.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
//        player.physicsBody?.restitution = 0.9
        
        self.addChild(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updatePosition(point : CGPoint) {
        position = point
        destination = point
    }
    
    public func setDestination(destination : CGPoint) {
        self.destination = destination
    }
    
    public func update(deltaTime: TimeInterval) -> CGPoint {
        let distance = sqrt(pow((destination.x - position.x), 2) + pow((destination.y - position.y), 2))
        
        if (distance > 1) {
            let directionX = (destination.x - position.x)
            let directionY = (destination.y - position.y)
            
            position.x += directionX * easing
            position.y += directionY * easing
        } else {
            position = destination
        }
        
        return CGPoint(x: position.x + 60, y: position.y - 40)
    }
}
