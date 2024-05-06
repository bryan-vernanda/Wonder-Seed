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
    case waterSphere = 16
    case itemDrop = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager: CMMotionManager?
    var playerRemoved = false
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
    
    var itemApple = ItemDrop(image: SKSpriteNode(imageNamed: "apple"))
    
    private var isDragging = false
    var backgroundNode = SKSpriteNode()
    var mapSize: CGSize = CGSize()
    @Published var fertilizerProgress: CGFloat = 0
    @Published var progressBar: CGFloat = 0
    @Published var statusDirectPage: Bool = false
    
    override func didMove(to view: SKView) {
        
        self.backgroundNode = SKSpriteNode(texture: SKTexture(imageNamed: "Background"))
        self.backgroundNode.zPosition = -1
        self.mapSize = backgroundNode.size
        self.size = mapSize
        
        self.backgroundColor = .gray
        backgroundNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(backgroundNode)
        
//                var worldFrame = frame
//                worldFrame.origin.x -= 0.5
//                worldFrame.origin.y += 0.5
//                worldFrame.size.height -= 40
        //        worldFrame.size.width -= 80
        
        let wall = WallGame(worldFrame: frame)
        
//                check border wall
//                let path = UIBezierPath(roundedRect: frame, cornerRadius: 60)
//                let edgeNode = SKShapeNode(path: path.cgPath)
//                edgeNode.strokeColor = .red
//                edgeNode.lineWidth = 5
//                edgeNode.physicsBody = physicsBody
//                addChild(edgeNode)
        
        self.addChild(wall)
        
        player.updatePosition(point: CGPoint(x: UIScreen.main.bounds.width/5, y: UIScreen.main.bounds.height/6))
        
        self.addChild(player)
        self.addChild(plant)
        
        self.physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(playerRemoved == false) {
            let touchPoint = touches.first?.location(in: self)
            if let point = touchPoint {
                player.setDestination(destination: point)
                player.physicsBody?.isDynamic = false
                isDragging = true
            }
        } else {
            guard let touch = touches.first else { return }
            let touchLocation = touch.location(in: self) //kalo ini jadi CGPoint, tapi kenapa yang diatas touchPoint bukan CGPoint? ga ngerti dah aowkoakw
            
            let touchedNodes = nodes(at: touchLocation)
            for node in touchedNodes {
                if node is ItemDrop {
                    statusDirectPage = true
                }
            }
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
        if let accelerometerData = motionManager?.accelerometerData {
            self.physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 7, dy: accelerometerData.acceleration.y * 7)
        }
        
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if(isDragging && playerRemoved == false) {
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
                    spawnRain(true ,image: SKSpriteNode(imageNamed: "air"), posisi)
                } else {
                    spawnRain(false ,image: SKSpriteNode(imageNamed: "pupuk"), posisi)
                }
            }
            
            self.lastUpdateTime = currentTime
        }
        
    }
    
    func spawnRain(_ num: Bool ,image: SKSpriteNode, _ posisi: CGPoint) {
        let droplets = Droplets(num ,image: image, posisi)
        self.addChild(droplets)
    }
    
    func spawnWater(_ num: Bool, _ posisi: CGPoint) {
        if (num) {
            let water = WaterSphere(num, image: SKSpriteNode(imageNamed: "waterSphere"), posisi)
            self.addChild(water)
        } else {
            let water = WaterSphere(num, image: SKSpriteNode(imageNamed: "pupukSphere"), posisi)
            self.addChild(water)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let scaleUpAction = SKAction.scale(to: 1.1, duration: 0.1)
        let scaleDownAction = SKAction.scale(to: 1.0, duration: 0.1)
        let springAction = SKAction.sequence([scaleUpAction, scaleDownAction])
        
        if (contact.bodyA.categoryBitMask == CollisionTypes.droplets.rawValue) && (contact.bodyB.categoryBitMask == CollisionTypes.wall.rawValue) {
            
            let dropletsNode = contact.bodyA.node as? Droplets
            spawnWater(dropletsNode?.checkImage() ?? false, CGPoint(x: contact.contactPoint.x, y: contact.contactPoint.y + 2))
            
            let move = SKAction.move(to: contact.contactPoint, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let sequence = SKAction.sequence([move, scale])
            
            contact.bodyA.node?.run(sequence)
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
            
        } else if (contact.bodyA.categoryBitMask == CollisionTypes.wall.rawValue) && (contact.bodyB.categoryBitMask == CollisionTypes.droplets.rawValue) {
            
            let move = SKAction.move(to: contact.contactPoint, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let sequence = SKAction.sequence([move, scale])
            
            let dropletsNode = contact.bodyB.node as? Droplets
            spawnWater(dropletsNode?.checkImage() ?? false, CGPoint(x: contact.contactPoint.x, y: contact.contactPoint.y + 2))
            
            contact.bodyB.node?.run(sequence)
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
        }
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        let move = SKAction.move(to: nodeA.position, duration: 0.25)
        let move2 = SKAction.move(to: nodeB.position, duration: 0.25)
        let scale = SKAction.scale(to: 0.0001, duration: 0.25)
        let sequenceA = SKAction.sequence([move, scale])
        let sequenceB = SKAction.sequence([move2, scale])

        var checkValueWater: Bool = true
        var checkValueDrop: Bool = true
        
        if ((contact.bodyA.categoryBitMask == CollisionTypes.plant.rawValue) && (contact.bodyB.categoryBitMask == CollisionTypes.droplets.rawValue)) || ((contact.bodyA.categoryBitMask == CollisionTypes.plant.rawValue) && (contact.bodyB.categoryBitMask == CollisionTypes.waterSphere.rawValue)) {
            
            if (contact.bodyB.categoryBitMask == CollisionTypes.waterSphere.rawValue) {
                let waterSphereNode = contact.bodyB.node as? WaterSphere
                checkValueWater = waterSphereNode?.checkWater() ?? false
            } else if (contact.bodyB.categoryBitMask == CollisionTypes.droplets.rawValue) {
                let dropletsNode = contact.bodyB.node as? Droplets
                checkValueDrop = dropletsNode?.checkImage() ?? false
            }
            
            contact.bodyB.node?.run(sequenceA)
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
            
            // to handle water to the plant event
            if (progressBar < 10.0) && (checkValueWater == true || checkValueWater == true)  {
                progressBar += 1.0
                if(progressBar == 3.0) {
                    plant.removeFromParent()
                    plant1p5.run(springAction)
                    self.addChild(plant1p5)
                } else if(progressBar == 6.0) {
                    plant1p5.removeFromParent()
                    plant2.run(springAction)
                    self.addChild(plant2)
                } else if(progressBar == 10.0) {
                    player.removeAllChildren()
                    player2.run(springAction)
                    player.addChild(player2)
                    plant2.removeFromParent()
                    plant2p5.run(springAction)
                    self.addChild(plant2p5)
                }
            } else if (fertilizerProgress < 10.0) && (checkValueWater == false || checkValueDrop == false) {
                fertilizerProgress += 1.0
                if(fertilizerProgress == 3.0) {
                    plant2p5.removeFromParent()
                    plant3.run(springAction)
                    self.addChild(plant3)
                } else if(fertilizerProgress == 6.0) {
                    plant3.removeFromParent()
                    plant3p5.run(springAction)
                    self.addChild(plant3p5)
                } else if(fertilizerProgress == 10.0) {
                    plant3p5.removeFromParent()
                    plant4.run(springAction)
                    self.addChild(plant4)
                    player.removeFromParent()
                    playerRemoved = true
                    self.addChild(itemApple)
                }
            }
            
        } else if ((contact.bodyA.categoryBitMask == CollisionTypes.droplets.rawValue) && (contact.bodyB.categoryBitMask == CollisionTypes.plant.rawValue)) || ((contact.bodyA.categoryBitMask == CollisionTypes.waterSphere.rawValue) && (contact.bodyB.categoryBitMask == CollisionTypes.plant.rawValue)) {
            
            if (contact.bodyA.categoryBitMask == CollisionTypes.waterSphere.rawValue) {
                let waterSphereNode = contact.bodyA.node as? WaterSphere
                checkValueWater = waterSphereNode?.checkWater() ?? false
            } else if (contact.bodyA.categoryBitMask == CollisionTypes.droplets.rawValue) {
                let dropletsNode = contact.bodyA.node as? Droplets
                checkValueDrop = dropletsNode?.checkImage() ?? false
            }
            
            contact.bodyA.node?.run(sequenceB)
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
            
            // to handle water to the plant event
            if (progressBar < 10.0) && (checkValueWater == true || checkValueWater == true)  {
                progressBar += 1.0
                if(progressBar == 3.0) {
                    plant.removeFromParent()
                    plant1p5.run(springAction)
                    self.addChild(plant1p5)
                } else if(progressBar == 6.0) {
                    plant1p5.removeFromParent()
                    plant2.run(springAction)
                    self.addChild(plant2)
                } else if(progressBar == 10.0) {
                    player.removeAllChildren()
                    player2.run(springAction)
                    player.addChild(player2)
                    plant2.removeFromParent()
                    plant2p5.run(springAction)
                    self.addChild(plant2p5)
                }
            } else if (fertilizerProgress < 10.0) && (checkValueWater == false || checkValueDrop == false) {
                fertilizerProgress += 1.0
                if(fertilizerProgress == 3.0) {
                    plant2p5.removeFromParent()
                    plant3.run(springAction)
                    self.addChild(plant3)
                } else if(fertilizerProgress == 6.0) {
                    plant3.removeFromParent()
                    plant3p5.run(springAction)
                    self.addChild(plant3p5)
                } else if(fertilizerProgress == 10.0) {
                    plant3p5.removeFromParent()
                    plant4.run(springAction)
                    self.addChild(plant4)
                    player.removeFromParent()
                    playerRemoved = true
                    self.addChild(itemApple)
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
