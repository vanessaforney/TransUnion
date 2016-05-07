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
            return "You are well below the average score of U.S. consumers. It’s doubtful that you will qualify for a loan or a credit card, because this demonstrates to lenders that you are a risky borrower."
        } else if value <= 657 {
            return "You are below the average score of U.S. consumers. Though many lenders will approve loans with this score, you may not get a good interest rate."
        } else if value <= 719 {
            return "You are near or slightly above the average of U.S. consumers. There won’t be any problem in getting a loan at a good interest rate since most lenders consider this a good score."
        } else if value <= 780 {
            return "You are above the average of U.S. consumers, and you won’t have any problem in getting a loan at a good interest rate. This demonstrates to lenders you are a very dependable borrower."
        } else { 
            return "You are well above the average score of U.S. consumers, and you should qualify for the best interest rate and loan terms. This demonstrates to lenders you are an exceptional borrower."
        }
    }

}