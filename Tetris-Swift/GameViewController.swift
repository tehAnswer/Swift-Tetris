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
    var logic: GameLogic!

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.tick = didTick
        
        logic = GameLogic()
        logic.beginGame()
        
        skView.presentScene(scene)
        
        scene.addPreviewShapeToScene(logic.nextShape!) {
            self.logic.nextShape?.moveTo(StartingColumn, row: StartingRow)
            self.scene.movePreviewShape(self.logic.nextShape!) {
                let nextShapes = self.logic.newShape()
                self.scene.startTicking()
                self.scene.addPreviewShapeToScene(nextShapes.nextShape!) {}
            }
        }
    }
    
    func didTick() {
        logic.fallingShape?.lowerShapeByOneRow()
        scene.redrawShape(logic.fallingShape!, completion: {})
    }

   
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
