//
//  ConnectionManager.swift
//  Ovatemp
//
//  Created by Arun Venkatesan on 1/20/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import Foundation

public typealias StatusRequestCompletionBlock = (status: NSNumber?, error: NSError?) -> ()

public class ConnectionManager {
    
    let session: NSURLSession
    let URL = "http://ovatemp-api-staging.herokuapp.com/api/days?start_date=2015-01-20&end_date=2015-01-20&token=ea9716a030edc0d35fa2de9be4d63a57&device_id=8F44A8A7-B296-4822-95E2-D8A3B1DED8A3"
    
    public init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configuration);
    }
    
    public func requestFertilityStatus(completion: StatusRequestCompletionBlock) {
        
        let request = NSURLRequest(URL: NSURL(string: URL)!)
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                var JSONError: NSError?
                let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &JSONError) as NSDictionary
                if JSONError == nil {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        completion(price: price, error: nil)
//                    })
                    println("Response: \(responseDict)")
                } else {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        completion(status: nil, error: JSONError)
//                    })
                    println("Error parsing response.")
                }
            } else {
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    completion(status: nil, error: error)
//                })
                println("Error getting data.")
            }
        })
        task.resume()
  }
}