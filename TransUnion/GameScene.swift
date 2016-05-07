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

    var worldCategory: UInt32 = 1 << 7
    var background: SKSpriteNode!
    var background2:SKSpriteNode!
    var itemTextures:[SKTexture]!
    var timer:NSTimer!
    var seconds = 0
    var creditScore: Int = 610
    
//    enum MaskType : UInt32 {
//        case Car = 2
//        case Marriage = 4
//        case Money = 8
//        case Unexpected = 16
//    }

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        itemTextures = [SKTexture]()
        timer = NSTimer()
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Press to start game"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        itemTextures.append(SKTexture(imageNamed: "Obstacles-1"))
        itemTextures.append(SKTexture(imageNamed: "Obstacles-2"))
        itemTextures.append(SKTexture(imageNamed: "Obstacles-3"))
        itemTextures.append(SKTexture(imageNamed: "Obstacles-4"))
        self.addChild(myLabel)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        touching = true
        if(started){
            balloon.texture = SKTexture(imageNamed: "HugeFlameBalloon")
            //balloon.physicsBody = SKPhysicsBody(texture: balloon.texture!, size: balloon.texture!.size())
        }
        if (!started) {
            viewController.displayView.hidden = false
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
        balloon.texture = SKTexture(imageNamed: "SmallFlameBalloon")
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
        
        
        background = SKSpriteNode(imageNamed: "Environment_v3")
        background2 = SKSpriteNode(imageNamed: "Environment_v3-flipped")
    
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
        let balloonTexture = SKTexture(imageNamed: "SmallFlameBalloon")
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
            handlePurchase(type, score: score)
        case "marriage":
            RequestHandler.dataForLifeEvent(LifeEvent.MarriageBadSpousalCredit, option: "EFFECTS_SCORE", score: creditScore) { (score:Int!, descprition: NSArray!) in
                self.creditScore = score
                print(self.creditScore)
                print(descprition)
            }
            return
        case "money":
            viewController.earnings += score
            self.updateCash()
        case "house":
            handlePurchase(type, score: score)
        case "grocery":
            handlePurchase(type, score: score)
        case "medical":
            handlePurchase(type, score: score)
        case "divorce":
            //TODO for russ
            return
        case "lottery":
            //TODO for russ
            return
        case "idtheft":
            //TODO for russ
            return
        case "breach":
            //TODO for russ
            return
        case "studentloan":
            addLoan(type, amount: score)
        case "mortgageloan":
            addLoan(type, amount: score)
        case "autoloan":
            addLoan(type, amount: score)
        case "medicalloan":
            addLoan(type, amount: score)
        default:
            return
        }
    }
    
    func addLoan(type: String, amount: Int) {
        let loan = Loan.init(type: type, amount: amount)
        self.viewController.remainingLoans.append(loan)
        print("Added loan: \(loan)")
    }
    
    func handlePurchase(type: String, score: Int) {
        if (score > self.viewController.earnings) {
            let diff = score - self.viewController.earnings
            self.viewController.earnings = 0
            addLoan(type, amount: diff)
            self.viewController.losses += diff
            self.updateCash()
            self.updateDebt()
            return
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(!started) {
            return
        }
        if(seconds > 5){
            timer.invalidate()
            started = false
            self.removeActionForKey("ItemSpawngit ")
            viewController.endRound();
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
        viewController.earningsLabel.text = "$\(self.viewController.earnings)"
        //cashLabelNode.position = CGPoint( x: self.frame.maxX - 150 - cashLabelNode.frame.size.width / 2, y: 3.2 * self.frame.maxY / 4 )
    }
    
    func updateDebt() {
        viewController.debtLabel.text = "-$\(self.viewController.losses)"
        //debtLabelNode.position = CGPoint(x: self.frame.maxX - 150 - debtLabelNode.frame.size.width / 2,
          //                               y: (3.2 * self.frame.maxY / 4) - cashLabelNode.frame.size.height - 15)
        debtLabelNode.color = Color.Red
    }
    
    func nilAll() {
        self.removeAllActions()
        self.removeAllChildren()
        self.physicsWorld.removeAllJoints()
        
        viewController = nil
        myLabel = nil
        balloon = nil
        moving = nil
        enemys = nil
        cashLabelNode = nil
        debtLabelNode = nil
        enemyTexture = nil
        moveRemoveEnemy = nil
        background = nil;
        background2 = nil;
        itemTextures = nil
        timer = nil;
        timer = nil;
        
        
    }
}
