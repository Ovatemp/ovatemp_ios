//
//  PeriodPage.swift
//  Ovatemp
//
//  Created by Arun Venkatesan on 1/23/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import Foundation
import WatchKit

public enum PeriodState : String {
    case noData = "noData"
    case none = "none"
    case spotting = "spotting"
    case light = "light"
    case medium = "medium"
    case heavy = "heavy"
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
    
    let connectionManager = ConnectionManager.sharedInstance
    
    var selectedDay : Day {
        return connectionManager.selectedDay
    }
    
    var todayDate : String? {
        return selectedDay.date
    }
    
    var periodSelectedState : PeriodState?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateScreen", name: "SelectedDayUpdate", object: nil)
    }
    
    override func willActivate() {
        
        if Session.isCurrentUserLoggedIn(){
            periodSelectedState = selectedDay.periodStateForDay()
            updateScreen()
        }else{
            updateScreenForNotLoggedIn()
        }
        
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func handleUserActivity(context: [NSObject : AnyObject]!) {
        if(context != nil) {
            super.becomeCurrentPage()
        }
    }
    
    // Mark: Network
    
    func updatePeriodData(periodSelection: String) {
        
        let periodSelectionString = "day[date]=\(todayDate!)&day[period]=\(periodSelection)"
        
        connectionManager.updateFertilityData (periodSelectionString, completion: { (success, error) -> () in
            
            if(success) {
                self.updateScreen()
            }
            
        })
    }
    
    // Mark: Appearance
    
    func updateScreenForNotLoggedIn () {
        
        self.periodSelectionLabel.setText("Please, log in.")
        self.periodSelectionLabel.setTextColor(UIColor.lightGrayColor())
        
        self.periodSelectedState = PeriodState.noData
        
    }
    
    func updateScreen() {
        
        println("PERIOD CONTROLLER : UPDATE SCREEN")
        
        var periodState : PeriodState = selectedDay.periodStateForDay()
        
        println("SELECTED DAY : PERIOD STATE : \(periodState.rawValue)")
        println("VIEW CONTROLLER : PERIOD STATE : \(self.periodSelectedState!.rawValue)")
        
        self.resetButtonImages()
        
        switch periodState {
            
            case PeriodState.none:
                
                println("SWITCH : NONE")
                
                self.periodSelectedState = PeriodState.none
                self.periodSelectionLabel.setText("None")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                self.animateGroupSelection(self.periodSelectNoneGroup)
                
            case PeriodState.spotting:
                
                println("SWITCH : SPOTTING")
                
                self.periodSelectedState = PeriodState.spotting
                self.periodSelectionLabel.setText("Spotting")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                self.animateGroupSelection(self.periodSelectSpottingGroup)
                
            case PeriodState.light:
            
                println("SWITCH : LIGHT")

                self.periodSelectedState = PeriodState.light
                self.periodSelectionLabel.setText("Light")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                self.animateGroupSelection(self.periodSelectLightGroup)
                
            case PeriodState.medium:
                
                println("SWITCH : MEDIUM")

                self.periodSelectedState = PeriodState.medium
                self.periodSelectionLabel.setText("Medium")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                self.animateGroupSelection(self.periodSelectMediumGroup)
                
            case PeriodState.heavy:
                
                println("SWITCH : HEAVY")
                
                self.periodSelectedState = PeriodState.heavy
                self.periodSelectionLabel.setText("Heavy")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                self.animateGroupSelection(self.periodSelectHeavyGroup)
                
            default:
                
                println("SWITCH : DEFAULT")

                self.periodSelectedState = PeriodState.noData
                self.periodSelectionLabel.setText("Select")
                self.periodSelectionLabel.setTextColor(UIColor.lightGrayColor())
            
                resetButtonImages()
            
        }
        
    }
    
    func resetButtonImages() {
        
        println("RESET BUTTON IMAGES")
        
        self.periodSelectNoneGroup.setBackgroundImageNamed("Comp 1_0")
        self.periodSelectSpottingGroup.setBackgroundImageNamed("Comp 1_0")
        self.periodSelectLightGroup.setBackgroundImageNamed("Comp 1_0")
        self.periodSelectMediumGroup.setBackgroundImageNamed("Comp 1_0")
        self.periodSelectHeavyGroup.setBackgroundImageNamed("Comp 1_0")
        
    }
    
    func animateGroupSelection (buttonGroup: WKInterfaceGroup) {
        buttonGroup.setBackgroundImageNamed("Comp 1_")
        buttonGroup.startAnimatingWithImagesInRange(NSRange(location: 0, length: 29), duration: 1.5, repeatCount: 1)
    }
    
    // Mark: IBAction's

    @IBAction func didSelectPeriodNone() {
        
        resetButtonImages()
        
//        if(periodSelectedState == PeriodState.none) {
//            self.updatePeriodData("")
//            
//        }else{
//            self.updatePeriodData("none")
//        }
    }
    
    @IBAction func didSelectPeriodSpotting() {
        
        resetButtonImages()
        
        if(periodSelectedState == PeriodState.spotting) {
            self.updatePeriodData("")
            
        }else{
            self.updatePeriodData("spotting")
        }
    }
    
    @IBAction func didSelectPeriodLight() {
        
        resetButtonImages()

        if(periodSelectedState == PeriodState.light) {
            self.updatePeriodData("")
            
        }else{
            self.updatePeriodData("light")
        }
    }
    
    @IBAction func didSelectPeriodMedium() {
        
        resetButtonImages()

        if(periodSelectedState == PeriodState.medium) {
            self.updatePeriodData("")
            
        }else{
            self.updatePeriodData("medium")
        }
    }
    
    @IBAction func didSelectPeriodHeavy() {
        
        resetButtonImages()

        if(periodSelectedState == PeriodState.heavy) {
            self.updatePeriodData("")
            
        }else{
            self.updatePeriodData("heavy")
        }
    }
    
}