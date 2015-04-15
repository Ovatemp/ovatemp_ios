//
//  ConnectionManager.swift
//  Ovatemp
//
//  Created by Arun Venkatesan on 1/20/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import Foundation

//public typealias StatusRequestCompletionBlock = (fertility: Fertility, error: NSError?) -> ()
//public typealias PeriodStateRequestCompletionBlock = (status: PeriodState, error: NSError?) -> ()
//public typealias FluidStateRequestCompletionBlock = (status: FluidState, error: NSError?) -> ()
//public typealias PositionStateRequestCompletionBlock = (status: PositionState, error: NSError?) -> ()

public typealias UpdateCompletionBlock = (success: Bool, error: NSError?) -> ()

public enum FertilityStatus {
    case empty
    case period
    case peakFertility
    case fertile
    case notFertile
    case caution
}

public enum FertilityCycle {
    case empty
    case period
    case ovulation
    case preovulation
    case postovulation
}

public struct Fertility {
    
    var fertilityStatus: FertilityStatus
    var fertilityCycle: FertilityCycle
    
    init() {
        fertilityStatus = FertilityStatus.empty
        fertilityCycle = FertilityCycle.empty
    }
    
    init(status: FertilityStatus, cycle: FertilityCycle) {
        fertilityStatus = status
        fertilityCycle = cycle
    }
}

private let _ConnectionManagerSharedInstance = ConnectionManager()

public class ConnectionManager {
    
    let session: NSURLSession
    let baseUrl = "http://ovatemp-api-staging.herokuapp.com/api"
    
    var selectedDay : Day = Day(response: nil, peakDate: nil)
    var peakDate : NSDate?
    
    let sharedDefaults = NSUserDefaults(suiteName: "group.com.ovatemp.ovatemp")
    
    class var sharedInstance: ConnectionManager {
        return _ConnectionManagerSharedInstance
    }
    
    public init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Accept" : "application/json; version=2"]
        session = NSURLSession(configuration: configuration);
    }
    
    public func updateCurrentDay(completion: UpdateCompletionBlock) {
        
        if let userToken = Session.retrieveUserTokenFromDefaults(), deviceId = Session.retrieveDeviceIdFromDefaults() {

            let dateFormatter = createDateFormatter()
            let todayDate = todayDateString()
            
            let urlString = "\(baseUrl)/cycles?date=\(todayDate)&&token=\(userToken)&&device_id=\(deviceId)"
            let URL: NSURL = NSURL(string: urlString)!
            let request = NSMutableURLRequest(URL: URL)
            
            startDataTaskWithRequest(request, completion: completion)
            
        }else{
            println("CONNECTION MANAGER : USER IS NOT LOGGED IN")
        }
        
    }
    
    public func updateFertilityData(data: String, completion: UpdateCompletionBlock) {
        
        if let userToken = Session.retrieveUserTokenFromDefaults(), deviceId = Session.retrieveDeviceIdFromDefaults() {
            
            let todayDate = NSDate()
            
            let urlString = "\(baseUrl)/days/"
            let URL: NSURL = NSURL(string: urlString)!
            
            let request = NSMutableURLRequest(URL: URL)
            request.HTTPMethod = "PUT"
            
            var putData = "\(data)&token=\(userToken)&device_id=\(deviceId)"
            request.HTTPBody = putData.dataUsingEncoding(NSUTF8StringEncoding)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            
            startDataTaskWithRequest(request, completion: completion)
            
        }else{
            println("CONNECTION MANAGER : USER IS NOT LOGGED IN")
        }
        
    }
    
    func startDataTaskWithRequest (request : NSURLRequest, completion : UpdateCompletionBlock ) {
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if (error == nil) {
                
                var JSONError: NSError?
                let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &JSONError) as! NSDictionary
                
                if (JSONError == nil) {
                    
                    println("CONNECTION MANAGER : UPDATE CURRENT DAY : SUCCESS")
                    
                    let dateFormatter = self.createDateFormatter()
                    let todayDate = dateFormatter.stringFromDate(NSDate())
                    let dayArray = responseDict["days"] as! NSArray
                    
                    for day in dayArray {
                        
                        let dateInfo = day["date"] as? String
                        let peakDate = dateFormatter.dateFromString(responseDict["peak_date"] as! String)
                        
                        if(dateInfo == todayDate) {
                            self.selectedDay = Day(response: day as? Dictionary<String, AnyObject>, peakDate: peakDate)
                            completion(success: true, error: nil)
                        }
                    }
                    
                }else{
                    println("CONNECTION MANAGER : ERROR PARSING JSON: \(JSONError)")
                    completion(success: false, error: JSONError)
                }
            }else{
                println("CONNECTION MANAGER : ERROR WITH REQUEST : \(error)")
                completion(success: false, error: error)
            }
            
        })
        
        task.resume()
        
    }
    
    // MARK: Helpers
    
    func createDateFormatter () -> NSDateFormatter{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }
    
    func todayDateString () -> NSString {
        return createDateFormatter().stringFromDate(NSDate())
    }
    
}