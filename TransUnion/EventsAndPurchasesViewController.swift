//
//  EventsAndPurchasesViewController.swift
//  TransUnion
//
//  Created by Russ Fenenga on 5/7/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import UIKit

class EventsAndPurchasesViewController: UIViewController {
    var totalLoanAmount = 0
    var score: Score!
    var earnings = 0
    var losses = 0
    var remainingLoans = [Loan]()
    var creditEvents: [String:Int] = [:]
    var purchases:[String: Int] = [:]
    
    @IBAction func button(sender: AnyObject) {
        performSegueWithIdentifier("toFinal", sender: nil)
    }
    @IBOutlet weak var purchases4: UILabel!
    @IBOutlet weak var purchases3: UILabel!
    @IBOutlet weak var purchases2: UILabel!
    @IBOutlet weak var house: UILabel!
    @IBOutlet weak var totalNum: UILabel!
    @IBOutlet weak var actualLoanBalance: UILabel!
    @IBOutlet weak var numberOfEvents: UILabel!
    @IBOutlet weak var numberOfPurchases: UILabel!


    @IBOutlet weak var numEvents: UILabel!
    @IBOutlet weak var events1: UILabel!
    @IBOutlet weak var events2: UILabel!
    @IBOutlet weak var events3: UILabel!
    @IBOutlet weak var events4: UILabel!
    @IBOutlet weak var events5: UILabel!

    var purchasesList = [UILabel]()
    var eventsList = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        purchasesList.append(house)
        purchasesList.append(purchases2)
        purchasesList.append(purchases3)
        purchasesList.append(purchases4)

        for purchase in purchases {
            let first = purchasesList.removeFirst()
            first.text = "\(purchase.1)x \(purchase.0)"
        }

        for x in purchasesList {
            x.hidden = true
        }

        eventsList.append(events1)
        eventsList.append(events2)
        eventsList.append(events3)
        eventsList.append(events4)
        eventsList.append(events5)

        for event in creditEvents {
            let first = eventsList.removeFirst()
            first.text = "\(event.1)x \(event.0)"
        }

        for x in eventsList {
            x.hidden = true
        }

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toFinal" {
            let vc = segue.destinationViewController as! FinalResultsViewController
            vc.earnings = earnings
            vc.losses = losses
            vc.remainingLoans = remainingLoans
            vc.score = score
            // GO TO FINAL, SEND THAT DATA AND CRDIT SCORE
        }
    }
}