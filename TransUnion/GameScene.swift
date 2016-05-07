//
//  GameScene.swift
//  TransUnion
//
//  Created by Vanessa Forney on 5/6/16.
//  Copyright (c) 2016 Vanessa Forney. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var viewController: GameViewController!
    
    
    var score = NSInteger()
    var scoreChanged = false
    var started = false
    var touching = false
    var balloonAtTop = false
    
    var myLabel:SKLabelNode!
    var balloon:SKSpriteNode!
    var moving:SKNode!
    var pipes:SKNode!
    
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
    
    let balloonCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    let skyBackground = SKSpriteNode(imageNamed: "Environment")
    let skyBackground2 = SKSpriteNode(imageNamed: "Environment")
    
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
        pipes = SKNode()
        moving.addChild(pipes)
        
        skyBackground.anchorPoint = CGPointZero
        skyBackground.position = CGPointMake(0, 0)
        skyBackground.setScale(2.0)
        skyBackground.zPosition = -15
        self.addChild(skyBackground)
        
        skyBackground2.anchorPoint = CGPointZero
        skyBackground2.position = CGPointMake(skyBackground.size.width - 1,0)
        skyBackground2.setScale(2.0)
        skyBackground2.zPosition = -15
        self.addChild(skyBackground2)
        
        // setup balloon
        let balloonTexture = SKTexture(imageNamed: "Balloon")
        balloon = SKSpriteNode(texture: balloonTexture)
        //balloon.setScale(0.1)
        balloon.zPosition = 10;
        balloon.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
        
        balloon.physicsBody = SKPhysicsBody(rectangleOfSize: balloon.size)
        balloon.physicsBody?.dynamic = true
        balloon.physicsBody?.allowsRotation = false
        
        balloon.physicsBody?.categoryBitMask = balloonCategory
        balloon.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        balloon.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(balloon)
        

        
        // spawn the pipes
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        
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
        pipeTextureDown = texture
        pipeTextureDown.filteringMode = .Nearest
        
        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        let actualY = random(min: pipeDown.size.height/2, max: size.height - pipeDown.size.height/2)
        //pipeDown.setScale(0.2)
        
        pipeDown.position = CGPoint(x: self.frame.maxX + self.frame.maxX / 2, y: actualY)
        pipeDown.zPosition = -10
        
        
        pipeDown.physicsBody = SKPhysicsBody(texture: pipeTextureDown, size: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = balloonCategory
        
        // create the pipes movement actions
        //don't ask me why
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureDown.size().width + 435)
        let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.007 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        
        pipeDown.runAction(movePipesAndRemove)
        pipes.addChild(pipeDown)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var obj:SKNode? = nil
        if ((contact.bodyA.categoryBitMask & pipeCategory) == pipeCategory) {
            obj = contact.bodyA.node
            score+=1
            scoreChanged = true
        } else if ((contact.bodyB.categoryBitMask & pipeCategory) == pipeCategory) {
            obj = contact.bodyB.node
            score+=1
            scoreChanged = true
        }
        obj?.removeFromParent()
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(!started) {
            return
        }
//            skyBackground.position = CGPointMake(skyBackground.position.x - 4, scoreChanged == true && skyBackground.position.y - self.frame.maxY > -skyBackground.size.height ? skyBackground.position.y - 5: skyBackground.position.y)
//            skyBackground2.position = CGPointMake(skyBackground2.position.x - 4, scoreChanged == true && skyBackground2.position.y - self.frame.maxY > -skyBackground2.size.height ? skyBackground2.position.y - 5 : skyBackground2.position.y)
        skyBackground.position = CGPointMake(skyBackground.position.x - 4,skyBackground.position.y)
        skyBackground2.position = CGPointMake(skyBackground2.position.x - 4,skyBackground2.position.y)
        for i in 0...100{
            skyBackground.position = CGPointMake(skyBackground.position.x, scoreChanged == true && skyBackground.position.y - self.frame.maxY > -skyBackground.size.height ? skyBackground.position.y - 1: skyBackground.position.y)
            skyBackground2.position = CGPointMake(skyBackground2.position.x, scoreChanged == true && skyBackground2.position.y - self.frame.maxY > -skyBackground2.size.height ? skyBackground2.position.y - 1: skyBackground2.position.y)
        }
        scoreChanged = false
        if(skyBackground.position.x < -skyBackground.size.width)
        {
            skyBackground.position = CGPointMake(skyBackground2.position.x + skyBackground2.size.width, skyBackground2.position.y)
        }
        
        if(skyBackground2.position.x < -skyBackground2.size.width)
        {
            skyBackground2.position = CGPointMake(skyBackground.position.x + skyBackground2.size.width, skyBackground2.position.y)
            
        }
        updateBalloonPosition()
    }
    
    func updateBalloonPosition() {
        if (touching && !balloonAtTop) {
            balloon.physicsBody?.affectedByGravity = false;
            balloon.physicsBody?.velocity = CGVector(dx: 0, dy: 200)
        } else {
            balloon.physicsBody?.velocity = CGVector(dx: 0, dy: -100)
            balloon.physicsBody?.affectedByGravity = true;
        }
        
        if (balloon.position.y - balloon.frame.size.height  <= 0 && !touching) {
            balloon.physicsBody?.affectedByGravity = false
            balloon.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            balloonAtTop = false
        }
            
        else if (balloon.position.y + balloon.frame.size.height >= self.frame.size.height && !balloonAtTop) {
            balloonAtTop = true;
            balloon.physicsBody?.affectedByGravity = false
            balloon.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        } else {
            balloonAtTop = false
        }
    }
}
