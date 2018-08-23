//
//  GameViewController.swift
//  Crappy Turd
//
//  Created by jl on 21/8/18.
//  Copyright © 2018 Josh Lapham. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            
            view.ignoresSiblingOrder = false
            view.showsFPS = false
            view.showsNodeCount = false
            view.presentScene(scene)
        }
    }
}
