//
//  Simulator.swift
//  TransUnion
//
//  Created by Vanessa Forney on 5/6/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

struct Option {

  static let ADD_NEW_STUDENT_LOAN = "ADD_NEW_STUDENT_LOAN"
  static let LOANS_DUE = "LOANS_DUE"
  static let PAY_LOANS_ON_TIME = "PAY_LOANS_ON_TIME"
  static let PAY_STUDENT_LOANS_30_DAYS_LATE = "PAY_STUDENT_LOANS_30_DAYS_LATE"
  static let BUY_HOUSE = "BUY_HOUSE"
  static let BUY_CAR = "BUY_CAR"
  static let PAY_DOWN_DEBT = "PAY_DOWN_DEBT"
  static let LATE_30_DAYS = "LATE_30_DAYS"
  static let LATE_60_DAYS = "LATE_60_DAYS"
  static let LATE_90_DAYS = "LATE_90_DAYS"
  static let DEFAULT_ON_LOAN = "DEFAULT_ON_LOAN"
  static let GO_TO_COLLECTIONS = "GO_TO_COLLECTIONS"
  static let FILE_BANKRUPTCY = "FILE_BANKRUPTCY"
  static let SEEK_LOANS = "SEEK_LOANS"
  static let MAX_EXISTING_CREDIT = "MAX_EXISTING_CREDIT"
  static let PAY_EXPENSE = "PAY_EXPENSE"
  static let EFFECTS_SCORE = "EFFECTS_SCORE"
  static let NO_EFFECT_ON_SCORE = "NO_EFFECT_ON_SCORE"
  static let HOME_EQUITY_LINE = "HOME_EQUITY_LINE"
  static let EX_TRASHES_YOUR_CREDIT = "EX_TRASHES_YOUR_CREDIT"
  static let BANKRUPT = "BANKRUPT"
  static let CREDIT_IS_IRRELEVANT = "CREDIT_IS_IRRELEVANT"
  static let THIEF_OPENS_CREDIT = "THIEF_OPENS_CREDIT"
  static let POSSIBLE_IDENTITY_STOLEN = "POSSIBLE_IDENTITY_STOLEN"
  static let POSSIBLE_CREDIT_CARD_INFO_STOLEN = "POSSIBLE_CREDIT_CARD_INFO_STOLEN"
  static let IDENTITY_STOLEN = "IDENTITY_STOLEN"
  static let REPORTED = "REPORTED"
  static let CREDIT_LIMIT_MAXED = "CREDIT_LIMIT_MAXED"
  static let TAKE_SELFIE_WITH_DRIVERS_LICENSE = "TAKE_SELFIE_WITH_DRIVERS_LICENSE"
  static let DEFAULT_OR_FORECLOSURE = "DEFAULT_OR_FORECLOSURE"

}

enum LifeEvent {

  case StartCollege, GraduateCollege, NewJobHigherIncome, NewJobLowerIncome, UnexpectedMedicalExpense,
    MariageBadSpousalCredit, MarraigeAmazingSpousalCredit, BigMortgage, Divorce, WinLargeSum, Bankruptcy,
    ZombieApocalypse, IdentifyTheft, DUI, BreachAtNetflix, ForgetToShredMail, StolenDebitCard, StolenCC,
    BadWaiter, MisusePII

  static let allLifeEvents = [StartCollege, GraduateCollege, NewJobHigherIncome, NewJobLowerIncome, UnexpectedMedicalExpense,
                              MariageBadSpousalCredit, MarraigeAmazingSpousalCredit, BigMortgage, Divorce, WinLargeSum, Bankruptcy,
                              ZombieApocalypse, IdentifyTheft, DUI, BreachAtNetflix, ForgetToShredMail, StolenDebitCard, StolenCC,
                              BadWaiter, MisusePII]

  static let lifeEventToRequest = [StartCollege: "start_college", GraduateCollege: "graduate_college",
                                   NewJobHigherIncome: "new_job-higher_income", NewJobLowerIncome: "new_job-lower_income",
                                   UnexpectedMedicalExpense: "UnexpectedMedicalExpense", MariageBadSpousalCredit: "marraige-bad_spousal_credit",
                                   MarraigeAmazingSpousalCredit: "marriage-amazing_spousal_credit", BigMortgage: "big_mortgage",
                                   Divorce: "divorce", WinLargeSum: "win_large_sum", Bankruptcy: "bankruptcy",
                                   ZombieApocalypse: "zombie_apocalypse", IdentifyTheft: "identity_theft", DUI: "DUI",
                                   BreachAtNetflix: "breach_at_netflix", ForgetToShredMail: "forgot_to_shred_mail",
                                   StolenDebitCard: "stolen_debit_card", StolenCC: "stolen_cc", BadWaiter: "bad_waiter", MisusePII: "misuse-pii"]


  static let lifeEventToOptions: [LifeEvent: [String]] = [
    StartCollege: [Option.ADD_NEW_STUDENT_LOAN],
    GraduateCollege: [Option.LOANS_DUE, Option.PAY_LOANS_ON_TIME, Option.PAY_STUDENT_LOANS_30_DAYS_LATE],
    NewJobHigherIncome: [Option.BUY_HOUSE, Option.BUY_CAR, Option.PAY_DOWN_DEBT],
    NewJobLowerIncome: [Option.ADD_NEW_STUDENT_LOAN, Option.LATE_30_DAYS, Option.LATE_60_DAYS, Option.LATE_90_DAYS, Option.DEFAULT_ON_LOAN, Option.GO_TO_COLLECTIONS, Option.FILE_BANKRUPTCY],
    UnexpectedMedicalExpense: [Option.SEEK_LOANS, Option.MAX_EXISTING_CREDIT, Option.GO_TO_COLLECTIONS, Option.PAY_EXPENSE],
    MariageBadSpousalCredit: [Option.NO_EFFECT_ON_SCORE, Option.EFFECTS_SCORE],
    MarraigeAmazingSpousalCredit: [Option.NO_EFFECT_ON_SCORE, Option.EFFECTS_SCORE],
    BigMortgage: [Option.HOME_EQUITY_LINE, Option.DEFAULT_OR_FORECLOSURE],
    Divorce: [Option.NO_EFFECT_ON_SCORE, Option.EX_TRASHES_YOUR_CREDIT],
    WinLargeSum: [Option.NO_EFFECT_ON_SCORE],
    Bankruptcy: [Option.BANKRUPT],
    ZombieApocalypse: [Option.CREDIT_IS_IRRELEVANT],
    IdentifyTheft: [Option.THIEF_OPENS_CREDIT],
    DUI: [Option.NO_EFFECT_ON_SCORE],
    BreachAtNetflix: [Option.POSSIBLE_IDENTITY_STOLEN, Option.POSSIBLE_CREDIT_CARD_INFO_STOLEN],
    ForgetToShredMail: [Option.IDENTITY_STOLEN],
    StolenDebitCard: [Option.REPORTED],
    StolenCC: [Option.CREDIT_LIMIT_MAXED],
    BadWaiter: [Option.REPORTED],
    MisusePII: [Option.TAKE_SELFIE_WITH_DRIVERS_LICENSE]
  ]

  func getRequest() -> String {
    return LifeEvent.lifeEventToRequest[self]!
  }

  func getOptions() -> [String] {
    return LifeEvent.lifeEventToOptions[self]!
  }
}