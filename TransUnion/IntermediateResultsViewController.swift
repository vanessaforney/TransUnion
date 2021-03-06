//
//  IntermediateResultsViewController.swift
//  TransUnion
//
//  Created by Vanessa Forney on 5/7/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation
import UIKit
import Koloda

private var numberOfCards: UInt = 4

class IntermediateResultsViewController: UIViewController {
    var totalLoanAmount = 0
    var creditEvents: [String:Int] = [:]
    var purchases:[String: Int] = [:]

    var score: Score!
    var earnings = 0
    var losses = 0
    var remainingLoans = [Loan]()

    @IBOutlet weak var kolodaView: KolodaView!

    private var dataSource: Array<UIImage> = {
        var array: Array<UIImage> = []
        for index in 0..<numberOfCards {
            array.append(UIImage(named: "Card_like_\(index + 1)")!)
        }

        return array
    }()

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        kolodaView.dataSource = self
        kolodaView.delegate = self

        //        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
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

    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
}

//MARK: KolodaViewDelegate
extension IntermediateResultsViewController: KolodaViewDelegate {

    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        //TODO: VANESSA HELP Handle run out of cards here i.e. open another view.
        let storyboard = UIStoryboard(name: "EventsAndPurchases", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! EventsAndPurchasesViewController
        vc.score = score
        vc.earnings = earnings
        vc.losses = losses
        vc.remainingLoans = remainingLoans
        vc.totalLoanAmount = totalLoanAmount
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.window?.rootViewController = vc
    }

    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
    }
}

//MARK: KolodaViewDataSource
extension IntermediateResultsViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(dataSource.count)
    }

    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        return UIImageView(image: dataSource[Int(index)])
    }

    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverlayView",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
}

