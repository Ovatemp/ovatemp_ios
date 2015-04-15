//
//  PositionPageViewController.swift
//  Ovatemp
//
//  Created by Arun Venkatesan on 1/29/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import Foundation
import WatchKit

public enum PositionState {
    case noData
    case lowClosedFirm
    case highOpenSoft
}

class PositionPageViewController: WKInterfaceController {
    
    @IBOutlet weak var positionSelectionLabel: WKInterfaceLabel!
    @IBOutlet weak var positionSelectLowClosedFirmButton: WKInterfaceButton!
    @IBOutlet weak var positionSelectLowClosedFirmGroup: WKInterfaceGroup!
    @IBOutlet weak var positionSelectHighOpenSoftButton: WKInterfaceButton!
    @IBOutlet weak var positionSelectHighOpenSoftGroup: WKInterfaceGroup!
    
    var positionSelectedState = PositionState.noData
    
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
    
    func updatePositionData(positionSelection: String, changeSelection: PositionState) {
        
        let positionSelectionString = "day[date]=\(todayDate)&day[cervical_position]="+positionSelection
        
        connectionManager.updateFertilityData (positionSelectionString, completion: { (success, error) -> () in
            
            if(error == nil) {
                self.updateScreen()
            }
        })
    }
    
    func updateScreenForNotLoggedIn () {
        
    }
    
    func updateScreen() {
        
        println("POSITION CONTROLLER : UPDATE SCREEN")
        
        let positionState = selectedDay.positionStateForDay()
        
        self.resetButtonImages()
        
        switch positionState {
            
            case self.positionSelectedState:
                self.positionSelectionLabel.setText("Select")
                self.positionSelectionLabel.setTextColor(UIColor.lightGrayColor())
                self.positionSelectedState = PositionState.noData
                
            case PositionState.lowClosedFirm:
                self.positionSelectionLabel.setText("Low/Closed/Firm")
                self.positionSelectionLabel.setTextColor(UIColor.whiteColor())
                self.animateGroupSelection(self.positionSelectLowClosedFirmGroup)
                self.positionSelectedState = PositionState.lowClosedFirm
                
            case PositionState.highOpenSoft:
                self.positionSelectionLabel.setText("High/Open/Soft")
                self.positionSelectionLabel.setTextColor(UIColor.whiteColor())
                self.animateGroupSelection(self.positionSelectHighOpenSoftGroup)
                self.positionSelectedState = PositionState.highOpenSoft
                
            default:
                self.positionSelectionLabel.setText("Select")
                self.positionSelectionLabel.setTextColor(UIColor.lightGrayColor())
                self.positionSelectedState = PositionState.noData
            
        }
    }
    
    func resetButtonImages() {
        self.positionSelectLowClosedFirmGroup.setBackgroundImageNamed("Comp 1_0")
        self.positionSelectHighOpenSoftGroup.setBackgroundImageNamed("Comp 1_0")
    }
    
    func animateGroupSelection (buttonGroup: WKInterfaceGroup) {
        buttonGroup.setBackgroundImageNamed("Comp 1_")
        buttonGroup.startAnimatingWithImagesInRange(NSRange(location: 0, length: 29), duration: 1, repeatCount: 1)
    }
    
    @IBAction func didSelectPositionLowClosedFirm() {
        
        if(positionSelectedState == PositionState.lowClosedFirm) {
            
            self.updatePositionData("", changeSelection: PositionState.lowClosedFirm)
        } else {
            
            self.updatePositionData("low/closed/firm", changeSelection: PositionState.lowClosedFirm)
        }
    }
    
    @IBAction func didSelectPositionHighOpenSoft() {
        
        if(positionSelectedState == PositionState.highOpenSoft) {
            
            self.updatePositionData("", changeSelection: PositionState.highOpenSoft)
        } else {
            
            self.updatePositionData("high/open/soft", changeSelection: PositionState.highOpenSoft)
        }
    }

}