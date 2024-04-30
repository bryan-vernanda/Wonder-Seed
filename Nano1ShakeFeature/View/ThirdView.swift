//
//  ThirdView.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 26/04/24.
//

import SwiftUI
import SpriteKit

//class GameScenes: SKScene{
//    override func didMove(to view: SKView) {
//        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        
//        let box = SKSpriteNode(imageNamed: "Sphere.png")
//        box.position = location ?? CGPoint(x: 0, y: 0)
//        box.physicsBody = SKPhysicsBody(circleOfRadius: box.size.width/2)
//        addChild(box)
//    }
//}
//
//struct ThirdView: View {
//    var scenes: SKScene{
//        let scene = GameScenes()
//        scene.size = CGSize(width: 300, height: 400)
//        scene.scaleMode = .fill
//        return scene
//    }
//    
//    var body: some View {
//        Text("hello")
//        SpriteView(scene: scenes)
//            .frame(width: 300, height: 400)
//    }
//}
//
//#Preview {
//    ThirdView()
//}
