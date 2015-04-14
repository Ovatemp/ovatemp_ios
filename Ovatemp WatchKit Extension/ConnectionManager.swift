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
    
    func createDateFormatter () -> NSDateFormatter{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }
    
    func fertilityFoyResponse (day : NSDictionary, peakDate : NSDate) -> Fertility{
        
        let dateInfo = day["date"] as? String
        let dateFormatter = createDateFormatter()
        let todayDate = dateFormatter.stringFromDate(NSDate())
        
        if(dateInfo == todayDate) {
            
            println("day data: \(day)") // printing log for testing
            
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
        
        return Fertility(status: FertilityStatus.empty, cycle: FertilityCycle.empty)
        
    }
    
    public func requestFertilityStatus(completion: StatusRequestCompletionBlock) {
        
        let dateFormatter = createDateFormatter()
        let todayDate = dateFormatter.stringFromDate(NSDate())
        
        if let userToken = self.userToken, deviceId = self.deviceId {
            
            let urlString = "\(baseUrl)/cycles?date=\(todayDate)&&token=\(userToken)&&device_id=\(deviceId)"
            let URL: NSURL = NSURL(string: urlString)!
            let request = NSMutableURLRequest(URL: URL)
            
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                print(response)
                if (error == nil) {
                    var JSONError: NSError?
                    let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &JSONError) as! NSDictionary
                    if (JSONError == nil) {
                        
                        let dayArray = responseDict["days"] as! NSArray
                        let peakDate = dateFormatter.dateFromString(responseDict["peak_date"] as! String)
                        
                        for day in dayArray {
                            
                            ////////
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(fertility: Fertility(status: FertilityStatus.period, cycle: FertilityCycle.period), error: nil)
                            })
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
            print("APPLE WATCH : CONNECTION MANAGER : USER IS NOT LOGGED IN")
        }
        
    }
    
    public func requestPeriodStatus(completion: PeriodStateRequestCompletionBlock) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.stringFromDate(NSDate())
        
        let URL: NSURL = NSURL(string: "http://ovatemp-api-staging.herokuapp.com/api/cycles?date=\(todayDate))&token=c41c23ddec4ea1a53bbab4c8d92e2b53&&device_id=DUMMYDEVICE")!
        
        let request = NSMutableURLRequest(URL:URL)
        request.addValue("application/json; version=2", forHTTPHeaderField:"Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error == nil) {
                var JSONError: NSError?
                let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &JSONError) as! NSDictionary
                if (JSONError == nil) {
                    
                    let dayArray = responseDict["days"] as! NSArray
                    
                    for day in dayArray {
                        
                        let dateInfo = day["date"] as? String
                        
                        if(dateInfo == todayDate) {
                            
                            println("day period data: \(day)") // printing log for testing
                            
                            let periodStatus = day["period"] as? String
                            
                            var periodState = PeriodState.noData
                            
                            if(periodStatus == "none") {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: PeriodState.none, error: nil)
                                })
                                
                            } else if(periodStatus == "spotting") {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: PeriodState.spotting, error: nil)
                                })
                                
                            } else if(periodStatus == "light") {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: PeriodState.light, error: nil)
                                })
                                
                            } else if(periodStatus == "medium") {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: PeriodState.medium, error: nil)
                                })
                                
                            } else if(periodStatus == "heavy") {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: PeriodState.heavy, error: nil)
                                })
                                
                            }  else {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: PeriodState.noData, error: nil)
                                })
                                
                            }
                            
                            return
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
    }
    
    public func requestFluidStatus(completion: FluidStateRequestCompletionBlock) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.stringFromDate(NSDate())
        
        let URL: NSURL = NSURL(string: "http://ovatemp-api-staging.herokuapp.com/api/cycles?date=\(todayDate))&token=c41c23ddec4ea1a53bbab4c8d92e2b53&&device_id=DUMMYDEVICE")!
        
        let request = NSMutableURLRequest(URL:URL)
        request.addValue("application/json; version=2", forHTTPHeaderField:"Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error == nil) {
                var JSONError: NSError?
                let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &JSONError) as! NSDictionary
                if (JSONError == nil) {
                    
                    let dayArray = responseDict["days"] as! NSArray
                    
                    for day in dayArray {
                        
                        let dateInfo = day["date"] as? String
                        
                        if(dateInfo == todayDate) {
                            
                            println("day fluid data: \(day)") // printing log for testing
                            
                            let fluidStatus = day["cervical_fluid"] as? String
                            
                            var fluidState = FluidState.noData
                            
                            if(fluidStatus == "dry") {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: FluidState.dry, error: nil)
                                })
                                
                            } else if(fluidStatus == "sticky") {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: FluidState.sticky, error: nil)
                                })
                                
                            } else if(fluidStatus == "creamy") {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: FluidState.creamy, error: nil)
                                })
                                
                            } else if(fluidStatus == "eggwhite") {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: FluidState.eggwhite, error: nil)
                                })
                                
                            } else {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: FluidState.noData, error: nil)
                                })
                                
                            }
                            
                            return
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
    }
    
    public func requestPositionStatus(completion: PositionStateRequestCompletionBlock) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.stringFromDate(NSDate())
        
        let URL: NSURL = NSURL(string: "http://ovatemp-api-staging.herokuapp.com/api/cycles?date=\(todayDate))&token=c41c23ddec4ea1a53bbab4c8d92e2b53&&device_id=DUMMYDEVICE")!
        
        let request = NSMutableURLRequest(URL:URL)
        request.addValue("application/json; version=2", forHTTPHeaderField:"Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error == nil) {
                var JSONError: NSError?
                let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &JSONError) as! NSDictionary
                if (JSONError == nil) {
                    
                    let dayArray = responseDict["days"] as! NSArray
                    
                    for day in dayArray {
                        
                        let dateInfo = day["date"] as? String
                        
                        if(dateInfo == todayDate) {
                            
                            println("day position data: \(day)") // printing log for testing
                            
                            let positionStatus = day["cervical_position"] as? String
                            
                            var positionState = PositionState.noData
                            
                            if(positionStatus == "low/closed/firm") {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: PositionState.lowClosedFirm, error: nil)
                                })
                                
                            } else if(positionStatus == "high/open/soft") {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: PositionState.highOpenSoft, error: nil)
                                })
                                
                            } else {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(status: PositionState.noData, error: nil)
                                })
                                
                            }
                            
                            return
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
    }
    
    public func updateFertilityData(data: String, completion: UpdateCompletionBlock) {
        
        let todayDate = NSDate()
        
        let URL: NSURL = NSURL(string: "http://ovatemp-api-staging.herokuapp.com/api/days/")!
        
        let request = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "PUT"
        
        var putData = data+"&token=09dfc3dd91409fc838d8180b777cf2ea&&device_id=58504179-52EC-4298-B276-E20053D7393C"
        request.HTTPBody = putData.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.addValue("application/json; version=2", forHTTPHeaderField:"Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: true, error: error)
            })
        })
        task.resume()
    }
}