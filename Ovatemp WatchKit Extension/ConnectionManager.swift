//
//  ConnectionManager.swift
//  Ovatemp
//
//  Created by Arun Venkatesan on 1/20/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import Foundation

public typealias StatusRequestCompletionBlock = (fertility: Fertility, error: NSError?) -> ()
public typealias PeriodStateRequestCompletionBlock = (status: PeriodState, error: NSError?) -> ()
public typealias FluidStateRequestCompletionBlock = (status: FluidState, error: NSError?) -> ()
public typealias PositionStateRequestCompletionBlock = (status: PositionState, error: NSError?) -> ()

public typealias CurrentDayUpdateBlock = (day : Day?, error: NSError?) -> ()
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
    
    public func updateCurrentDay(completion: CurrentDayUpdateBlock) {
        
        if let userToken = Session.retrieveUserTokenFromDefaults(), deviceId = Session.retrieveDeviceIdFromDefaults() {

            let dateFormatter = createDateFormatter()
            let todayDate = todayDateString()
            
            let urlString = "\(baseUrl)/cycles?date=\(todayDate)&&token=\(userToken)&&device_id=\(deviceId)"
            let URL: NSURL = NSURL(string: urlString)!
            let request = NSMutableURLRequest(URL: URL)
            
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
                                completion(day: self.selectedDay, error: nil)
                            }
                        }
                        
                    }else{
                        println("CONNECTION MANAGER : ERROR PARSING JSON: \(JSONError)")
                        completion(day: nil, error: JSONError)
                    }
                }else{
                    println("CONNECTION MANAGER : ERROR WITH REQUEST : \(error)")
                    completion(day: nil, error: error)
                }
            })
            
            task.resume()
            
        }else{
            println("CONNECTION MANAGER : USER IS NOT LOGGED IN")
        }
        
    }
    
