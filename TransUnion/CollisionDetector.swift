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
    static let house: UInt32 = 1 << 4 // $300k
    static let grocery: UInt32 = 1 << 5 // $1000
    static let medical: UInt32 = 1 << 6 // $5k
    static let divorce: UInt32 = 1 << 7
    static let lottery: UInt32 = 1 << 8
    static let idtheft: UInt32 = 1 << 9
    static let breach: UInt32 = 1 << 10
    static let studentloan: UInt32 = 1 << 11 // $25k
    static let mortgageloan: UInt32 = 1 << 12 // $250k
    static let autoloan: UInt32 = 1 << 13 // $15k
    static let medicalloan: UInt32 = 1 << 14 // $2.5k

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
        } else if let tuple = checkHouse(contact) {
            print("hit house")
            return tuple
        } else if let tuple = checkGrocery(contact) {
            print("hit grocery")
            return tuple
        } else if let tuple = checkMedical(contact) {
            print("hit medical")
            return tuple
        } else if let tuple = checkDivorce(contact) {
            print("hit divorce")
            return tuple
        } else if let tuple = checkLottery(contact) {
            print("hit lottery")
            return tuple
        } else if let tuple = checkIdTheft(contact) {
            print("hit id theft")
            return tuple
        } else if let tuple = checkBreach(contact) {
            print("hit breach")
            return tuple
        } else if let tuple = checkStudentLoan(contact) {
            print("hit student loan")
            return tuple
        } else if let tuple = checkMortgageLoan(contact) {
            print("hit mortgage loan")
            return tuple
        } else if let tuple = checkAutoloan(contact) {
            print("hit auto loan")
            return tuple
        } else if let tuple = checkMedicalLoan(contact) {
            print("hit medical loan")
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
        
        if (obj == nil) {
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
        
        if (obj == nil) {
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
        
        if (obj == nil) {
            return nil
        }
        
        return (score, obj, "money")
    }
    
    internal static func checkHouse(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & house) == house) {
            obj = contact.bodyA.node
            score = 300000
        } else if ((contact.bodyB.categoryBitMask & house) == house) {
            obj = contact.bodyB.node
            score = 300000
        } else {
            return nil
        }
        
        if (obj == nil) {
            return nil
        }
        
        return (score, obj, "house")
    }
    
    internal static func checkGrocery(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & grocery) == grocery) {
            obj = contact.bodyA.node
            score = 1000
        } else if ((contact.bodyB.categoryBitMask & grocery) == grocery) {
            obj = contact.bodyB.node
            score = 10000
        } else {
            return nil
        }
        
        if (obj == nil) {
            return nil
        }
        
        return (score, obj, "grocery")
    }
    
    internal static func checkMedical(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & medical) == medical) {
            obj = contact.bodyA.node
            score = 5000
        } else if ((contact.bodyB.categoryBitMask & medical) == medical) {
            obj = contact.bodyB.node
            score = 50000
        } else {
            return nil
        }
        
        if (obj == nil) {
            return nil
        }
        
        return (score, obj, "medical")
    }
    
    internal static func checkDivorce(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & divorce) == divorce) {
            obj = contact.bodyA.node
            score = 0
        } else if ((contact.bodyB.categoryBitMask & divorce) == divorce) {
            obj = contact.bodyB.node
            score = 0
        } else {
            return nil
        }
        
        if (obj == nil) {
            return nil
        }
        
        return (score, obj, "divorce")
    }
    
    internal static func checkLottery(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & lottery) == lottery) {
            obj = contact.bodyA.node
            score = 0
        } else if ((contact.bodyB.categoryBitMask & lottery) == lottery) {
            obj = contact.bodyB.node
            score = 0
        } else {
            return nil
        }
        
        if (obj == nil) {
            return nil
        }
        
        return (score, obj, "lottery")
    }
    
    internal static func checkIdTheft(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & idtheft) == idtheft) {
            obj = contact.bodyA.node
            score = 0
        } else if ((contact.bodyB.categoryBitMask & idtheft) == idtheft) {
            obj = contact.bodyB.node
            score = 0
        } else {
            return nil
        }
        
        if (obj == nil) {
            return nil
        }
        
        return (score, obj, "idtheft")
    }
    
    internal static func checkBreach(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & breach) == breach) {
            obj = contact.bodyA.node
            score = 0
        } else if ((contact.bodyB.categoryBitMask & breach) == breach) {
            obj = contact.bodyB.node
            score = 0
        } else {
            return nil
        }
        
        if (obj == nil) {
            return nil
        }
        
        return (score, obj, "breach")
    }
    
    internal static func checkStudentLoan(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & studentloan) == studentloan) {
            obj = contact.bodyA.node
            score = 25000
        } else if ((contact.bodyB.categoryBitMask & studentloan) == studentloan) {
            obj = contact.bodyB.node
            score = 25000
        } else {
            return nil
        }
        
        if (obj == nil) {
            return nil
        }
        
        return (score, obj, "studentloan")
    }
    
    internal static func checkMortgageLoan(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & mortgageloan) == mortgageloan) {
            obj = contact.bodyA.node
            score = 250000
        } else if ((contact.bodyB.categoryBitMask & mortgageloan) == mortgageloan) {
            obj = contact.bodyB.node
            score = 250000
        } else {
            return nil
        }
        
        if (obj == nil) {
            return nil
        }
        
        return (score, obj, "mortgageloan")
    }
    
    internal static func checkAutoloan(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & autoloan) == autoloan) {
            obj = contact.bodyA.node
            score = 15000
        } else if ((contact.bodyB.categoryBitMask & autoloan) == autoloan) {
            obj = contact.bodyB.node
            score = 15000
        } else {
            return nil
        }
        
        if (obj == nil) {
            return nil
        }
        
        return (score, obj, "autoloan")
    }
    
    internal static func checkMedicalLoan(contact: SKPhysicsContact) -> (NSInteger, SKNode, String)? {
        var obj:SKNode! = nil
        var score:NSInteger = 0
        
        if ((contact.bodyA.categoryBitMask & medicalloan) == medicalloan) {
            obj = contact.bodyA.node
            score = 2500
        } else if ((contact.bodyB.categoryBitMask & medicalloan) == medicalloan) {
            obj = contact.bodyB.node
            score = 2500
        } else {
            return nil
        }
        
        if (obj == nil) {
            return nil
        }
        
        return (score, obj, "medicalloan")
    }
    
    
    
}