//
//  GameScene.swift
//  Crappy Turd
//
//  Created by jl on 21/8/18.
//  Copyright © 2018 Josh Lapham. All rights reserved.
//

import SpriteKit

// TODO: this probably isn't the right way of doing things with watchOS
#if !os(watchOS)
import GameplayKit
#endif

class GameScene: SKScene, SKPhysicsContactDelegate {
    var isGameStarted: Bool = false
    var isDead: Bool = false
    
    var score: Int = 0
    
    var scoreLabel: SKLabelNode = SKLabelNode()
    
    func createScoreLabel(score: Int) -> SKLabelNode {
        let label = SKLabelNode()
        label.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        label.text = "\(score)"
        label.zPosition = 5
        label.fontSize = 50
        label.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        
        label.addChild(scoreBg)
        
        return label
    }
    
    var highScoreLabel: SKLabelNode = SKLabelNode()
    
    func createHighScoreLabel(score: Int?) -> SKLabelNode {
        let label = SKLabelNode()
        label.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        
        if let highScore = score {
            label.text = "High Score: \(highScore)"
        } else {
            label.text = "High Score: 0"
        }
        
        label.zPosition = 5
        label.fontSize = 15
        label.fontName = "Helvetica-Bold"
        
        return label
    }
    
    var tapToPlayLabel: SKLabelNode = SKLabelNode()
    
    func createTapToPlayLabel() -> SKLabelNode {
        let label = SKLabelNode()
        label.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        label.text = "Tap to Play"
        label.fontColor = UIColor.white
        label.zPosition = 5
        label.fontSize = 20
        label.fontName = "HelveticaNeue"
        
        return label
    }
    
    var restartButton: SKSpriteNode = SKSpriteNode()
    
    func createRestartButton() -> SKSpriteNode {
        let button = SKSpriteNode(imageNamed: "title-gameover")
        button.size = CGSize(width: 764 / 3, height: 193 / 3) // TODO: need to set size dynamically
        button.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        button.zPosition = 6
        button.setScale(0)
        button.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        return button
    }
    
    var pauseButton: SKSpriteNode?
    
    var logoImage: SKSpriteNode = SKSpriteNode()
    
    func createLogoImage() -> SKSpriteNode {
        let logoImage = SKSpriteNode(imageNamed: "title-crappyturd")
        logoImage.size = CGSize(width: 576 / 2, height: 347 / 2) // TODO: need to set size dynamically somehow
        logoImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        logoImage.setScale(0.5)
        logoImage.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        return logoImage
    }
    
    var wallPair: SKNode = SKNode()
    
