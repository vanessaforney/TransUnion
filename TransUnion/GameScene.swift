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
    
    var cash = NSInteger()
    var debt = NSInteger()
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

    let worldCategory: UInt32 = 1 << 7
    let background = SKSpriteNode(imageNamed: "Environment_v3")
    let background2 = SKSpriteNode(imageNamed: "Environment_v3-flipped")
    
    var itemTextures = [SKTexture]()
    var remainingLoans = [Loan]()
    var timer = NSTimer()
    var seconds = 0
    
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
        if(started){
            balloon.texture = SKTexture(imageNamed: "BigFlameBalloonFinal")
            //balloon.physicsBody = SKPhysicsBody(texture: balloon.texture!, size: balloon.texture!.size())
        }
        if (!started) {
            self.removeAllChildren()
            setupGame();
            started = true;
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: (#selector(GameScene.updateTime)), userInfo: nil, repeats: true)
        }
        
    }
    
    func updateTime(){
        seconds += 1
        print(seconds)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        balloon.texture = SKTexture(imageNamed: "SmallFlameBalloonFinal")
        //balloon.physicsBody = SKPhysicsBody(texture: balloon.texture!, size: balloon.texture!.size())
        touching = false;
    }
    
    func setupGame() {
        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: -5.0 )
        self.physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody?.collisionBitMask = CollisionDetector.balloonCategory
        
        // set up moving node
        moving = SKNode()
        self.addChild(moving)
        enemys = SKNode()
        moving.addChild(enemys)
        print("width: \(self.frame.maxX)")
        print("height: \(self.frame.maxY)")
        
        background.anchorPoint = CGPointZero
        background.position = CGPointMake(0, 0)
        background.zPosition = -15
        background.size = CGSize(width: self.frame.maxX, height: self.frame.maxY)
        self.addChild(background)
        
        background2.anchorPoint = CGPointZero
        background2.position = CGPointMake(background.size.width - 1,0)
        background2.size = CGSize(width: self.frame.maxX, height: self.frame.maxY)
        background2.zPosition = -15

        self.addChild(background2)
        
        // setup balloon
        let balloonTexture = SKTexture(imageNamed: "SmallFlameBalloonFinal")
        balloon = SKSpriteNode(texture: balloonTexture)
        balloon.zPosition = 10;
        balloon.position = CGPoint(x: self.frame.size.width * 0.20, y:self.frame.size.height * 0.6)
        
        balloon.physicsBody = SKPhysicsBody(texture: balloonTexture, size: balloonTexture.size())
        balloon.physicsBody?.dynamic = true
        balloon.physicsBody?.allowsRotation = false
        
        balloon.physicsBody?.categoryBitMask = CollisionDetector.balloonCategory
        //        balloon.physicsBody?.contactTestBitMask = CollisionDetector.enemyCategory
        balloon.physicsBody?.collisionBitMask = worldCategory
        
        self.addChild(balloon)
        
        // spawn the enemy
        if (!started){
            let spawn = SKAction.runBlock({() in self.spawnPipes()})
            let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
            let spawnThenDelay = SKAction.sequence([spawn, delay])
            let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
            self.runAction(spawnThenDelayForever, withKey: "ItemSpawn")
        }
        // initialize cash label
        cashLabelNode = SKLabelNode(fontNamed:"IntroSemiBoldCaps")
        self.updateCash()
        cashLabelNode.zPosition = 100
        self.addChild(cashLabelNode)
        
        // initialize cash label
        debtLabelNode = SKLabelNode(fontNamed:"IntroSemiBoldCaps")
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
        let rand = arc4random_uniform(UInt32(itemTextures.count))
        let texture = itemTextures[Int(rand)] as SKTexture
        enemyTexture = texture
        enemyTexture.filteringMode = .Nearest
        
        let enemyNode = SKSpriteNode(texture: enemyTexture)
        let actualY = random(min: enemyNode.size.height/2, max: size.height - enemyNode.size.height/2)
        //pipeDown.setScale(0.2)
        
        enemyNode.position = CGPoint(x: self.frame.maxX + self.frame.maxX / 2, y: actualY)
        enemyNode.zPosition = -10
        
        enemyNode.physicsBody = SKPhysicsBody(rectangleOfSize: enemyNode.size)
        enemyNode.physicsBody?.dynamic = false
        enemyNode.physicsBody?.categoryBitMask = 1 << (rand + 1)
        enemyNode.physicsBody?.contactTestBitMask = CollisionDetector.balloonCategory
        
        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * enemyTexture.size().width + 435)
        let moveEnemy = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.007 * distanceToMove))
        let removeEnemy = SKAction.removeFromParent()
        moveRemoveEnemy = SKAction.sequence([moveEnemy, removeEnemy])
        
        enemyNode.runAction(moveRemoveEnemy)
        enemys.addChild(enemyNode)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if let tuple = CollisionDetector.calculateCollision(contact) {
            let score = tuple.0
            let obj = tuple.1
            let type = tuple.2
            
            handleObjectCollision(type, score: score)
            obj.removeFromParent()
        }
    }
    
    func handleObjectCollision(type:String, score:Int) {
        switch(type) {
        case "car":
            if (score > cash) {
                let diff = score - cash
                self.cash = 0
                let loan = Loan.init(type: type, amount: diff)
                remainingLoans.append(loan)
                print("Added loan: \(loan)")
                self.debt += diff
                self.updateCash()
                self.updateDebt()
                return
            }
            return
        case "marriage":
            // send request
            return
        case "money":
            cash += score
            self.updateCash()
            return
        case "unexpected":
            return
        default:
            return
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(!started) {
            return
        }
        if(seconds > 60){
            timer.invalidate()
            started = false
            self.removeActionForKey("ItemSpawngit ")
            return
        }
        background.position = CGPointMake(background.position.x - 4,background.position.y)
        background2.position = CGPointMake(background2.position.x - 4,background2.position.y)
        //            background.position = CGPointMake(background.position.x, scoreChanged == true && background.position.y - self.frame.maxY > -background.size.height ? background.position.y - 1: background.position.y)
        //            background2.position = CGPointMake(background2.position.x, scoreChanged == true && background2.position.y - self.frame.maxY > -background2.size.height ? background2.position.y - 1: background2.position.y)
        
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
        cashLabelNode.text = "$ \(cash)"
        cashLabelNode.position = CGPoint( x: self.frame.maxX - cashLabelNode.frame.size.width, y: 3.2 * self.frame.maxY / 4 )
    }
    
    func updateDebt() {
        debtLabelNode.text = "-$ \(debt)"
        debtLabelNode.position = CGPoint(x: self.frame.maxX - debtLabelNode.frame.size.width,
                                         y: (3.2 * self.frame.maxY / 4) - cashLabelNode.frame.size.height)
    }
}
