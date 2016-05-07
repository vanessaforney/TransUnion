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
            scoreView.backgroundColor = UIColor.clearColor()
            scoreView.opaque = false
            skView.presentScene(scene)

            RequestHandler.dataForLifeEvent(LifeEvent.ZombieApocalypse, option: "CREDIT_IS_IRRELEVANT", score: 710) { (score:Int!, descprition: NSArray!) in
                print(score)
                print(descprition)
            }

            if let path = NSBundle.mainBundle().pathForResource("smallIndex", ofType: "html") {
                let urlPath = NSURL.fileURLWithPath(path)
                do {
                    let contents = try NSString(contentsOfURL: urlPath, encoding: NSUTF8StringEncoding)
                    scoreView.loadHTMLString(contents as String, baseURL: urlPath)
                }
                catch { }
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

    func gameOver() {
        performSegueWithIdentifier("toFinalResults", sender: nil)
    }

    func reloadScore() {
        if scene?.creditScore > 300 && scene?.creditScore < 850 {
            if let path = NSBundle.mainBundle().pathForResource("smallIndex", ofType: "html") {
                let urlPath = NSURL.fileURLWithPath(path)
                do {
                    let contents = try NSString(contentsOfURL: urlPath, encoding: NSUTF8StringEncoding)
                    scoreView.loadHTMLString(contents as String, baseURL: urlPath)
                }
                catch { }
            }
        }
    }
}


extension GameViewController: UIWebViewDelegate {

    func webViewDidFinishLoad(webView: UIWebView) {
        scoreView.stringByEvaluatingJavaScriptFromString("showData(\(self.scene!.creditScore))")
    }
    
}
