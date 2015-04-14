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

public class ConnectionManager {
    
    let session: NSURLSession
    
    var userToken: String?
    var deviceId: String?
    
    let baseUrl = "http://ovatemp-api-staging.herokuapp.com/api"
    
    public init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Accept" : "application/json; version=2"]
        session = NSURLSession(configuration: configuration);
    }
    
    public func requestFertilityStatus(completion: StatusRequestCompletionBlock) {
        
        if let userToken = self.userToken, deviceId = self.deviceId {
        
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
                        
                        println("CONNECTION MANAGER : SUCCESS : REQUEST FERTILITY STATUS")
                        
                        let dateFormatter = self.createDateFormatter()
                        let todayDate = dateFormatter.stringFromDate(NSDate())
                        let dayArray = responseDict["days"] as! NSArray
                        
                        for day in dayArray {
                            
                            let dateInfo = day["date"] as? String
                            let peakDate = dateFormatter.dateFromString(responseDict["peak_date"] as! String)
                            
                            if(dateInfo == todayDate) {
                                let fertility : Fertility = self.fertilityForDay(day as! NSDictionary, peakDate: peakDate!)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(fertility: fertility, error: nil)
                                })
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(fertility: Fertility(status: FertilityStatus.empty, cycle: FertilityCycle.empty), error: nil)
                        })
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(fertility: Fertility(status: FertilityStatus.empty, cycle: FertilityCycle.empty), error: nil)
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(fertility: Fertility(status: FertilityStatus.empty, cycle: FertilityCycle.empty), error: nil)
                    })
                }
            })
            
            task.resume()
            
        }else{
            println("APPLE WATCH : CONNECTION MANAGER : USER IS NOT LOGGED IN")
        }
        
    }
    
    public func requestPeriodStatus(completion: PeriodStateRequestCompletionBlock) {
        
        if let userToken = self.userToken, deviceId = self.deviceId {
            
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
                        
                        println("CONNECTION MANAGER : SUCCESS : REQUEST PERIOD STATUS")
                        
                        let dayArray = responseDict["days"] as! NSArray
                        for day in dayArray {
                            
                            let dateInfo = day["date"] as? String
                            if(dateInfo == todayDate) {
                                
                                let periodStatus = day["period"] as? String
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: self.periodStateForString(periodStatus!), error: nil)
                                })
                                
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(status: PeriodState.noData, error: nil)
                        })
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(status: PeriodState.noData, error: nil)
                        })
                        
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(status: PeriodState.noData, error: nil)
                    })
                    
                }
            })
            
            task.resume()
            
        }else{
            println("CONNECTION MANAGER : USER IS NOT LOGGED IN")
        }
        
    }
    
    public func requestFluidStatus(completion: FluidStateRequestCompletionBlock) {
        
        if let userToken = self.userToken, deviceId = self.deviceId{
            
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
                        
                        println("CONNECTION MANAGER : SUCCESS : REQUEST FLUID STATUS")
                        
                        let dayArray = responseDict["days"] as! NSArray
                        for day in dayArray {
                            
                            let dateInfo = day["date"] as? String
                            if(dateInfo == todayDate) {
                                
                                let fluidStatus = day["cervical_fluid"] as? String
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: self.fluidStateForString(fluidStatus!), error: nil)
                                })
                                
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(status: FluidState.noData, error: nil)
                        })
                        
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(status: FluidState.noData, error: nil)
                        })
                        
                    }
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(status: FluidState.noData, error: nil)
                    })
                    
                }
            })
            
            task.resume()
            
        }else{
            println("CONNECTION MANAGER : USER IS NOT LOGGED IN")
        }
        
    }
    
    public func requestPositionStatus(completion: PositionStateRequestCompletionBlock) {
        
        if let userToken = self.userToken, deviceId = self.deviceId{
            
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
                        
                        println("CONNECTION MANAGER : SUCCESS : REQUEST POSITION STATUS")
                        
                        let dayArray = responseDict["days"] as! NSArray
                        for day in dayArray {
                            
                            let dateInfo = day["date"] as? String
                            if(dateInfo == todayDate) {
                                
                                let positionStatus = day["cervical_position"] as? String
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: self.positionStateForString(positionStatus!), error: nil)
                                })

                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(status: PositionState.noData, error: nil)
                        })
                        
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(status: PositionState.noData, error: nil)
                        })
                        
                    }
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(status: PositionState.noData, error: nil)
                    })
                    
                }
            })
            
            task.resume()
            
        }else{
            println("CONNECTION MANAGER : USER IS NOT LOGGED IN")
        }
        
    }
    
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
    
    func fertilityForDay (day : NSDictionary, peakDate : NSDate) -> Fertility {
        
        let dateFormatter = createDateFormatter()
        
        if(day["cycle_phase"] as? String == "period") {
            // IF cycle_phase = period
            // result is PERIOD
            return Fertility(status: FertilityStatus.period, cycle: FertilityCycle.period)
            
        } else if(day["cycle_phase"] as? String == "ovulation") {
            
            if(day["date"] as? String == dateFormatter.stringFromDate(peakDate)) {
                // IF cycle_phase = ovulation AND peak_date = selected date
                // result is PEAK FERTILITY
                return Fertility(status: FertilityStatus.peakFertility, cycle: FertilityCycle.ovulation)
                
            } else {
                // IF cycle_phase = ovulation
                // result is FERTILE
                return Fertility(status: FertilityStatus.fertile, cycle: FertilityCycle.ovulation)
            }
            
        } else if(day["cycle_phase"] as? String == "preovulation") {
            // IF cycle_phase = preovulation
            // result is NOT FERTILE
            return Fertility(status: FertilityStatus.notFertile, cycle: FertilityCycle.preovulation)
            
        } else if(day["cycle_phase"] as? String == "postovulation") {
            // IF cycle_phase = postovulation
            // result is NOT FERTILE
            return Fertility(status: FertilityStatus.notFertile, cycle: FertilityCycle.postovulation)
            
        } else {
            // result is NO DATA
            return Fertility(status: FertilityStatus.empty, cycle: FertilityCycle.empty)
            
        }
        
    }
    
    func periodStateForString (statusString : String) -> PeriodState {
        
        if(statusString == "none") {
            return PeriodState.none
            
        } else if(statusString == "spotting") {
            return PeriodState.spotting
            
        } else if(statusString == "light") {
            return PeriodState.light
            
        } else if(statusString == "medium") {
            return PeriodState.medium
            
        } else if(statusString == "heavy") {
            return PeriodState.heavy
            
        }  else {
            return PeriodState.noData
        }
        
    }
    
    func fluidStateForString (statusString : String) -> FluidState {
        
        if(statusString == "dry") {
            return FluidState.dry
            
        } else if(statusString == "sticky") {
            return FluidState.sticky

        } else if(statusString == "creamy") {
            return FluidState.creamy
            
        } else if(statusString == "eggwhite") {
            return FluidState.eggwhite
            
        } else {
            return FluidState.noData
        }
        
    }
    
    func positionStateForString (positionString : String) -> PositionState {
        
        if (positionString == "low/closed/firm") {
            return PositionState.lowClosedFirm
            
        }else if(positionString == "high/open/soft") {
            return PositionState.highOpenSoft
            
        }else{
            return PositionState.noData
        }
        
    }
    
}