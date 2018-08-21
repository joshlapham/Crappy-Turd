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
    var turdSprites: [SKTexture] = [] // TODO: review this
    var turd: SKSpriteNode?
    var repeatActionTurd = SKAction()
    
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
        
        // Set up the turd atlas for animation
        self.turdSprites.append(self.turdAtlas.textureNamed("poo-down"))
        self.turdSprites.append(self.turdAtlas.textureNamed("poo-mid"))
        self.turdSprites.append(self.turdAtlas.textureNamed("poo-up"))
        
        self.turd = self.createTurd()
        guard let turd = self.turd else { return }
        self.addChild(turd)
        
        // Prepare to animate the turd and repeat the animation forever
        let animateTurd = SKAction.animate(with: self.turdSprites, timePerFrame: 0.1)
        self.repeatActionTurd = SKAction.repeatForever(animateTurd)
        
        // Add logo
        self.createLogo()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isGameStarted == false {
            // 1
            self.isGameStarted = true
            self.turd?.physicsBody?.affectedByGravity = true
            // TODO: create 'Pause' button here
            
            // 2
            // Remove logo
            self.logoImage.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImage.removeFromParent()
            })
            
            // TODO: remove tap to play button
            
            // 3
            self.turd?.run(self.repeatActionTurd)
            
            // TODO: add pillars here
            
            self.turd?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.turd?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            
        } else {
            // 4
            if self.isDead == false {
                self.turd?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.turd?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
        }
    }
}

// MARK: - Helper methods
extension GameScene {
    func createTurd() -> SKSpriteNode {
        // 1
        let turd = SKSpriteNode(texture: self.turdAtlas.textureNamed("poo-down"))
        turd.size = CGSize(width: 50, height: 50)
        turd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        // 2
        turd.physicsBody = SKPhysicsBody(circleOfRadius: turd.size.width / 2)
        turd.physicsBody?.linearDamping = 1.1
        turd.physicsBody?.restitution = 0
        
        // 3
        turd.physicsBody?.categoryBitMask = CollisionBitMask.turdCategory
        turd.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        turd.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.bacteriaCategory | CollisionBitMask.groundCategory
        
        // 4
        turd.physicsBody?.affectedByGravity = false
        turd.physicsBody?.isDynamic = true
        
        return turd
    }
    
    func createLogo() {
        self.logoImage = SKSpriteNode()
        self.logoImage = SKSpriteNode(imageNamed: "title-crappyturd")
        self.logoImage.size = CGSize(width: 376, height: 147)
        self.logoImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        self.logoImage.setScale(0.5)
        self.addChild(self.logoImage)
        self.logoImage.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
}
