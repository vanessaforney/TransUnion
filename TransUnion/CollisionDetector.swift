//
//  CollisionDetector.swift
//  TransUnion
//
//  Created by Terrence Li on 5/7/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation
import SpriteKit


class CollisionDetector {
    
    static let balloonCategory: UInt32 = 1 << 0
    
    static let car : UInt32 = 1 << 1
    static let marriage: UInt32 = 1 << 2
    static let money: UInt32 = 1 << 3
    static let unexpected: UInt32 = 1 << 4
    //    let enemyCategory: UInt32 = 1 << 5
    //    let enemyCategory: UInt32 = 1 << 6
    //    let enemyCategory: UInt32 = 1 << 7
    //    let enemyCategory: UInt32 = 1 << 8
    
    
    static func calculateCollision(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        
        if let tuple = checkCar(contact) {
            print("hit car")
            return tuple
        } else if let tuple = checkMarriage(contact) {
            print("hit marriage")
            return tuple
        } else if let tuple = checkMoney(contact) {
            print("hit money")
            return tuple
        } else if let tuple = checkUnexpected(contact) {
            print("hit unexpected")
            return tuple
        }
        
        return nil
        
        
    }
    
    internal static func checkCar(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & car) == car) {
            obj = contact.bodyA.node
            score = 20000
        } else if ((contact.bodyB.categoryBitMask & car) == car) {
            obj = contact.bodyB.node
            score = 20000
        } else {
            return nil
        }
        
        return (score, obj, "car")
    }
    
    internal static func checkMarriage(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        let score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & marriage) == marriage) {
            obj = contact.bodyA.node
        } else if ((contact.bodyB.categoryBitMask & marriage) == marriage) {
            obj = contact.bodyB.node
        } else {
            return nil
        }
        
        return (score, obj, "marriage")
    }
    
    internal static func checkMoney(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & money) == money) {
            obj = contact.bodyA.node
            score = 5000
        } else if ((contact.bodyB.categoryBitMask & money) == money) {
            obj = contact.bodyB.node
            score = 5000
        } else {
            return nil
        }
        
        return (score, obj, "money")
    }
    
    internal static func checkUnexpected(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & unexpected) == unexpected) {
            obj = contact.bodyA.node
            score+=1
        } else if ((contact.bodyB.categoryBitMask & unexpected) == unexpected) {
            obj = contact.bodyB.node
            score+=1
        } else {
            return nil
        }
        
        return (score, obj, "unexpected")
    }
    
    
    
}