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
        startButton.isHidden = true
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
    
        scene = GameScene(size: skView.bounds.size)
        scene.delegateGame = self
        scene.scaleMode = .aspectFill
    
        skView.presentScene(scene)
        
        scene.startGame()
    }
    
    @IBAction func clearGame(sender: AnyObject) {
        scene = nil
    }
    
    func gameDidEndSuccess(gamescene: GameScene) {
        startButton.isHidden = false
    }
    
    func gameDidEndFailed(gamescene: GameScene) {
        startButton.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.isHidden = false
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
