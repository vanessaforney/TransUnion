//
//  GameScene.swift
//  TransUnion
//
//  Created by Vanessa Forney on 5/6/16.
//  Copyright (c) 2016 Vanessa Forney. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var viewController:     GameViewController!
    
    var score = NSInteger()
    var debt = NSInteger()
    var scoreChanged = false
    var started = false
    var touching = false
    var balloonAtTop = false
    
    var myLabel:SKLabelNode!
    var balloon:SKSpriteNode!
    var moving:SKNode!
    var enemys:SKNode!
    var cashLabelNode:SKLabelNode!
    var debtLabelNode:SKLabelNode!

    
    var enemyTexture:SKTexture!
    var moveRemoveEnemy:SKAction!
    
    let balloonCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    let background = SKSpriteNode(imageNamed: "Environment_v2")
    let background2 = SKSpriteNode(imageNamed: "Environment_v2-flipped")
    
    var itemTextures = [SKTexture]()
    
//    enum MaskType : UInt32 {
//        case Car = 2
//        case Marriage = 4
//        case Money = 8
//        case Unexpected = 16
//    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Press to start game"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        itemTextures.append(SKTexture(imageNamed: "car"))
        itemTextures.append(SKTexture(imageNamed: "marriage"))
        itemTextures.append(SKTexture(imageNamed: "money"))
        itemTextures.append(SKTexture(imageNamed: "unexpected"))
        self.addChild(myLabel)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        touching = true
        if (!started) {
            self.removeAllChildren()
            setupGame();
            started = true;
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = false;
    }
    
    func setupGame() {
        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: -5.0 )
        self.physicsWorld.contactDelegate = self
        
        // set up moving node
        moving = SKNode()
        self.addChild(moving)
        enemys = SKNode()
        moving.addChild(enemys)
        
        background.anchorPoint = CGPointZero
        background.position = CGPointMake(0, 0)
        background.zPosition = -15
        //background.setScale(0.75)
        self.addChild(background)
        
        background2.anchorPoint = CGPointZero
        background2.position = CGPointMake(background.size.width - 1,0)
        background2.zPosition = -15
       // background2.setScale(0.75)
        self.addChild(background2)
        
        // setup balloon
        let balloonTexture = SKTexture(imageNamed: "Balloon")
        balloon = SKSpriteNode(texture: balloonTexture)
        //balloon.setScale(0.1)
        balloon.zPosition = 10;
        balloon.position = CGPoint(x: self.frame.size.width * 0.20, y:self.frame.size.height * 0.6)
        
        balloon.physicsBody = SKPhysicsBody(rectangleOfSize: balloon.size)
        balloon.physicsBody?.dynamic = true
        balloon.physicsBody?.allowsRotation = false
        
        balloon.physicsBody?.categoryBitMask = balloonCategory
        balloon.physicsBody?.contactTestBitMask = pipeCategory
        balloon.physicsBody?.collisionBitMask = worldCategory
        
        self.addChild(balloon)
        
        // spawn the enemy
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        
        // initialize cash label
        cashLabelNode = SKLabelNode(fontNamed:"Chalkduster")
        self.updateCash()
        cashLabelNode.zPosition = 100
        self.addChild(cashLabelNode)
        
        // initialize cash label
        debtLabelNode = SKLabelNode(fontNamed:"Chalkduster")
        debtLabelNode.zPosition = 100
        self.updateDebt()
        self.addChild(debtLabelNode)

        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func spawnPipes() {
        // create the pipes textures
        let rand = Int(arc4random_uniform(UInt32(itemTextures.count)))
        let texture = itemTextures[rand] as SKTexture
        enemyTexture = texture
        enemyTexture.filteringMode = .Nearest
        
        let enemyNode = SKSpriteNode(texture: enemyTexture)
        let actualY = random(min: enemyNode.size.height/2, max: size.height - enemyNode.size.height/2)
        //pipeDown.setScale(0.2)
        
        enemyNode.position = CGPoint(x: self.frame.maxX + self.frame.maxX / 2, y: actualY)
        enemyNode.zPosition = -10
        
        enemyNode.physicsBody = SKPhysicsBody(rectangleOfSize: enemyNode.size)
        enemyNode.physicsBody?.dynamic = false
        enemyNode.physicsBody?.categoryBitMask = pipeCategory
        enemyNode.physicsBody?.contactTestBitMask = balloonCategory
        
        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * enemyTexture.size().width + 435)
        let moveEnemy = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.007 * distanceToMove))
        let removeEnemy = SKAction.removeFromParent()
        moveRemoveEnemy = SKAction.sequence([moveEnemy, removeEnemy])
        
        enemyNode.runAction(moveRemoveEnemy)
        enemys.addChild(enemyNode)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var obj:SKNode? = nil
        if ((contact.bodyA.categoryBitMask & pipeCategory) == pipeCategory) {
            obj = contact.bodyA.node
            score+=1
            self.updateCash()
            self.updateDebt()
            scoreChanged = true
        } else if ((contact.bodyB.categoryBitMask & pipeCategory) == pipeCategory) {
            obj = contact.bodyB.node
            score+=1
            self.updateCash()
            self.updateDebt()
            scoreChanged = true
        }
        obj?.removeFromParent()
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(!started) {
            return
        }
        background.position = CGPointMake(background.position.x - 4,background.position.y)
        background2.position = CGPointMake(background2.position.x - 4,background2.position.y)
//            background.position = CGPointMake(background.position.x, scoreChanged == true && background.position.y - self.frame.maxY > -background.size.height ? background.position.y - 1: background.position.y)
//            background2.position = CGPointMake(background2.position.x, scoreChanged == true && background2.position.y - self.frame.maxY > -background2.size.height ? background2.position.y - 1: background2.position.y)

        scoreChanged = false
        if(background.position.x < -background.size.width)
        {
            background.position = CGPointMake(background2.position.x + background2.size.width, background2.position.y)
        }
        
        if(background2.position.x < -background2.size.width)
        {
            background2.position = CGPointMake(background.position.x + background2.size.width, background2.position.y)
            
        }
        updateBalloonPosition()
    }
    
    func updateBalloonPosition() {
        if touching {
            balloon.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
        }
    }
    
    func updateCash() {
        cashLabelNode.text = "$ \(score)"
        cashLabelNode.position = CGPoint( x: self.frame.maxX - cashLabelNode.frame.size.width, y: 3.2 * self.frame.maxY / 4 )
    }

    func updateDebt() {
        debtLabelNode.text = "-$ \(score)"
        debtLabelNode.position = CGPoint(x: self.frame.maxX - debtLabelNode.frame.size.width,
                                         y: (3.2 * self.frame.maxY / 4) - cashLabelNode.frame.size.height)
    }
}
