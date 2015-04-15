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
    @IBOutlet weak var periodSelectNoneGroup: WKInterfaceGroup!
    
    @IBOutlet weak var periodSelectSpottingButton: WKInterfaceButton!
    @IBOutlet weak var periodSelectSpottingGroup: WKInterfaceGroup!
    
    @IBOutlet weak var periodSelectLightButton: WKInterfaceButton!
    @IBOutlet weak var periodSelectLightGroup: WKInterfaceGroup!
    
    @IBOutlet weak var periodSelectMediumButton: WKInterfaceButton!
    @IBOutlet weak var periodSelectMediumGroup: WKInterfaceGroup!
    
    @IBOutlet weak var periodSelectHeavyButton: WKInterfaceButton!
    @IBOutlet weak var periodSelectHeavyGroup: WKInterfaceGroup!
    
    var periodSelectedState = PeriodState.noData
    
    let connectionManager = ConnectionManager()
    
    var selectedDay : Day {
        return connectionManager.selectedDay
    }
    
    var todayDate : String = ""
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateScreen", name: "SelectedDayUpdate", object: nil)
    }
    
    override func willActivate() {
        
        if Session.isCurrentUserLoggedIn(){
            updateScreen()
        }else{
            updateScreenForNotLoggedIn()
        }
        
    }
    
    override func handleUserActivity(context: [NSObject : AnyObject]!) {
        if(context != nil) {
            super.becomeCurrentPage()
        }
    }
    
    func updatePeriodData(periodSelection: String, changeSelection: PeriodState) {
        
        let periodSelectionString = "day[date]=\(todayDate)&day[period]="+periodSelection
        
        connectionManager.updateFertilityData (periodSelectionString, completion: { (success, error) -> () in
            
            if(error === nil) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.updateScreen()
                })
            }
            
        })
    }
    
    func updateScreenForNotLoggedIn () {
        
    }
    
    func updateScreen() {
        
        println("PERIOD CONTROLLER : UPDATE SCREEN")
        
        var changeSelection = selectedDay.periodStateForDay()
        
        self.resetButtonImages()
        
        switch changeSelection {
            
            case self.periodSelectedState:
                
                self.periodSelectionLabel.setText("Select")
                self.periodSelectionLabel.setTextColor(UIColor.lightGrayColor())
                self.periodSelectedState = PeriodState.noData
                
            case PeriodState.none:
                
                self.periodSelectionLabel.setText("None")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                self.periodSelectedState = PeriodState.none
                self.animateGroupSelection(self.periodSelectNoneGroup)
                
            case PeriodState.spotting:
                
                self.periodSelectionLabel.setText("Spotting")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                self.periodSelectedState = PeriodState.spotting
                self.animateGroupSelection(self.periodSelectSpottingGroup)
                
            case PeriodState.light:
                
                self.periodSelectionLabel.setText("Light")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                self.periodSelectedState = PeriodState.light
                self.animateGroupSelection(self.periodSelectLightGroup)
                
            case PeriodState.medium:
                
                self.periodSelectionLabel.setText("Medium")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                self.periodSelectedState = PeriodState.medium
                self.animateGroupSelection(self.periodSelectMediumGroup)
                
            case PeriodState.heavy:
                
                self.periodSelectionLabel.setText("Heavy")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                self.periodSelectedState = PeriodState.heavy
                self.animateGroupSelection(self.periodSelectHeavyGroup)
                
            default:
                
                self.periodSelectionLabel.setText("Select")
                self.periodSelectionLabel.setTextColor(UIColor.lightGrayColor())
                self.periodSelectedState = PeriodState.noData
        }
        
    }
    
    func resetButtonImages() {
        
        self.periodSelectNoneGroup.setBackgroundImageNamed("Comp 1_0")
        self.periodSelectSpottingGroup.setBackgroundImageNamed("Comp 1_0")
        self.periodSelectLightGroup.setBackgroundImageNamed("Comp 1_0")
        self.periodSelectMediumGroup.setBackgroundImageNamed("Comp 1_0")
        self.periodSelectHeavyGroup.setBackgroundImageNamed("Comp 1_0")
        
    }
    
    func animateGroupSelection (buttonGroup: WKInterfaceGroup) {
        buttonGroup.setBackgroundImageNamed("Comp 1_")
        buttonGroup.startAnimatingWithImagesInRange(NSRange(location: 0, length: 29), duration: 1, repeatCount: 1)
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
    
}