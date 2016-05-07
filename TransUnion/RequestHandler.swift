//
//  RequestHandler.swift
//  TransUnion
//
//  Created by Russ Fenenga on 5/6/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

struct RequestHandler {
    typealias responseData = (data:NSArray?) -> Void
    
    static func dataForLifeEvent(lifeEvent: LifeEvent, score: Int, completion: responseData) {
        let config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session: NSURLSession = NSURLSession(configuration: config)
        var url = NSURL(string: "http://ec2-52-53-177-180.us-west-1.compute.amazonaws.com/score-simulator/scoresim/simulateScore")
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "POST"
        let requestDictionary = [
            "score" : score,
            "event" : "TUCI 2016 Hackathon Score Simulator",
        ]
    }
}
