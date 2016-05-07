//
//  TransUnionModel.swift
//  TransUnion
//
//  Created by Vanessa Forney on 5/6/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

public class TransUnionModel {

  var users = [User]()

  func loadJson() {

    
  }

//  func loadJson() {
//    if let path = NSBundle.mainBundle().pathForResource("ChildsJSON", ofType: "json") {
//      if let data = NSData(contentsOfFile: path) {
//        let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
//        let address = json["Reports"]["SINGLE_REPORT_TU"]["NEW-CurrentAddr"]["TUC"][0]["address"].stringValue
//        let splitAddress = address.componentsSeparatedByString(" ")
//
//        user = User()
//        user?.date = json["Reports"]["SINGLE_REPORT_TU"]["ReportDate"]["TUC"].stringValue
//        user?.name = json["Reports"]["SINGLE_REPORT_TU"]["Name"]["TUC"].stringValue
//        user?.score = json["Reports"]["SINGLE_REPORT_TU"]["CreditScore"]["TUC"].intValue
//        user?.state = splitAddress[splitAddress.count - 2]
//        user?.total = json["Reports"]["SINGLE_REPORT_TU"]["TotalMonthlyPayments"]["TUC"].floatValue
//      }
//    }
//  }

}