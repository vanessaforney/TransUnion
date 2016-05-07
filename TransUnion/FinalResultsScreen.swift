//
//  FinalResultsScreen.swift
//  TransUnion
//
//  Created by Vanessa Forney on 5/6/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import SpriteKit

class FinalResultsScreen: SKScene {

  var score: Int?
  var gameSceneSize: CGSize?

  init(score: Int, size: CGSize) {
    super.init()

    self.score = score
    self.size = size
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(size: CGSize) {
    super.init(size: size)
  }

  override func didMoveToView(view: SKView) {
    backgroundColor = UIColor.lightGrayColor()

    let finalScore = SKLabelNode(fontNamed: "Intro")
    finalScore.text = "Final Score"
    finalScore.fontSize = 30
    finalScore.fontColor = UIColor.blackColor()
    finalScore.position = CGPoint(x: 200, y: frame.midY + 200)
    self.addChild(finalScore)

    let storyboard = UIStoryboard(name: "FinalResults", bundle: nil)
    let vc = storyboard.instantiateInitialViewController()!
    view.addSubview(vc.view)
  }

}