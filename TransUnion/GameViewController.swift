//
//  GameViewController.swift
//  TransUnion
//
//  Created by Vanessa Forney on 5/6/16.
//  Copyright (c) 2016 Vanessa Forney. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var score: Score!
    var earnings = 0
    var losses = 0
    var remainingLoans = [Loan]()
    
    var timer = NSTimer()
    var scene: GameScene?

    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var scoreView: UIWebView!
    @IBOutlet weak var earningsLabel: UILabel!
    @IBOutlet weak var debtLabel: UILabel!
    @IBOutlet weak var progressImage: UIImageView!
    @IBOutlet weak var pauseButton: UIButton!

    @IBAction func pauseButtonAction(sender: AnyObject) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        displayView.hidden = true

        scene = GameScene(fileNamed:"GameScene")
        if let scene = scene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            //skView.showsPhysics = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            scene.viewController = self
            scoreView.delegate = self
            skView.presentScene(scene)

            RequestHandler.dataForLifeEvent(LifeEvent.ZombieApocalypse, option: "CREDIT_IS_IRRELEVANT", score: 710) { (score:Int!, descprition: NSArray!) in
                print(score)
                print(descprition)
            }
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func endRound() {
        performSegueWithIdentifier("toIntermediateResults", sender: nil)
    }

    func gameOver() {
        performSegueWithIdentifier("toFinalResults", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toFinalResults" {
            let vc = segue.destinationViewController as! FinalResultsViewController
            let score = Score(value: scene!.creditScore)
            vc.score = score
            vc.earnings = earnings
            vc.losses = losses
        } else if segue.identifier == "toIntermediateResults" {
            let vc = segue.destinationViewController as! IntermediateResultsViewController
            let score = Score(value: scene!.creditScore)
            vc.score = score
            vc.earnings = earnings
            vc.losses = losses
            vc.remainingLoans = remainingLoans
        }
        scene!.nilAll()
    }
}


extension GameViewController: UIWebViewDelegate {

    func webViewDidFinishLoad(webView: UIWebView) {
     //   scoreView.stringByEvaluatingJavaScriptFromString("showData(\(self.scene.score.value))")
    }
    
}
