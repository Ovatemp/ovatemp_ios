//
//  ConnectionManager.swift
//  Ovatemp
//
//  Created by Arun Venkatesan on 1/20/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import Foundation

public typealias StatusRequestCompletionBlock = (status: FertilityStatus, error: NSError?) -> ()

public enum FertilityStatus {
    case empty
    case period
    case peakFertility
    case fertile
    case notFertile
    case caution
}

public class ConnectionManager {
    
    let session: NSURLSession
    
    public init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configuration);
    }
    
    public func requestFertilityStatus(completion: StatusRequestCompletionBlock) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.stringFromDate(NSDate())
        
        let URL: NSURL = NSURL(string: "http://ovatemp-api-staging.herokuapp.com/api/cycles?date=\(todayDate))&token=09dfc3dd91409fc838d8180b777cf2ea&&device_id=58504179-52EC-4298-B276-E20053D7393C")!
        
        let request = NSMutableURLRequest(URL:URL)
        request.addValue("application/json; version=2", forHTTPHeaderField:"Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                var JSONError: NSError?
                let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &JSONError) as NSDictionary
                if JSONError == nil {
                    
                    let peakDate = dateFormatter.dateFromString(responseDict["peak_date"] as NSString)
                    
                    let dayArray = responseDict["days"] as NSArray
                    
                    for day in dayArray {
                        
                        let dateInfo = day["date"] as String
                        
                        if(dateInfo == todayDate) {
                            
                            println("day data: \(day)") // printing log for testing
                            
                            if(day["in_fertility_window"] as Bool == true) {
                                
                                if(day["cervical_fluid"] as String == "sticky") {
                                    
                                    // IF in_fertility_window AND cervical_fluid = sticky
                                    // result is PEAK FERTILITY
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        completion(status: FertilityStatus.peakFertility, error: nil)
                                    })
                                } else {
                                    
                                    // IF in_fertility_window
                                    // result is FERTILE
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        completion(status: FertilityStatus.fertile, error: nil)
                                    })
                                }
                            } else {
                                
                                if(day["cycle_phase"] as String == "period") {
                                    
                                    // IF cycle_phase = period 
                                    // result is PERIOD
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        completion(status: FertilityStatus.period, error: nil)
                                    })
                                } else if(day["cycle_phase"] as String == "ovulation") {
                                    
                                    if(day["date"] as String == dateFormatter.stringFromDate(peakDate!)) {
                                        
                                        // IF cycle_phase = ovulation AND peak_date = selected date
                                        // result is PEAK FERTILITY
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            completion(status: FertilityStatus.peakFertility, error: nil)
                                        })
                                    } else {
                                        
                                        // IF cycle_phase = ovulation
                                        // result is FERTILE
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            completion(status: FertilityStatus.fertile, error: nil)
                                        })
                                    }
                                } else if(day["cycle_phase"] as String == "preovulation") {
                                    
                                    // IF cycle_phase = preovulation
                                    // result is NOT FERTILE
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        completion(status: FertilityStatus.notFertile, error: nil)
                                    })
                                    
                                } else if(day["cycle_phase"] as String == "postovulation") {
                                    
                                    // IF cycle_phase = postovulation
                                    // result is NOT FERTILE
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        completion(status: FertilityStatus.notFertile, error: nil)
                                    })
                                    
                                } else {
                                    
                                    // result is NO DATA
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        completion(status: FertilityStatus.empty, error: nil)
                                    })
                                }
                            }
                            
                            return
                        }
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(status: FertilityStatus.empty, error: nil)
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(status: FertilityStatus.empty, error: nil)
                })
            }
        })
        task.resume()
  }
}