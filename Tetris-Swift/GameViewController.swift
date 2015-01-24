//
//  GameViewController.swift
//  Tetris-Swift
//
//  Created by Sergio Gijón on 24/1/15.
//  Copyright (c) 2015 Sergio Gijón. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {
    
    // suffix ! avoids forced in-line or during the initializer instantiation
    var scene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }

   
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
