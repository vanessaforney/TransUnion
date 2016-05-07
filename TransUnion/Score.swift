//
//  Score.swift
//  TransUnion
//
//  Created by Vanessa Forney on 5/6/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

class Score {

    var value: Int

    enum Grade {
        case A, B, C, D, F
    }

    init(value: Int) {
        self.value = value
    }

    func getGrade() -> Grade {
        if value <= 600 {
            return .F
        } else if value <= 657 {
            return .D
        } else if value <= 719 {
            return .C
        } else if value <= 780 {
            return .B
        } else {
            return .A
        }
    }
    
    func getTitle() -> String {
        if value <= 600 {
            return "Bad Credit Score"
        } else if value <= 657 {
            return "Poor Credit Score"
        } else if value <= 719 {
            return "Average Credit Score"
        } else if value <= 780 {
            return "Good Credit Score"
        } else {
            return "Excellent Credit Score"
        }
    }

    func getDescription() -> String {
        if value <= 600 {
            return "It’s doubtful that you will qualify for a loan or a credit card."
        } else if value <= 657 {
            return "There won’t be any problem in getting a loan at a good interest rate."
        } else if value <= 719 {
            return "You may qualify for the loan but not at a good interest rate."
        } else if value <= 780 {
            return "There won’t be any problem in getting a loan at a good interest rate."
        } else {
            return "You should qualify for the best interest rate and loan terms."
        }
    }

}