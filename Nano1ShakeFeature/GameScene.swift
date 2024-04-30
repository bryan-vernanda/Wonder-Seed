//
//  GameScene.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 30/04/24.
//

import SwiftUI
import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    //2^n value, harus, biar ga collide
    case player = 1
    case wall = 2
    case droplets = 4
    case plant = 8
//    case floor = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager: CMMotionManager?
    private var lastUpdateTime : TimeInterval = 0
    private var currentRainDropSpawnTime : TimeInterval = 0
    private var rainDropSpawnRate : TimeInterval = 0.5
    var player = Player(image: SKSpriteNode(imageNamed: "penyiram"))
    var player2 = SKSpriteNode(imageNamed: "bucketPupuk")
    
    var plant = Plant(image: SKSpriteNode(imageNamed: "bibit"), 0.1, CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3 - 24), 0.1)
    var plant1p5 = Plant(image: SKSpriteNode(imageNamed: "growth1p5"), 1, CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3 - 5), 1)
    var plant2 = Plant(image: SKSpriteNode(imageNamed: "growth1"), 1, CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 - 115), 1)
    var plant2p5 = Plant(image: SKSpriteNode(imageNamed: "growth2p5"), 1, CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 - 83), 1)
    var plant3 = Plant(image: SKSpriteNode(imageNamed: "growth2"), 1, CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 - 70), 1)
    var plant3p5 = Plant(image: SKSpriteNode(imageNamed: "growth3p5"), 1, CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 - 58), 1)
    var plant4 = Plant(image: SKSpriteNode(imageNamed: "growth3"), 1, CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 - 56), 1)
    
    private var isDragging = false
    var backgroundNode = SKSpriteNode()
    var mapSize: CGSize = CGSize()
    @Published var fertilizerProgress: CGFloat = 0
    @Published var progressBar: CGFloat = 0
    
    override func didMove(to view: SKView) {
        
        self.backgroundNode = SKSpriteNode(texture: SKTexture(imageNamed: "Background"))
        self.backgroundNode.zPosition = -1
        self.mapSize = backgroundNode.size
        self.size = mapSize
        
        self.backgroundColor = .gray
        backgroundNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(backgroundNode)
        
        var worldFrame = frame
        worldFrame.origin.x += 30
        worldFrame.origin.y += 20
        worldFrame.size.height -= 40
        worldFrame.size.width -= 55
        
        let wall = WallGame(worldFrame: worldFrame)
        
//        check border wall
//        let edgeNode = SKShapeNode(rect: worldFrame)
//        edgeNode.strokeColor = .red
//        edgeNode.lineWidth = 5
//        edgeNode.physicsBody = physicsBody
//        addChild(edgeNode)
        
        self.addChild(wall)
        
        player.updatePosition(point: CGPoint(x: UIScreen.main.bounds.width/5, y: UIScreen.main.bounds.height/6))
        
        self.addChild(player)
        self.addChild(plant)
        
        self.physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)

        if let point = touchPoint {
          player.setDestination(destination: point)
            player.physicsBody?.isDynamic = false
          isDragging = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)

        if let point = touchPoint {
          player.setDestination(destination: point)
            player.physicsBody?.isDynamic = false
          isDragging = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDragging = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        // Initialize _lastUpdateTime if it has not already been
        if(isDragging) {
            if (self.lastUpdateTime == 0) {
              self.lastUpdateTime = currentTime
            }

            // Calculate time since last update
            let dt = currentTime - self.lastUpdateTime

            // Update the Spawn Timer
            currentRainDropSpawnTime += dt

            let posisi = player.update(deltaTime: dt)
            
            if currentRainDropSpawnTime > rainDropSpawnRate {
                currentRainDropSpawnTime = 0
                
                if progressBar < 10 {
                    spawnRain(image: SKSpriteNode(imageNamed: "air"), posisi)
                } else {
                    spawnRain(image: SKSpriteNode(imageNamed: "pupuk"), posisi)
                }
            }

            self.lastUpdateTime = currentTime
        }
    
    }
    
    func spawnRain(image: SKSpriteNode, _ posisi: CGPoint) {
        let droplets = Droplets(image: image, posisi)
        self.addChild(droplets)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let scaleUpAction = SKAction.scale(to: 1.1, duration: 0.1)
        let scaleDownAction = SKAction.scale(to: 1.0, duration: 0.1)
        let springAction = SKAction.sequence([scaleUpAction, scaleDownAction])
        
        if (contact.bodyA.categoryBitMask == CollisionTypes.droplets.rawValue) && (contact.bodyB.categoryBitMask == CollisionTypes.wall.rawValue) {
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        } else if (contact.bodyA.categoryBitMask == CollisionTypes.wall.rawValue) && (contact.bodyB.categoryBitMask == CollisionTypes.droplets.rawValue) {
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
        }
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if (contact.bodyA.categoryBitMask == CollisionTypes.plant.rawValue) && (contact.bodyB.categoryBitMask == CollisionTypes.droplets.rawValue){
            let move = SKAction.move(to: nodeA.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let sequence = SKAction.sequence([move, scale])
            contact.bodyB.node?.run(sequence)
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
            
            // to handle water to the plant event
            if progressBar < 10.0 {
                progressBar += 1.0
                if(progressBar == 6) {
                    plant.removeFromParent()
                    plant1p5.run(springAction)
                    self.addChild(plant1p5)
                } else if(progressBar == 10) {
                    player.removeAllChildren()
                    player2.run(springAction)
                    player.addChild(player2)
                    plant1p5.removeFromParent()
                    plant2.run(springAction)
                    self.addChild(plant2)
                }
            } else if fertilizerProgress < 10 {
                fertilizerProgress += 1.0
                if(fertilizerProgress == 6) {
                    plant2.removeFromParent()
                    plant2p5.run(springAction)
                    self.addChild(plant2p5)
                } else if(fertilizerProgress == 10) {
                    plant2p5.removeFromParent()
                    plant3.run(springAction)
                    self.addChild(plant3)
                }
            }
            
        } else if (contact.bodyA.categoryBitMask == CollisionTypes.droplets.rawValue) && (contact.bodyB.categoryBitMask == CollisionTypes.plant.rawValue){
            let move = SKAction.move(to: nodeB.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let sequence = SKAction.sequence([move, scale])
            contact.bodyA.node?.run(sequence)
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
            
            // to handle water to the plant event
            if progressBar < 10.0 {
                progressBar += 1.0
                if(progressBar == 6) {
                    plant.removeFromParent()
                    plant1p5.run(springAction)
                    self.addChild(plant1p5)
                } else if(progressBar == 10) {
                    player.removeAllChildren()
                    player2.run(springAction)
                    player.addChild(player2)
                    plant1p5.removeFromParent()
                    plant2.run(springAction)
                    self.addChild(plant2)
                }
            } else if fertilizerProgress < 10 {
                fertilizerProgress += 1.0
                if(fertilizerProgress == 6) {
                    plant2.removeFromParent()
                    plant2p5.run(springAction)
                    self.addChild(plant2p5)
                } else if(fertilizerProgress == 10) {
                    plant2p5.removeFromParent()
                    plant3.run(springAction)
                    self.addChild(plant3)
                }
            }
            
        }
    }
}

struct contextView: View {
    var gameScene: GameScene
    @State var progressBar:CGFloat = 0
    @State var fertilizerProgress: CGFloat = 0
    @Environment (\.dismiss) var dismiss
    
    init() {
        gameScene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        gameScene.scaleMode = .fill
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
                .onReceive(gameScene.$progressBar, perform: { value in
                    self.progressBar = value
                })
                .onReceive(gameScene.$fertilizerProgress, perform: { value in
                    self.fertilizerProgress = value
                })
            
            WaterBar(current: $progressBar, width: 177, height: 16)
                .position(CGPoint(x: 130, y: 80))
            
            fertilizerBar(current: $fertilizerProgress, width: 177, height: 16)
                .position(CGPoint(x: 130, y: 120))
            
            Button(action: {
                dismiss()
                print("Success")
            }) {
                Image(systemName: "chevron.backward.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color("P-700"))
                    .frame(width: 30, height: 30)
            }.position(CGPoint(x: 50, y: 20))
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    contextView()
}
