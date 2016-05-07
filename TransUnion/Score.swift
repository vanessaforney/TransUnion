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

}