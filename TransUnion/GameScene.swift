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
    var birdAtTop = false
    
    var myLabel:SKLabelNode!
    var bird:SKSpriteNode!
    var moving:SKNode!
    var pipes:SKNode!
    
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
    
    let birdCategory: UInt32 = 1 << 0
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
        let skyTexture = SKTexture(imageNamed: "Spaceship")
        skyTexture.filteringMode = .Nearest
        
        let moveSkySprite = SKAction.moveByX(-skyTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.1 * skyTexture.size().width * 2.0))
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
        let birdTexture1 = SKTexture(imageNamed: "Spaceship")
        bird = SKSpriteNode(texture: birdTexture1)
        bird.setScale(0.5)
        bird.zPosition = 10;
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(bird)
        
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
    
    func spawnPipes() {
        let y = CGFloat(arc4random_uniform(UInt32(self.frame.maxY)))
        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        pipeDown.setScale(0.5)
        
        pipeDown.position = CGPoint(x: self.frame.maxX, y: y)
        pipeDown.zPosition = -10
        
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = birdCategory
        pipeDown.runAction(movePipesAndRemove)
        pipes.addChild(pipeDown)
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (!started) {
            return
        }
        
        updateBirdPosition()
    }
    
    func updateBirdPosition() {
        if (touching && !birdAtTop) {
            bird.physicsBody?.affectedByGravity = false;
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
        } else {
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: -300)
            bird.physicsBody?.affectedByGravity = true;
        }
        
        if (bird.position.y - bird.frame.size.height  <= 0 && !touching) {
            bird.physicsBody?.affectedByGravity = false
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            birdAtTop = false
        }
            
        else if (bird.position.y + bird.frame.size.height >= self.frame.size.height && !birdAtTop) {
            birdAtTop = true;
            bird.physicsBody?.affectedByGravity = false
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        } else {
            birdAtTop = false
        }
    }
}
