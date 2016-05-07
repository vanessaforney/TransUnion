//
//  RequestHandler.swift
//  TransUnion
//
//  Created by Russ Fenenga on 5/6/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import Foundation

struct RequestHandler {
    typealias responseData = (score:Int!, descprition: NSArray!) -> Void
    
    static func dataForLifeEvent(lifeEvent: LifeEvent, option: String, score: Int , completion: responseData) {
        let config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session: NSURLSession = NSURLSession(configuration: config)
        let url = NSURL(string: "http://ec2-52-53-177-180.us-west-1.compute.amazonaws.com/score-simulator/scoresim/simulateScore")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "POST"
        
        let eventDictionary = [
            "\(lifeEvent.getRequest())":option]
        
        let requestDictionary = [
            "score" : score,
            "event" : eventDictionary
        ]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(requestDictionary, options: [])
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // handle fundamental network errors (e.g. no connectivity)
            
            guard error == nil && data != nil else {
                print("ERROR")
                return
            }
            
            // check that http status code was 200
            
            if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode != 200 {
                print("GOOD")
            }
            
            // parse the JSON response
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                completion(score: json["score"] as! Int, descprition: json["description_text"] as!  NSArray)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        task.resume()
    }
}
