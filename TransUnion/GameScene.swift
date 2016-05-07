//
//  GameScene.swift
//  TransUnion
//
//  Created by Vanessa Forney on 5/6/16.
//  Copyright (c) 2016 Vanessa Forney. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird:SKSpriteNode!
    var moving:SKNode!
    var score = NSInteger()
    var started = false
    var touching = false
    var birdAtTop = false
    var myLabel:SKLabelNode!
    
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
            sprite.zPosition = 0;
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2)
            sprite.runAction(moveSkySpritesForever)
            moving.addChild(sprite)
            i++
        }
        
        // setup balloon
        let birdTexture1 = SKTexture(imageNamed: "Spaceship")
        bird = SKSpriteNode(texture: birdTexture1)
        bird.setScale(0.5)
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(bird)
        
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
