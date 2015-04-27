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
    
    var selectedPeriodState : PeriodState = PeriodState.noData
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateScreen", name: "SelectedDayUpdate", object: nil)
    }
    
    override func willActivate() {
        
        if Session.isCurrentUserLoggedIn(){
            
            selectedPeriodState = selectedDay.periodStateForDay()
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
        
        if let todayDate = todayDate {
            
            let periodSelectionString = "day[date]=\(todayDate)&day[period]=\(periodSelection)"
            
            connectionManager.updateFertilityData (periodSelectionString, completion: { (success, error) -> () in
                
                if(success) {
                    self.selectedPeriodState = self.selectedDay.periodStateForDay()
                    self.updateScreen()
                }else{
                    println("ERROR UPDATING PERIOD DATA: \(error)")
                }
                
            })
            
        }else{
            println("ERROR : TODAY DATE IS NIL")
        }
        
    }
    
    // Mark: Appearance
    
    func updateScreenForNotLoggedIn () {
        
        periodSelectionLabel.setText("Please, log in.")
        periodSelectionLabel.setTextColor(UIColor.lightGrayColor())
        
        self.periodSelectNoneGroup.setBackgroundImageNamed("Comp 1_0")
        self.periodSelectSpottingGroup.setBackgroundImageNamed("Comp 1_0")
        self.periodSelectLightGroup.setBackgroundImageNamed("Comp 1_0")
        self.periodSelectMediumGroup.setBackgroundImageNamed("Comp 1_0")
        self.periodSelectHeavyGroup.setBackgroundImageNamed("Comp 1_0")
        
    }
    
    func updateScreen() {
        
        println("PERIOD CONTROLLER : UPDATE SCREEN")
        
        switch selectedPeriodState {
            
            case PeriodState.none:
                
                println("SWITCH : NONE")
                
                self.periodSelectionLabel.setText("None")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                
                self.periodSelectSpottingGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectLightGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectMediumGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectHeavyGroup.setBackgroundImageNamed("Comp 1_0")
                self.animateGroupSelection(self.periodSelectNoneGroup)
                
            case PeriodState.spotting:
                
                println("SWITCH : SPOTTING")
                
                self.periodSelectionLabel.setText("Spotting")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                
                self.periodSelectNoneGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectLightGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectMediumGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectHeavyGroup.setBackgroundImageNamed("Comp 1_0")
                self.animateGroupSelection(self.periodSelectSpottingGroup)
                
            case PeriodState.light:
            
                println("SWITCH : LIGHT")

                self.periodSelectionLabel.setText("Light")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                
                self.periodSelectNoneGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectSpottingGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectMediumGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectHeavyGroup.setBackgroundImageNamed("Comp 1_0")
                self.animateGroupSelection(self.periodSelectLightGroup)
                
            case PeriodState.medium:
                
                println("SWITCH : MEDIUM")

                self.periodSelectionLabel.setText("Medium")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                
                self.periodSelectNoneGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectSpottingGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectLightGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectHeavyGroup.setBackgroundImageNamed("Comp 1_0")
                self.animateGroupSelection(self.periodSelectMediumGroup)
                
            case PeriodState.heavy:
                
                println("SWITCH : HEAVY")
                
                self.periodSelectionLabel.setText("Heavy")
                self.periodSelectionLabel.setTextColor(UIColor.whiteColor())
                
                self.periodSelectNoneGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectSpottingGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectLightGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectMediumGroup.setBackgroundImageNamed("Comp 1_0")
                self.animateGroupSelection(self.periodSelectHeavyGroup)
                
            default:
                
                println("SWITCH : DEFAULT : NO DATA")

                self.periodSelectionLabel.setText("Select")
                self.periodSelectionLabel.setTextColor(UIColor.lightGrayColor())
            
                self.periodSelectNoneGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectSpottingGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectLightGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectMediumGroup.setBackgroundImageNamed("Comp 1_0")
                self.periodSelectHeavyGroup.setBackgroundImageNamed("Comp 1_0")
            
        }
        
    }
    
    func animateGroupSelection (buttonGroup: WKInterfaceGroup) {
        buttonGroup.setBackgroundImageNamed("Comp 1_")
        buttonGroup.startAnimatingWithImagesInRange(NSRange(location: 0, length: 29), duration: 1.5, repeatCount: 1)
    }
    
    // Mark: IBAction's

    @IBAction func didSelectPeriodNone() {
        
        if(selectedPeriodState == PeriodState.none) {
            self.updatePeriodData("")
            
        }else{
            self.updatePeriodData("none")
        }
        
    }
    
    @IBAction func didSelectPeriodSpotting() {
        
        if(selectedPeriodState == PeriodState.spotting) {
            self.updatePeriodData("")
            
        }else{
            self.updatePeriodData("spotting")
        }
        
    }
    
    @IBAction func didSelectPeriodLight() {
        
        if(selectedPeriodState == PeriodState.light) {
            self.updatePeriodData("")
            
        }else{
            self.updatePeriodData("light")
        }
        
    }
    
    @IBAction func didSelectPeriodMedium() {
        
        if(selectedPeriodState == PeriodState.medium) {
            self.updatePeriodData("")
            
        }else{
            self.updatePeriodData("medium")
        }
        
    }
    
    @IBAction func didSelectPeriodHeavy() {
        
        if(selectedPeriodState == PeriodState.heavy) {
            self.updatePeriodData("")
            
        }else{
            self.updatePeriodData("heavy")
        }
        
    }
    
}