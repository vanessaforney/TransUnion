//
//  IntermediateResultsViewController.swift
//  TransUnion
//
//  Created by Vanessa Forney on 5/7/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

import UIKit

class IntermediateResultsViewController: UIViewController {
    
    var score: Score!
    var earnings = 750
    var losses = 300
    var remainingLoans = [Loan]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // do stuff with stuff
        // call startNextRound() please
    }
    
    func startNextRound() {
        performSegueWithIdentifier("nextRound", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nextRound" {
            let vc = segue.destinationViewController as! GameViewController
            vc.score = score
            vc.earnings = earnings
            vc.losses = losses
            vc.remainingLoans = remainingLoans
        }
    }
}