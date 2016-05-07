//
//  Loan.swift
//  TransUnion
//
//  Created by Terrence Li on 5/7/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

class Loan {
    var type: String
    var amount: Int
    
    init(type: String, amount: Int) {
        self.type = type
        self.amount = amount
    }
    
}