//
//  Day.swift
//  Ovatemp
//
//  Created by Daniel Lozano on 4/15/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import UIKit

public class Day {
   
    var dayId : Int?
    var date : String?

    var inFertilityWindow : Bool?
    var cyclePeakDate : NSDate?
    
    var cyclePhase : String?
    var period : String?
    var cervicalFluid : String?
    var cervicalPosition : String?
    
    let dateFormatter = Day.createDateFormatter()
    
    convenience init () {
        self.init(response: nil, peakDate: nil)
    }
    
    init(response : Dictionary<String, AnyObject>?, peakDate : NSDate?) {
        
        if let tempResponse = response {
            
            dayId = tempResponse["id"] as? Int
            date = tempResponse["date"] as? String
            
            inFertilityWindow = tempResponse["in_fertility_window"] as? Bool
            
            cyclePhase = tempResponse["cycle_phase"] as? String
            period = tempResponse["period"] as? String
            cervicalFluid = tempResponse["cervical_fluid"] as? String
            cervicalPosition = tempResponse["cervical_position"] as? String

        }
        
        cyclePeakDate = peakDate
        
    }
    
    func fertilityForDay () -> Fertility {
        
        // Check Fertility Window
        
        if(cyclePhase == "period") {
            // result is PERIOD
            return Fertility(status: FertilityStatus.period, cycle: FertilityCycle.period)
        }
        
        if let inFertilityWindow = inFertilityWindow {
            
            if inFertilityWindow{
                if cervicalFluid == "eggwhite"{
                    // Peak fertility
                    return Fertility(status: FertilityStatus.peakFertility, cycle: FertilityCycle.empty)
                    
                }else{
                    // Regular fertility
                    return Fertility(status: FertilityStatus.fertile, cycle: FertilityCycle.empty)
                }
            }
            
        }
        
        // Check Cycle Phases
        
        if(cyclePhase == "ovulation") {
            
            if(date == dateFormatter.stringFromDate(cyclePeakDate!)) {
                // result is PEAK FERTILITY
                return Fertility(status: FertilityStatus.peakFertility, cycle: FertilityCycle.ovulation)
                
            } else {
                // result is FERTILE
                return Fertility(status: FertilityStatus.fertile, cycle: FertilityCycle.ovulation)
            }
            
        } else if(cyclePhase == "preovulation") {
            // result is (generally) NOT FERTILE
            
            let userType = Session.retrieveUserTypeFromDefaults()
            
            if cervicalFluid == "sticky" && userType == "TTA"{
                // FERTILE
                return Fertility(status: FertilityStatus.fertile, cycle: FertilityCycle.preovulation)
                
            }else{
                // NOT FERTILE
                return Fertility(status: FertilityStatus.notFertile, cycle: FertilityCycle.preovulation)
            }
            
            
        } else if(cyclePhase == "postovulation") {
            // result is NOT FERTILE
            return Fertility(status: FertilityStatus.notFertile, cycle: FertilityCycle.postovulation)
            
        } else {
            // result is NO DATA
            return Fertility(status: FertilityStatus.empty, cycle: FertilityCycle.empty)
        }
        
    }
    
    func periodStateForDay () -> PeriodState {
        
        if(period == "none") {
            return PeriodState.none
            
        } else if(period == "spotting") {
            return PeriodState.spotting
            
        } else if(period == "light") {
            return PeriodState.light
            
        } else if(period == "medium") {
            return PeriodState.medium
            
        } else if(period == "heavy") {
            return PeriodState.heavy
            
        }  else {
            return PeriodState.noData
        }
        
    }
    
    func fluidStateForDay () -> FluidState {
        
        if(cervicalFluid == "dry") {
            return FluidState.dry
            
        } else if(cervicalFluid == "sticky") {
            return FluidState.sticky
            
        } else if(cervicalFluid == "creamy") {
            return FluidState.creamy
            
        } else if(cervicalFluid == "eggwhite") {
            return FluidState.eggwhite
            
        } else {
            return FluidState.noData
        }
        
    }
    
    func positionStateForDay () -> PositionState {
        
        if (cervicalPosition == "low/closed/firm") {
            return PositionState.lowClosedFirm
            
        }else if(cervicalPosition == "high/open/soft") {
            return PositionState.highOpenSoft
            
        }else{
            return PositionState.noData
        }
        
    }
    
    // Mark: Helpers
    
    class func createDateFormatter () -> NSDateFormatter{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }
    
}