    func createWallPair() -> SKNode {
        // TODO: randomise image selection here, to use rest of 'bacteria' image assets
        let flowerNode = SKSpriteNode(imageNamed: "bacteria-1")
        flowerNode.size = CGSize(width: 21, height: 21)
        flowerNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        flowerNode.physicsBody = SKPhysicsBody(rectangleOf: flowerNode.size)
        flowerNode.physicsBody?.affectedByGravity = false
        flowerNode.physicsBody?.isDynamic = false
        flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.bacteriaCategory
        flowerNode.physicsBody?.collisionBitMask = 0
        flowerNode.physicsBody?.contactTestBitMask = CollisionBitMask.turdCategory
        flowerNode.color = SKColor.blue
        
        let wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "pipe-1")
        let btmWall = SKSpriteNode(imageNamed: "pipe-2")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 420)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 420)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.turdCategory
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.turdCategory
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        btmWall.physicsBody?.collisionBitMask = CollisionBitMask.turdCategory
        btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.turdCategory
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(Double.pi)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        let randomPosition = self.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y +  randomPosition
        wallPair.addChild(flowerNode)
        
        wallPair.run(self.moveAndRemove)
        
        return wallPair
    }
    
    var moveAndRemove: SKAction = SKAction()
    
    // Create the turd atlas for animation
    let turdAtlas = SKTextureAtlas(named: "player")
    var turdSprites: [SKTexture] = []
    var repeatActionTurd: SKAction = SKAction()
    
    var turd: SKSpriteNode = SKSpriteNode()
    
    func createTurd() -> SKSpriteNode {
        let turd = SKSpriteNode(texture: self.turdAtlas.textureNamed("poo-down"))
        turd.size = CGSize(width: 50, height: 50)
        turd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        turd.physicsBody = SKPhysicsBody(circleOfRadius: turd.size.width / 2)
        turd.physicsBody?.linearDamping = 1.1
        turd.physicsBody?.restitution = 0
        
        turd.physicsBody?.categoryBitMask = CollisionBitMask.turdCategory
        turd.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        turd.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.bacteriaCategory | CollisionBitMask.groundCategory
        
        turd.physicsBody?.affectedByGravity = false
        turd.physicsBody?.isDynamic = true
        
        return turd
    }
    
    func createScene() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.turdCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.turdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        
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
        self.addChild(self.turd)
        
        // Prepare to animate the turd and repeat the animation forever
        let animateTurd = SKAction.animate(with: self.turdSprites, timePerFrame: 0.1)
        self.repeatActionTurd = SKAction.repeatForever(animateTurd)
        
        // Add score labels
        self.scoreLabel = self.createScoreLabel(score: self.score)
        self.addChild(self.scoreLabel)
        
        self.highScoreLabel = self.createHighScoreLabel(score: UserDefaults.standard.integer(forKey: "HighScore"))
        self.addChild(self.highScoreLabel)
        
        // Add logo image
        self.logoImage = self.createLogoImage()
        self.addChild(self.logoImage)
        
        // Add 'Tap to Play' label
        self.tapToPlayLabel = self.createTapToPlayLabel()
        self.addChild(self.tapToPlayLabel)
    }
    
    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
        self.isDead = false
        self.isGameStarted = false
        self.score = 0
        self.createScene()
    }
    
    // MARK: SKScene
    override func didMove(to view: SKView) {
        self.createScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard self.isGameStarted == true else { return }
        guard self.isDead == false else { return }
        
        enumerateChildNodes(withName: "background") { (node, error) in
            guard let bg = node as? SKSpriteNode else { return }
            
            bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
            
            if bg.position.x <= -bg.size.width {
                bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        // TODO: clean up this mess somehow
        if firstBody.categoryBitMask == CollisionBitMask.turdCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.turdCategory || firstBody.categoryBitMask == CollisionBitMask.turdCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.turdCategory {
            enumerateChildNodes(withName: "wallPair", using: { (node, error ) in
                node.speed = 0
                self.removeAllActions()
            })
            
            if self.isDead == false {
                self.isDead = true
                // Create Restart button
                self.restartButton = self.createRestartButton()
                self.addChild(self.restartButton)
                
                // TODO: remove Pause button here
                
                self.turd.removeAllActions()
            }
            
        } else if firstBody.categoryBitMask == CollisionBitMask.turdCategory && secondBody.categoryBitMask == CollisionBitMask.bacteriaCategory {
            self.score += 1
            self.scoreLabel.text = "\(self.score)"
            secondBody.node?.removeFromParent()
            
        } else if firstBody.categoryBitMask == CollisionBitMask.bacteriaCategory && secondBody.categoryBitMask == CollisionBitMask.turdCategory {
            self.score += 1
            self.scoreLabel.text = "\(self.score)"
            firstBody.node?.removeFromParent()
        }
    }
}

extension GameScene {
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat {
        return self.random() * (max - min) + min
    }
}

extension GameScene {
    func determineState() {
        if self.isGameStarted == false {
            self.isGameStarted = true
            self.turd.physicsBody?.affectedByGravity = true
            
            // TODO: create 'Pause' button here
            
            // Remove logo image
            self.logoImage.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImage.removeFromParent()
            })
            
            // Remove 'Tap to Play' label
            self.tapToPlayLabel.removeFromParent()
            
            self.turd.run(self.repeatActionTurd)
            
            // Add pipes/pillars
            let spawn = SKAction.run({
                () in
                self.wallPair = self.createWallPair()
                self.addChild(self.wallPair)
            })
            
            let delay = SKAction.wait(forDuration: 1.5)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + self.wallPair.frame.width)
            let movePillars = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePillars = SKAction.removeFromParent()
            self.moveAndRemove = SKAction.sequence([movePillars, removePillars])
            self.wallPair.run(self.moveAndRemove)
            
            self.turd.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.turd.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            
        } else {
            if self.isDead == false {
                self.turd.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.turd.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
        }
    }
    
    func handleEvent(location: CGPoint) {
        // Restart button toggle
        if self.isDead == true {
            if self.restartButton.contains(location) == true {
                // TODO: refactor this to extension on `UserDefaults`
                // TODO: refactor to use App Constants for keys
                if UserDefaults.standard.object(forKey: "HighScore") != nil {
                    let highScore = UserDefaults.standard.integer(forKey: "HighScore")
                    
                    if highScore < self.score {
                        UserDefaults.standard.set(self.score, forKey: "HighScore")
                    }
                } else {
                    UserDefaults.standard.set(0, forKey: "HighScore")
                }
                
                self.restartScene()
            }
            
        } else {
            // Pause button toggle
            if self.pauseButton?.contains(location) == true {
                if self.isPaused == false {
                    self.isPaused = true
                    // TODO: update Pause button texture image here
                } else {
                    self.isPaused = false
                    // TODO: update Pause button texture image here
                }
            }
        }
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.determineState()
        
        for touch in touches {
            let location = touch.location(in: self)
            self.handleEvent(location: location)
        }
    }
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {
    override func mouseUp(with event: NSEvent) {
        self.determineState()
        
        let location = event.location(in: self)
        self.handleEvent(location: location)
    }
}
#endif
