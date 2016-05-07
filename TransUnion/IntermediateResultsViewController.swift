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
    
    
    @IBOutlet weak var nextRoundButton: UIButton!

    @IBAction func nextRoundButtonAcction(sender: AnyObject) {
        startNextRound()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // do stuff with stuff
        // call startNextRound() please
        
    }
    
    func startNextRound() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! GameViewController
        vc.score = score
        vc.earnings = earnings
        vc.losses = losses
        vc.remainingLoans = remainingLoans
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.window?.rootViewController = vc
    }
}