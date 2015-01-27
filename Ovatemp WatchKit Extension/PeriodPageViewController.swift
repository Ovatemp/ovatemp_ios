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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
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
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"

        let todayDate = dateFormatter.stringFromDate(NSDate())
        
        if(periodSelectedState == PeriodState.none) {

            let periodSelection = "day[date]=\(todayDate)&day[period]="

            connectionManager.updateFertilityData (periodSelection, { (success, error) -> () in

                if(success) {

                    self.periodSelectionLabel.setText("Select")
                    self.periodSelectNoneButton.setBackgroundImageNamed("btn_period_none")
                    self.periodSelectedState = PeriodState.noData
                }

            })
            
        } else {
            
            let periodSelection = "day[date]=\(todayDate)&day[period]=none"
            
            connectionManager.updateFertilityData (periodSelection, { (success, error) -> () in
                
                if(success) {
                    
                    self.periodSelectionLabel.setText("None")
                    self.resetButtonImages()
                    self.periodSelectNoneButton.setBackgroundImageNamed("btn_period_none_p")
                    self.periodSelectedState = PeriodState.none
                }
                
            })
        }
    }
    @IBAction func didSelectPeriodSpotting() {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
        
        let todayDate = dateFormatter.stringFromDate(NSDate())
        
        if(periodSelectedState == PeriodState.spotting) {
            
            let periodSelection = "day[date]=\(todayDate)&day[period]="
            
            connectionManager.updateFertilityData (periodSelection, { (success, error) -> () in
                
                if(success) {
                    
                    self.periodSelectionLabel.setText("Select")
                    self.periodSelectSpottingButton.setBackgroundImageNamed("btn_period_spotting")
                    self.periodSelectedState = PeriodState.spotting
                }
                
            })
            
        } else {
            
            let periodSelection = "day[date]=\(todayDate)&day[period]=spotting"
            
            connectionManager.updateFertilityData (periodSelection, { (success, error) -> () in
                
                if(success) {
                    
                    self.periodSelectionLabel.setText("Spotting")
                    self.resetButtonImages()
                    self.periodSelectSpottingButton.setBackgroundImageNamed("btn_period_spotting_p")
                    self.periodSelectedState = PeriodState.spotting
                }
                
            })
        }
    }
}