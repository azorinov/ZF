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
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let stone1CategoryName = "stone1"
    let stone2CategoryName = "stone2"
    let stone3CategoryName = "stone3"
    let bottomCategoryName = "bottom"
    let stone1Category:UInt32 = 0x1 << 0                // 000000001
    let bottomCategory:UInt32 = 0x1 << 1                // 000000010
    let stone2Category:UInt32 = 0x1 << 2                // 000000100
    let stone3Category:UInt32 = 0x1 << 3                // 000001000
    
    //var timer = Timer()
    var timerSuccess = Timer()
    
    var delegateGame:GameDelegate?
    var contactCounter:Int = 0
    var gamePlaying:Bool = false
    
    var bottomPosition = CGPoint(x: 0.0, y: 0.0)
    var bottomSize = CGSizeMake(400.0, 1.0)
    var spriteBottom = SKSpriteNode()
    
    var stone1Position = CGPoint(x: 0.0, y: 0.0)
    var stone1Size = CGSizeMake(100.0, 56.0)
    var sprite1 = SKSpriteNode()
    
    var stone2Position = CGPoint(x: 0.0, y: 0.0)
    var stone2Size = CGSizeMake(90.0, 53.0)
    var sprite2 = SKSpriteNode()
    
    var stone3Position = CGPoint(x: 0.0, y: 0.0)
    var stone3Size = CGSizeMake(60.0, 43.0)
    var sprite3 = SKSpriteNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0, y: 1.0)
        
        let worldBorder = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = worldBorder
        self.physicsBody?.friction = 1
        self.physicsWorld.gravity = CGVectorMake(0, -3)
        self.physicsWorld.contactDelegate = self
        
        self.backgroundColor = Theme.normalBackground
        
        initilizationSprites()
    }
    
    func initilizationSprites() {
        initilizationSpriteBottom()
        initilizationSprite1()
        initilizationSprite2()
        initilizationSprite3()
    }
    
    func initilizationSpriteBottom() {
        bottomPosition.x = CGRectGetMidX(self.frame)
        bottomPosition.y = -(self.size.height - 2)
        spriteBottom.name = bottomCategoryName
        spriteBottom.position = bottomPosition
        spriteBottom.size = bottomSize
        self.addChild(spriteBottom)
        
        spriteBottom.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRectMake(-210, 0, 520, 1))
        spriteBottom.physicsBody?.isDynamic = false
        spriteBottom.physicsBody?.categoryBitMask = bottomCategory
        spriteBottom.physicsBody?.contactTestBitMask = bottomCategory
        spriteBottom.physicsBody?.affectedByGravity = false
        spriteBottom.physicsBody?.restitution = 0.1
    }
    
    func initilizationSprite1() {
        stone1Position.x = CGRectGetMidX(self.frame)
        stone1Position.y = -(self.size.height - 70)
        sprite1.name = stone1CategoryName
        sprite1.position = stone1Position
        sprite1.size = stone1Size
        sprite1.texture = SKTexture(image: UIImage(named:"stone1")!)
        self.addChild(sprite1)
        
        sprite1.physicsBody = SKPhysicsBody(circleOfRadius: sprite1.frame.size.height / 2)
        sprite1.physicsBody?.isDynamic = false
        sprite1.physicsBody?.categoryBitMask = stone1Category
        sprite1.physicsBody?.contactTestBitMask = stone1Category
        sprite1.physicsBody?.affectedByGravity = false
        sprite1.physicsBody?.friction = 0.4
        sprite1.physicsBody?.restitution = 0.1
    }
    
    func initilizationSprite2() {
        stone2Position.x = ImageUtil().randomBetweenNumbers()
        stone2Position.y = -sprite2.size.height - sprite3.size.height
        sprite2.name = stone2CategoryName
        sprite2.size = stone2Size
        sprite2.position = stone2Position
        sprite2.texture =  SKTexture(image: UIImage(named:"stone2")!)
        addChild(sprite2)
        
        sprite2.physicsBody = SKPhysicsBody(circleOfRadius: sprite2.frame.size.height / 3)
        sprite2.physicsBody?.categoryBitMask = stone2Category
        sprite2.physicsBody?.contactTestBitMask = stone2Category
        sprite2.physicsBody?.isDynamic = false
        sprite2.physicsBody?.affectedByGravity = false
    }
    
    func initilizationSprite3() {
        stone3Position.x = ImageUtil().randomBetweenNumbers()
        stone3Position.y = -sprite3.size.height
        
        sprite3.size = stone3Size
        sprite3.name = stone3CategoryName
        sprite3.position = stone3Position
        sprite3.texture =  SKTexture(image: UIImage(named:"stone3")!)
        addChild(sprite3)
        
        sprite3.physicsBody = SKPhysicsBody(circleOfRadius: sprite3.frame.size.height / 3)
        sprite3.physicsBody?.categoryBitMask = stone3Category
        sprite3.physicsBody?.contactTestBitMask = stone2Category
        sprite3.physicsBody?.isDynamic = false
        sprite3.physicsBody?.affectedByGravity = false
        sprite3.isHidden = true
    }
    
    /*** ANIMATION  */
    func startGame() {
        clearAll()
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        initilizationSprites()
        self.physicsWorld.gravity = CGVectorMake(0, -3)
        dropFirstStone()
    }
    
    func dropFirstStone() {
        sprite2.isHidden = false
        sprite2.position.x = ImageUtil().randomBetweenNumbers()
        sprite2.physicsBody = SKPhysicsBody(rectangleOf: sprite2.size)
        sprite2.physicsBody?.affectedByGravity = true
        sprite2.physicsBody?.isDynamic = true
    }
    
    func dropSecondStone() {
        sprite3.isHidden = false
        sprite3.physicsBody?.isDynamic = true
        sprite3.physicsBody?.affectedByGravity = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gamePlaying {
            handleRules()
        }
    }
    
    func handleRules() {
        if contactCounter == 0 && sprite2.position.y < sprite1.position.y {
            endFailedGame()
            return
        } else if contactCounter == 1 && sprite2.position.y < sprite1.position.y {
            endFailedGame()
            return
        } else if contactCounter == 1 && sprite3.position.y < sprite1.position.y {
            endFailedGame()
            return
        } else if contactCounter > 1 && sprite3.position.y < sprite1.position.y {
            endFailedGame()
            return
        } else if contactCounter > 1 && sprite3.position.y < sprite2.position.y {
            endFailedGame()
            return
        } else if contactCounter > 1 && sprite3.position.y < (sprite2.position.y - 20) {
            endFailedGame()
            return
        }
        
        if contactCounter > 1 && sprite3.position.y > sprite2.position.y {
            endGameSuccessfully()
        }
    }
    
    func adjustPositionForStoneOneAndTwo() {
        let range = sprite1.position.x - sprite2.position.x
        if range > 0 && range > 35 {
            sprite2.position.x = sprite1.position.x - 35
        } else if range > 0 && range > 30 {
            sprite2.position.x = sprite1.position.x - 30
        } else if range > 0 && range > 25 {
            sprite2.position.x = sprite1.position.x - 25
        } else if range > 0 && range > 20 {
            sprite2.position.x = sprite1.position.x - 20
        } else if range > 0 && range > 15 {
            sprite2.position.x = sprite1.position.x - 15
        } else if range < 0 && abs(range) > 35 {
            sprite2.position.x = sprite1.position.x + 35
        } else if range < 0 && abs(range) > 30 {
            sprite2.position.x = sprite1.position.x + 30
        } else if range < 0 && abs(range) > 25 {
            sprite2.position.x = sprite1.position.x + 25
        } else if range < 0 && abs(range) > 20 {
            sprite2.position.x = sprite1.position.x + 20
        } else if range < 0 && abs(range) > 15 {
            sprite2.position.x = sprite1.position.x + 15
        } else {
            sprite2.position.x = sprite1.position.x
        }
    }
    
    func adjustPositionForStonesTwoAndThree() {
        let range = sprite2.position.x - sprite3.position.x
        if range > 0 && range > 35 {
            sprite3.position.x = sprite2.position.x - 35
        } else if range > 0 && range > 30 {
            sprite3.position.x = sprite2.position.x - 30
        } else if range > 0 && range > 25 {
            sprite3.position.x = sprite2.position.x - 25
        } else if range > 0 && range > 20 {
            sprite3.position.x = sprite2.position.x - 20
        } else if range > 0 && range > 15 {
            sprite3.position.x = sprite2.position.x - 15
        } else if range > 0 && range > 10 {
            sprite3.position.x = sprite2.position.x - 10
        } else if range < 0 && abs(range) > 35 {
            sprite3.position.x = sprite2.position.x + 35
        } else if range < 0 && abs(range) > 30 {
            sprite3.position.x = sprite2.position.x + 30
        } else if range < 0 && abs(range) > 25 {
            sprite3.position.x = sprite2.position.x + 25
        } else if range < 0 && abs(range) > 20 {
            sprite3.position.x = sprite2.position.x + 20
        } else if range < 0 && abs(range) > 15 {
            sprite3.position.x = sprite2.position.x + 15
        } else if range < 0 && abs(range) > 10 {
            sprite3.position.x = sprite2.position.x + 10
        } else {
            sprite3.position.x = sprite2.position.x
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if gamePlaying {
            if contactCounter == 0 {
                if contact.bodyB.node?.name == stone1CategoryName {
                    adjustPositionForStoneOneAndTwo()
                    sprite2.position.y = sprite1.position.y + 50
                    
                    let joint = SKPhysicsJointFixed.joint(withBodyA: contact.bodyA, bodyB: contact.bodyB, anchor: sprite1.position)
                    self.physicsWorld.add(joint)
                    
                    dropSecondStone()
                }
            }
            if contactCounter == 1 {
                if contact.bodyA.node?.name == stone2CategoryName {
                    adjustPositionForStonesTwoAndThree()
                    sprite3.position.y = sprite2.position.y + 40
                    
                    let joint = SKPhysicsJointFixed.joint(withBodyA: contact.bodyA, bodyB: contact.bodyB, anchor: sprite1.position)
                    self.physicsWorld.add(joint)
                }
            }
            contactCounter += 1
        }
    }
    
    /*** SUCCESS  */
    func endGameSuccessfully() {
        playSoundUnlockedLevel()
        gamePlaying = false
        startSuccessPaticle()
    }
    
    func startSuccessPaticle() {
        timerSuccess = Timer.scheduledTimer(timeInterval: 7.0, target: self, selector: #selector(stopSuccessPaticle), userInfo: nil, repeats: false)
        let emitter = SKEmitterNode(fileNamed: "SuccessParticle.sks")
        emitter?.particlePosition = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        emitter?.zPosition = CGPoint(x: 0, y: 0).x
        emitter?.particleSize = CGSizeMake(30.0, 30.0)
        emitter?.particleColor = ImageUtil().getSuccessColor()
        emitter?.name = "Success"
        self.addChild(emitter!)
    }
    
    @objc func stopSuccessPaticle() {
        if let fire = self.childNode(withName: "Success") {
            fire.removeFromParent()
        }
        delegateGame?.gameDidEndSuccess(gamescene: self)
    }
    
    /*** FAILURE  */
    func endFailedGame() {
        playSoundFailure()
        gamePlaying = false
        
        let action = SKAction.rotate(byAngle: CGFloat(Double.pi), duration:5)
        if contactCounter == 0 {
            sprite2.run(SKAction.repeatForever(action))
            sprite2.run(SKAction.resize(toWidth: 0, duration: 5))
            startFailurePaticleStone2()
        } else if contactCounter == 1 {
            sprite3.run(SKAction.repeatForever(action))
            sprite3.run(SKAction.resize(toWidth: 0, duration: 5))
            startFailurePaticleStone3()
        }
    }
    
    func startFailurePaticleStone2() {
        timerSuccess = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(stopFailurePaticle), userInfo: nil, repeats: false)
        let emitter = SKEmitterNode(fileNamed: "FailureParticle.sks")
        emitter?.particlePosition = CGPoint(x: sprite2.position.x - 10, y: sprite2.position.y - 20)
        emitter?.zPosition = CGPoint(x: 0, y: 0).x
        emitter?.particleSize = CGSizeMake(30.0, 30.0)
        emitter?.particleColor = UIColor.lightGray
        emitter?.name = "Failure"
        self.addChild(emitter!)
    }
    
    func startFailurePaticleStone3() {
        timerSuccess = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(stopFailurePaticle), userInfo: nil, repeats: false)
        let emitter = SKEmitterNode(fileNamed: "FailureParticle.sks")
        emitter?.particlePosition = CGPoint(x: sprite3.position.x - 11, y: sprite3.position.y - 8)
        emitter?.zPosition = CGPoint(x: 0, y: 0).x
        emitter?.particleSize = CGSizeMake(30.0, 30.0)
        emitter?.particleColor = UIColor.lightGray
        emitter?.name = "Failure"
        self.addChild(emitter!)
    }
    
    @objc func stopFailurePaticle() {
        if let smoke = self.childNode(withName: "Failure") {
            smoke.removeFromParent()
            sprite3.removeFromParent()
            sprite2.removeFromParent()
        }
        delegateGame?.gameDidEndFailed(gamescene: self)
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
    
    func playSoundUnlockedLevel() {
        run(SKAction.playSoundFileNamed("zen.m4a", waitForCompletion: false))
    }
    
    func playSoundFailure() {
        run(SKAction.playSoundFileNamed("shimmer.m4a", waitForCompletion: false))
    }
    
    func clearAll() {
        contactCounter = 0
        gamePlaying = true
        sprite1.removeAllActions()
        sprite1.removeAllChildren()
        sprite2.removeAllActions()
        sprite2.removeAllChildren()
        sprite3.removeAllActions()
        sprite3.removeAllChildren()
        removeAllChildren()
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
