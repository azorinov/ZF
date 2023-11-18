//
//  GameViewController.swift
//  ZF
//
//  Created by Alexander Zorinov on 2023-11-12.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameDelegate {
    var scene: GameScene!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startGame(_ sender: Any) {
        
    }
    
    @IBAction func clearGame(sender: AnyObject) {
        scene = nil
    }
    
    func setCurrentLevel(currentLevel: String) {
        
    }
    
    func showFeedbackScreen() {
        
    }
    
    func gameDidEndSuccess(gamescene: GameScene) {
        startButton.isHidden = false
    }
    
    func gameDidEndFailed(gamescene: GameScene) {
        startButton.isHidden = false
    }
    
    func gameDidBegin(gamescene: GameScene) {
        startButton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.isHidden = false
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
