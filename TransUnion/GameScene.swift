//
//  GameScene.swift
//  TransUnion
//
//  Created by Vanessa Forney on 5/6/16.
//  Copyright (c) 2016 Vanessa Forney. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var score = NSInteger()
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
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Press to start game"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
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
        
        // background image
        let skyTexture = SKTexture(imageNamed: "Environment")
        skyTexture.filteringMode = .Nearest
        
        let moveSkySprite = SKAction.moveByX(-skyTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.01 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveByX(skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveSkySprite,resetSkySprite]))
        
        var i:CGFloat = 0
        
        while (i < CGFloat(2.0 + self.frame.size.width / ( skyTexture.size().width * 2.0 ))) {
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20;
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2)
            sprite.runAction(moveSkySpritesForever)
            moving.addChild(sprite)
            i++
        }
        
        // setup balloon
        let balloonTexture = SKTexture(imageNamed: "Spaceship")
        balloon = SKSpriteNode(texture: balloonTexture)
        balloon.setScale(0.5)
        balloon.zPosition = 10;
        balloon.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
        
        balloon.physicsBody = SKPhysicsBody(circleOfRadius: balloon.size.height / 2.0)
        balloon.physicsBody?.dynamic = true
        balloon.physicsBody?.allowsRotation = false
        
        balloon.physicsBody?.categoryBitMask = balloonCategory
        balloon.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        balloon.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(balloon)
        
        // create the pipes textures
        pipeTextureUp = SKTexture(imageNamed: "Spaceship")
        pipeTextureUp.filteringMode = .Nearest
        pipeTextureDown = SKTexture(imageNamed: "Spaceship")
        pipeTextureDown.filteringMode = .Nearest
        
        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
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
        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        let actualY = random(min: pipeDown.size.height/2, max: size.height - pipeDown.size.height/2)
        pipeDown.setScale(0.2)
        
        //TODO: Fix the x and y here, the spaceships are spawning off the screen.
        pipeDown.position = CGPoint(x: self.frame.maxX + self.frame.maxX / 2, y: actualY)
        pipeDown.zPosition = -10
        
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = balloonCategory
        pipeDown.runAction(movePipesAndRemove)
        pipes.addChild(pipeDown)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var obj:SKNode? = nil
        
        if ((contact.bodyA.categoryBitMask & pipeCategory) == pipeCategory) {
            obj = contact.bodyA.node
        } else if ((contact.bodyB.categoryBitMask & pipeCategory) == pipeCategory) {
            obj = contact.bodyB.node
        }
        obj?.removeFromParent()
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(!started) {
            return
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
