//
//  GameScene.swift
//  ZF
//
//  Created by Alexander Zorinov on 2023-11-12.
//

import SpriteKit
import GameplayKit
import AVFoundation

protocol GameDelegate {
    func gameDidEndSuccess(gamescene: GameScene)
    func gameDidEndFailed(gamescene: GameScene)
    func gameDidBegin(gamescene: GameScene)
    func setCurrentLevel(currentLevel: String)
    func showFeedbackScreen()
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var audioPlayer: AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        
       
    }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