//    public func requestFertilityStatus(completion: StatusRequestCompletionBlock) {
//        
//        if let userToken = self.userToken, deviceId = self.deviceId {
//        
//            let dateFormatter = createDateFormatter()
//            let todayDate = todayDateString()
//            
//            let urlString = "\(baseUrl)/cycles?date=\(todayDate)&&token=\(userToken)&&device_id=\(deviceId)"
//            let URL: NSURL = NSURL(string: urlString)!
//            let request = NSMutableURLRequest(URL: URL)
//            
//            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//                
//                if (error == nil) {
//
//                    var JSONError: NSError?
//                    let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &JSONError) as! NSDictionary
//                    
//                    if (JSONError == nil) {
//                        
//                        println("CONNECTION MANAGER : SUCCESS : REQUEST FERTILITY STATUS")
//                        
//                        let dateFormatter = self.createDateFormatter()
//                        let todayDate = dateFormatter.stringFromDate(NSDate())
//                        let dayArray = responseDict["days"] as! NSArray
//                        
//                        for day in dayArray {
//                            
//                            let dateInfo = day["date"] as? String
//                            let peakDate = dateFormatter.dateFromString(responseDict["peak_date"] as! String)
//                            
//                            if(dateInfo == todayDate) {
//                                let fertility : Fertility = self.fertilityForDay(day as! NSDictionary, peakDate: peakDate!)
//                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                    completion(fertility: fertility, error: nil)
//                                })
//                            }
//                        }
//                        
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            completion(fertility: Fertility(status: FertilityStatus.empty, cycle: FertilityCycle.empty), error: nil)
//                        })
//                        
//                    } else {
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            completion(fertility: Fertility(status: FertilityStatus.empty, cycle: FertilityCycle.empty), error: nil)
//                        })
//                    }
//                } else {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        completion(fertility: Fertility(status: FertilityStatus.empty, cycle: FertilityCycle.empty), error: nil)
//                    })
//                }
//            })
//            
//            task.resume()
//            
//        }else{
//            println("APPLE WATCH : CONNECTION MANAGER : USER IS NOT LOGGED IN")
//        }
//        
//    }
//    
//    public func requestPeriodStatus(completion: PeriodStateRequestCompletionBlock) {
//        
//        if let userToken = self.userToken, deviceId = self.deviceId {
//            
//            let dateFormatter = createDateFormatter()
//            let todayDate = todayDateString()
//            
//            let urlString = "\(baseUrl)/cycles?date=\(todayDate)&&token=\(userToken)&&device_id=\(deviceId)"
//            let URL: NSURL = NSURL(string: urlString)!
//            let request = NSMutableURLRequest(URL: URL)
//            
//            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//                if (error == nil) {
//                    
//                    var JSONError: NSError?
//                    let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &JSONError) as! NSDictionary
//                    
//                    if (JSONError == nil) {
//                        
//                        println("CONNECTION MANAGER : SUCCESS : REQUEST PERIOD STATUS")
//                        
//                        let dayArray = responseDict["days"] as! NSArray
//                        for day in dayArray {
//                            
//                            let dateInfo = day["date"] as? String
//                            if(dateInfo == todayDate) {
//                                
//                                let periodStatus = day["period"] as? String
//                                
//                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                    completion(status: self.periodStateForString(periodStatus!), error: nil)
//                                })
//                                
//                            }
//                        }
//                        
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            completion(status: PeriodState.noData, error: nil)
//                        })
//                        
//                    } else {
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            completion(status: PeriodState.noData, error: nil)
//                        })
//                        
//                    }
//                } else {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        completion(status: PeriodState.noData, error: nil)
//                    })
//                    
//                }
//            })
//            
//            task.resume()
//            
//        }else{
//            println("CONNECTION MANAGER : USER IS NOT LOGGED IN")
//        }
//        
//    }
//    
//    public func requestFluidStatus(completion: FluidStateRequestCompletionBlock) {
//        
//        if let userToken = self.userToken, deviceId = self.deviceId{
//            
//            let dateFormatter = createDateFormatter()
//            let todayDate = todayDateString()
//            
//            let urlString = "\(baseUrl)/cycles?date=\(todayDate)&&token=\(userToken)&&device_id=\(deviceId)"
//            let URL: NSURL = NSURL(string: urlString)!
//            let request = NSMutableURLRequest(URL: URL)
//            
//            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//                if (error == nil) {
//                    
//                    var JSONError: NSError?
//                    let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &JSONError) as! NSDictionary
//                    
//                    if (JSONError == nil) {
//                        
//                        println("CONNECTION MANAGER : SUCCESS : REQUEST FLUID STATUS")
//                        
//                        let dayArray = responseDict["days"] as! NSArray
//                        for day in dayArray {
//                            
//                            let dateInfo = day["date"] as? String
//                            if(dateInfo == todayDate) {
//                                
//                                let fluidStatus = day["cervical_fluid"] as? String
//                                
//                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                    completion(status: self.fluidStateForString(fluidStatus!), error: nil)
//                                })
//                                
//                            }
//                        }
//                        
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            completion(status: FluidState.noData, error: nil)
//                        })
//                        
//                    } else {
//                        
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            completion(status: FluidState.noData, error: nil)
//                        })
//                        
//                    }
//                } else {
//                    
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        completion(status: FluidState.noData, error: nil)
//                    })
//                    
//                }
//            })
//            
//            task.resume()
//            
//        }else{
//            println("CONNECTION MANAGER : USER IS NOT LOGGED IN")
//        }
//        
//    }
//    
//    public func requestPositionStatus(completion: PositionStateRequestCompletionBlock) {
//        
//        if let userToken = self.userToken, deviceId = self.deviceId{
//            
//            let dateFormatter = createDateFormatter()
//            let todayDate = todayDateString()
//            
//            let urlString = "\(baseUrl)/cycles?date=\(todayDate)&&token=\(userToken)&&device_id=\(deviceId)"
//            let URL: NSURL = NSURL(string: urlString)!
//            let request = NSMutableURLRequest(URL: URL)
//            
//            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//                if (error == nil) {
//                    
//                    var JSONError: NSError?
//                    let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &JSONError) as! NSDictionary
//                    
//                    if (JSONError == nil) {
//                        
//                        println("CONNECTION MANAGER : SUCCESS : REQUEST POSITION STATUS")
//                        
//                        let dayArray = responseDict["days"] as! NSArray
//                        for day in dayArray {
//                            
//                            let dateInfo = day["date"] as? String
//                            if(dateInfo == todayDate) {
//                                
//                                let positionStatus = day["cervical_position"] as? String
//                                
//                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                    completion(status: self.positionStateForString(positionStatus!), error: nil)
//                                })
//
//                            }
//                        }
//                        
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            completion(status: PositionState.noData, error: nil)
//                        })
//                        
//                    } else {
//                        
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            completion(status: PositionState.noData, error: nil)
//                        })
//                        
//                    }
//                } else {
//                    
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        completion(status: PositionState.noData, error: nil)
//                    })
//                    
//                }
//            })
//            
//            task.resume()
//            
//        }else{
//            println("CONNECTION MANAGER : USER IS NOT LOGGED IN")
//        }
//        
//    }
    
    public func updateFertilityData(data: String, completion: UpdateCompletionBlock) {
        
        let todayDate = NSDate()
        
        let urlString = "\(baseUrl)/days/"
        let URL: NSURL = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "PUT"
        
        var putData = data+"&token=09dfc3dd91409fc838d8180b777cf2ea&&device_id=58504179-52EC-4298-B276-E20053D7393C"
        request.HTTPBody = putData.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: true, error: error)
            })
            
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