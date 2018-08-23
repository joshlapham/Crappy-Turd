//
//  GameViewController.swift
//  Crappy Turd
//
//  Created by jl on 21/8/18.
//  Copyright © 2018 Josh Lapham. All rights reserved.
//

import Cocoa
import SpriteKit

class GameViewController: NSViewController {
    @IBOutlet var skView: SKView!
    
    // MARK: NSViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.skView {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            
            view.ignoresSiblingOrder = false
            view.showsFPS = false
            view.showsNodeCount = false
            view.presentScene(scene)
        }
    }
}
