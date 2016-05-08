//
//  FinalResultsViewController.swift
//  TransUnion
//
//  Created by Vanessa Forney on 5/7/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import UIKit

class FinalResultsViewController: UIViewController {

    var score: Score!
    var earnings = 750
    var losses = 300

    @IBOutlet weak var scoreView: UIWebView!
    @IBOutlet weak var earningsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBAction func backToMenuAction(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTitle.font = UIFont(name: "IntroSemiBold", size: 20.0)
        descriptionTextView.font = UIFont(name: "IntroSemiBold", size: 14.0)!
        descriptionTextView.editable = false
        descriptionTextView.scrollEnabled = false

        score = Score(value: 760)
        scoreView.delegate = self

        if let path = NSBundle.mainBundle().pathForResource("index", ofType: "html") {
            let urlPath = NSURL.fileURLWithPath(path)
            do {
                let contents = try NSString(contentsOfURL: urlPath, encoding: NSUTF8StringEncoding)
                self.scoreView.loadHTMLString(contents as String, baseURL: urlPath)
            }
            catch { }
        }

        earningsLabel.text = "$\(earnings)"
        lossesLabel.text = "$\(losses)"
        descriptionTitle.text = score.getTitle()
        descriptionTextView.text = score.getDescription()
    }

}

extension FinalResultsViewController: UIWebViewDelegate {

    func webViewDidFinishLoad(webView: UIWebView) {
        self.scoreView.stringByEvaluatingJavaScriptFromString("showData(\(self.score.value))")
    }

}