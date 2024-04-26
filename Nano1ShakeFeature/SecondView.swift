//
//  SecondView.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 25/04/24.
//

import SwiftUI
import SpriteKit

class GameScene: SKScene{
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let box = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        addChild(box)
    }
}

struct SecondView: View {
    var scene: SKScene{
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 400)
        scene.scaleMode = .fill
        return scene
    }
    //DO NOT DELETE
//    @State var displaySheet = false
//    @State var shake = false
    
    var body: some View {
        //DO NOT DELETE
        //
//        Text("Shake Me")
//            .font(.title)
//            .onTapGesture {
//                shake = true
//            }
//            .shake($shake) {
//                displaySheet = true
//            }
//            .sheet(isPresented: $displaySheet) {
//                Text("Another view!")
//            }
//            .navigationBarBackButtonHidden()
    }
}

#Preview {
    SecondView()
}
