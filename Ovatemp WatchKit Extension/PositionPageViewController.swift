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
    @IBOutlet weak var positionSelectHighOpenSoftButton: WKInterfaceButton!
    
    var positionSelectedState = PositionState.noData
    
    let connectionManager = ConnectionManager()
    
    var todayDate : String = ""
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
        
        self.todayDate = dateFormatter.stringFromDate(NSDate())
        
        // Configure interface objects here.
        connectionManager.requestPositionStatus { (status, error) -> () in
            
            self.updatePositionButtons(status)
        }
        
    }
    
    func resetButtonImages() {
        
        self.positionSelectLowClosedFirmButton.setBackgroundImageNamed("btn_position_lowclosedfirm")
        self.positionSelectHighOpenSoftButton.setBackgroundImageNamed("btn_position_highopensoft")
    }
    
    func updateFluidData(positionSelection: String, changeSelection: PositionState) {
        
        let positionSelectionString = "day[date]=\(todayDate)&day[cervical_position]="+positionSelection
        
        connectionManager.updateFertilityData (positionSelectionString, { (success, error) -> () in
            
            if(error == nil) {
                
                self.updatePositionButtons(changeSelection)
            }
        })
    }
    
    func updatePositionButtons(changeSelection: PositionState) {
        
        self.resetButtonImages()
        
        switch changeSelection {
            
        case self.positionSelectedState:
            self.positionSelectionLabel.setText("Select")
            self.positionSelectionLabel.setTextColor(UIColor.lightGrayColor())
            self.positionSelectedState = PositionState.noData
            
        case PositionState.lowClosedFirm:
            self.positionSelectionLabel.setText("Low/Closed/Firm")
            self.positionSelectionLabel.setTextColor(UIColor.whiteColor())
            self.positionSelectLowClosedFirmButton.setBackgroundImageNamed("btn_position_lowclosedfirm_p")
            self.positionSelectedState = PositionState.lowClosedFirm
            
        case PositionState.highOpenSoft:
            self.positionSelectionLabel.setText("High/Open/Soft")
            self.positionSelectionLabel.setTextColor(UIColor.whiteColor())
            self.positionSelectHighOpenSoftButton.setBackgroundImageNamed("btn_position_highopensoft_p")
            self.positionSelectedState = PositionState.highOpenSoft
            
        default:
            self.positionSelectionLabel.setText("Select")
            self.positionSelectionLabel.setTextColor(UIColor.lightGrayColor())
            self.positionSelectedState = PositionState.noData
        }
    }
}