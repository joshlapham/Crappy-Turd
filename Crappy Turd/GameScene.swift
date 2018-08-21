//
//  GameScene.swift
//  Crappy Turd
//
//  Created by jl on 21/8/18.
//  Copyright © 2018 Josh Lapham. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var isGameStarted: Bool = false
    var isDead: Bool = false
    
    var score: Int = 0
    
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var tapToPlayLabel = SKLabelNode()
    
    var restartButton = SKSpriteNode()
    var pauseButton = SKSpriteNode()
    var logoImage = SKSpriteNode()
    
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    
    // Create the turd atlas for animation
    let turdAtlas = SKTextureAtlas(named: "player")
    var birdSprites: [AnyObject] = [] // TODO: review this
    var bird = SKSpriteNode()
    var repeatActionBird = SKAction()
    
    func createScene() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.turdCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.turdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "background")
            background.anchorPoint = CGPoint(x: 0, y: 0)
            background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)! // TODO: don't force unwrap
            self.addChild(background)
        }
    }
    
    // MARK: SKScene
    override func didMove(to view: SKView) {
        self.createScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        guard self.isGameStarted == true else { return }
        guard self.isDead == false else { return }
        
        enumerateChildNodes(withName: "background") { (node, error) in
            let bg = node as! SKSpriteNode // TODO: don't force unwrap
            bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
            
            if bg.position.x <= -bg.size.width {
                bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
            }
        }
    }
}
