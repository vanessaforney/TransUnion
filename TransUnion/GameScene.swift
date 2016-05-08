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
    
    var touching = false
    var balloonAtTop = false
    var creditEvents: [String:Int] = [:]
    var purchases:[String: Int] = [:]
    var totalLoneAmount: Int = 0
    var myLabel:SKLabelNode!
    var balloon:SKSpriteNode!
    var moving:SKNode!
    var enemys:SKNode!
    var cashLabelNode:SKLabelNode!
    var debtLabelNode:SKLabelNode!
    var secondTimerNode: SKLabelNode!
    
    
    var enemyTexture:SKTexture!
    var moveRemoveEnemy:SKAction!

    var worldCategory: UInt32 = 1 << 7
    var background: SKSpriteNode!
    var background2:SKSpriteNode!
    var itemTextures:[SKTexture]!
    var timer:NSTimer!
    var seconds = 2
    var creditScore: Int = 720 {
        didSet {
            dispatch_async(dispatch_get_main_queue()) { 
               self.viewController.reloadScore()
            }
        }
    }
    
//    enum MaskType : UInt32 {
//        case Car = 2
//        case Marriage = 4
//        case Money = 8
//        case Unexpected = 16
//    }

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        setupGame()
        itemTextures = [SKTexture]()
        timer = NSTimer()

        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: (#selector(GameScene.updateTime)), userInfo: nil, repeats: true)
        

//        itemTextures = [SKTexture]()
        //timer = NSTimer()
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Press to start game"
//        myLabel.fontSize = 45
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        itemTextures.append(SKTexture(imageNamed: "Car_Purchase")) // car
        itemTextures.append(SKTexture(imageNamed: "Marriage_Event")) // marriage
        itemTextures.append(SKTexture(imageNamed: "CashMoney")) // money
        itemTextures.append(SKTexture(imageNamed: "Home_Purchase")) // house
        itemTextures.append(SKTexture(imageNamed: "Food_Purchase")) // grocery
        itemTextures.append(SKTexture(imageNamed: "Medical_Purchase")) // medical
        itemTextures.append(SKTexture(imageNamed: "Divorce_Event")) // divorce
        itemTextures.append(SKTexture(imageNamed: "Lottery_Event")) // lottery
        itemTextures.append(SKTexture(imageNamed: "Identity_Event")) // idtheft
        itemTextures.append(SKTexture(imageNamed: "Bankruptcy")) // breach
        itemTextures.append(SKTexture(imageNamed: "Student_Loan")) // studentloan
        itemTextures.append(SKTexture(imageNamed: "Home_Loan")) // mortgageloan
        itemTextures.append(SKTexture(imageNamed: "Car_Loan")) // autoloan
        itemTextures.append(SKTexture(imageNamed: "Medical_Loan")) // medical
//        self.addChild(myLabel)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      //  viewController.gameOver()
        /* Called when a touch begins */
        touching = true
            balloon.texture = SKTexture(imageNamed: "BigFlameBalloonFinal")
            //balloon.physicsBody = SKPhysicsBody(texture: balloon.texture!, size: balloon.texture!.size())
//        if (!started) {
//            viewController.displayView.hidden = false
//            self.removeAllChildren()
//            setupGame();
//            started = true;
//            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: (#selector(GameScene.updateTime)), userInfo: nil, repeats: true)
//        }

    }
    
    func updateTime(){
        seconds-=1
        print(seconds)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        balloon.texture = SKTexture(imageNamed: "SmallFlameBalloonFinal")
        //balloon.physicsBody = SKPhysicsBody(texture: balloon.texture!, size: balloon.texture!.size())
        touching = false;
    }
    
    func setupGame() {
        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: -3.0 )
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
        //background.size = CGSize(background.fra)
        self.addChild(background)
        
        background2.anchorPoint = CGPointZero
        background2.position = CGPointMake(background.size.width - 1,0)
        //background2.size = CGSize(width: self.frame.maxX, height: self.frame.maxY)
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
            let spawn = SKAction.runBlock({() in self.spawnPipes()})
            let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
            let spawnThenDelay = SKAction.sequence([spawn, delay])
            let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
            self.runAction(spawnThenDelayForever, withKey: "ItemSpawn")

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
        var rand = arc4random_uniform(UInt32(itemTextures.count))
        let fifty = arc4random_uniform(2)
        print("fifty: \(fifty)")
        if (fifty > 0) {
            rand = 2;
        }
        
        if (rand == 9) {
            return; // not doing breaches
        }
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
        enemyNode.physicsBody?.collisionBitMask = 0
        
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
            purchases["Car"] = (purchases["Car"] ?? 0) + 1
            handlePurchase(type, score: score)
        case "marriage":
            creditEvents["Marriage"] = (creditEvents["Marriage"] ?? 0) + 1
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
            purchases["House"] = (purchases["House"] ?? 0) + 1
            RequestHandler.dataForLifeEvent(LifeEvent.NewJobHigherIncome, option: "PAY_DOWN_DEBT", score: creditScore) { (score:Int!, descprition: NSArray!) in
                self.creditScore = score
                print(self.creditScore)
                print(descprition)
            }
            handlePurchase(type, score: score)
        case "grocery":
            purchases["Grocieries"] = (purchases["Grocieries"] ?? 0) + 1
            handlePurchase(type, score: score)
        case "medical":
            purchases["Medical expenses"] = (purchases["Medical expenses"] ?? 0) + 1
            RequestHandler.dataForLifeEvent(LifeEvent.UnexpectedMedicalExpense, option: "SEEK_LOANS", score: creditScore) { (score:Int!, descprition: NSArray!) in
                self.creditScore = score
                print(self.creditScore)
                print(descprition)
            }
            handlePurchase(type, score: score)
        case "divorce":
            creditEvents["Divorce"] = (creditEvents["Divorce"] ?? 0) + 1
            RequestHandler.dataForLifeEvent(LifeEvent.Divorce, option: "EX_TRASHES_YOUR_CREDIT", score: creditScore) { (score:Int!, descprition: NSArray!) in
                self.creditScore = score
                print(self.creditScore)
                print(descprition)
            }
            
            return
        case "lottery":
            //TODO for russ
            creditEvents["Lottery"] = (creditEvents["Lottery"] ?? 0) + 1
            RequestHandler.dataForLifeEvent(LifeEvent.WinLargeSum, option: "NO_EFFECT", score: creditScore) { (score:Int!, descprition: NSArray!) in
                self.creditScore = score
                print(self.creditScore)
                print(descprition)
            }
            return
        case "idtheft":
            creditEvents["Identity Theft"] = (creditEvents["Identity Theft"] ?? 0) + 1
            RequestHandler.dataForLifeEvent(LifeEvent.IdentifyTheft, option: "THIEF_OPENS_CREDIT", score: creditScore) { (score:Int!, descprition: NSArray!) in
                self.creditScore = score
                print(self.creditScore)
                print(descprition)
            }
            //TODO for russ
            return
        case "breach":
            creditEvents["Breach"] = (creditEvents["Breach"] ?? 0) + 1
            RequestHandler.dataForLifeEvent(LifeEvent.BreachAtNetflix, option: "POSSIBLE_CREDIT_CARD_INFO_STOLEN", score: creditScore) { (score:Int!, descprition: NSArray!) in
                self.creditScore = score
                print(self.creditScore)
                print(descprition)
            }

            //TODO for russ
            return
        case "studentloan":
            RequestHandler.dataForLifeEvent(LifeEvent.StartCollege, option: "ADD_NEW_STUDENT_LOAN", score: creditScore) { (score:Int!, descprition: NSArray!) in
                self.creditScore = score
                print(self.creditScore)
                print(descprition)
            }
            addLoan(type, amount: score)
        case "mortgageloan":
            RequestHandler.dataForLifeEvent(LifeEvent.BigMortgage, option: "HOME_EQUITY_LINE", score: creditScore) { (score:Int!, descprition: NSArray!) in
                self.creditScore = score
                print(self.creditScore)
                print(descprition)
            }
            addLoan(type, amount: score)
        case "autoloan":
            RequestHandler.dataForLifeEvent(LifeEvent.NewJobHigherIncome, option: "PAY_DOWN_DEBT", score: creditScore) { (score:Int!, descprition: NSArray!) in
                self.creditScore = score
                print(self.creditScore)
                print(descprition)
            }
            addLoan(type, amount: score)
        case "medicalloan":
            RequestHandler.dataForLifeEvent(LifeEvent.StartCollege, option: "ADD_NEW_STUDENT_LOAN", score: creditScore) { (score:Int!, descprition: NSArray!) in
                self.creditScore = score
                print(self.creditScore)
                print(descprition)
            }
            addLoan(type, amount: score)
        default:
            return
        }
    }
    
    func addLoan(type: String, amount: Int) {
        let loan = Loan.init(type: type, amount: amount)
        totalLoneAmount = loan.amount + totalLoneAmount
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

        if(seconds < 0){
            //we are going to transition to the end game here
            viewController.endRound()
        } else {
        secondTimerNode = SKLabelNode(fontNamed:"IntroSemiBoldCaps")
        secondTimerNode.zPosition = 100
        viewController.secondTimer.text = "\(self.seconds) seconds"
        self.addChild(secondTimerNode)
        
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
    }
    
    func updateBalloonPosition() {
        if touching {
            balloon.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
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
