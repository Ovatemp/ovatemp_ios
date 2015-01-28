//
//  PeriodPage.swift
//  Ovatemp
//
//  Created by Arun Venkatesan on 1/23/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import Foundation
import WatchKit

public enum PeriodState {
    case noData
    case none
    case spotting
    case light
    case medium
    case heavy
}


class PeriodPageViewController: WKInterfaceController {
    
    @IBOutlet weak var periodSelectionLabel: WKInterfaceLabel!
    @IBOutlet weak var periodSelectNoneButton: WKInterfaceButton!
    @IBOutlet weak var periodSelectSpottingButton: WKInterfaceButton!
    @IBOutlet weak var periodSelectLightButton: WKInterfaceButton!
    @IBOutlet weak var periodSelectMediumButton: WKInterfaceButton!
    @IBOutlet weak var periodSelectHeavyButton: WKInterfaceButton!
    
    var periodSelectedState = PeriodState.noData
    
    let connectionManager = ConnectionManager()
    
    var todayDate : String = ""
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
        
        self.todayDate = dateFormatter.stringFromDate(NSDate())
    }
    
    override func handleUserActivity(context: [NSObject : AnyObject]!) {
        
        if(context != nil) {
            
            super.becomeCurrentPage()
        }
    }
    
    func resetButtonImages() {
        
        self.periodSelectNoneButton.setBackgroundImageNamed("btn_period_none")
        self.periodSelectSpottingButton.setBackgroundImageNamed("btn_period_spotting")
        self.periodSelectLightButton.setBackgroundImageNamed("btn_period_light")
        self.periodSelectMediumButton.setBackgroundImageNamed("btn_period_medium")
        self.periodSelectHeavyButton.setBackgroundImageNamed("btn_period_heavy")
    }

    @IBAction func didSelectPeriodNone() {
        
        if(periodSelectedState == PeriodState.none) {
            
            self.updatePeriodData("", changeSelection: PeriodState.none)
        } else {
            
            self.updatePeriodData("none", changeSelection: PeriodState.none)
        }
    }
    
    @IBAction func didSelectPeriodSpotting() {
        
        if(periodSelectedState == PeriodState.spotting) {
            
            self.updatePeriodData("", changeSelection: PeriodState.spotting)
        } else {
            
            self.updatePeriodData("spotting", changeSelection: PeriodState.spotting)
        }
    }
    
    @IBAction func didSelectPeriodLight() {
        
        if(periodSelectedState == PeriodState.light) {
            
            self.updatePeriodData("", changeSelection: PeriodState.light)
        } else {
            
            self.updatePeriodData("light", changeSelection: PeriodState.light)
        }
    }
    
    @IBAction func didSelectPeriodMedium() {
        
        if(periodSelectedState == PeriodState.medium) {
            
            self.updatePeriodData("", changeSelection: PeriodState.medium)
        } else {
            
            self.updatePeriodData("medium", changeSelection: PeriodState.medium)
        }
    }
    
    @IBAction func didSelectPeriodHeavy() {
        
        if(periodSelectedState == PeriodState.heavy) {
            
            self.updatePeriodData("", changeSelection: PeriodState.heavy)
        } else {
            
            self.updatePeriodData("heavy", changeSelection: PeriodState.heavy)
        }
    }
    
    func updatePeriodData(periodSelection: String, changeSelection: PeriodState) {
        
        let periodSelectionString = "day[date]=\(todayDate)&day[period]="+periodSelection
        
        connectionManager.updateFertilityData (periodSelectionString, { (success, error) -> () in
            
            if(success) {
                
                self.updatePeriodButtons(changeSelection)
            }
        })
    }
    
    func updatePeriodButtons(changeSelection: PeriodState) {
        
        self.resetButtonImages()
        
        switch changeSelection {
            
        case self.periodSelectedState:
            self.periodSelectionLabel.setText("Select")
            self.periodSelectedState = PeriodState.noData
            
        case PeriodState.none:
            self.periodSelectionLabel.setText("None")
            self.periodSelectNoneButton.setBackgroundImageNamed("btn_period_none_p")
            self.periodSelectedState = PeriodState.none
            
        case PeriodState.spotting:
            self.periodSelectionLabel.setText("Spotting")
            self.periodSelectSpottingButton.setBackgroundImageNamed("btn_period_spotting_p")
            self.periodSelectedState = PeriodState.spotting
            
        case PeriodState.light:
            self.periodSelectionLabel.setText("Light")
            self.periodSelectLightButton.setBackgroundImageNamed("btn_period_light_p")
            self.periodSelectedState = PeriodState.light
            
        case PeriodState.medium:
            self.periodSelectionLabel.setText("Medium")
            self.periodSelectMediumButton.setBackgroundImageNamed("btn_period_medium_p")
            self.periodSelectedState = PeriodState.medium
            
        case PeriodState.heavy:
            self.periodSelectionLabel.setText("Heavy")
            self.periodSelectHeavyButton.setBackgroundImageNamed("btn_period_heavy_p")
            self.periodSelectedState = PeriodState.heavy
            
        default:
            self.periodSelectionLabel.setText("Select")
            self.periodSelectedState = PeriodState.noData
        }
    }
}