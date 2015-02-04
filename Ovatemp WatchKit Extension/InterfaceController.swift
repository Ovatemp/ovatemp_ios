//
//  InterfaceController.swift
//  Ovatemp WatchKit Extension
//
//  Created by Arun Venkatesan on 1/19/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var fertilityStatusGroup: WKInterfaceGroup!
    @IBOutlet weak var fertilityStatusLabel: WKInterfaceLabel!
    
    @IBOutlet weak var fertilityStatusInfoLabel: WKInterfaceLabel!
    
    let connectionManager = ConnectionManager()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // Configure interface objects here.
        connectionManager.requestFertilityStatus { (status, error) -> () in
            
            switch status.fertilityStatus {
                
            case FertilityStatus.peakFertility:
                self.fertilityStatusLabel.setAttributedText(self.attributedString("PEAK FERTILITY"))
                self.fertilityStatusInfoLabel.setText("Optimal conditions for conception")
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - fertile")
            case FertilityStatus.fertile:
                self.fertilityStatusLabel.setAttributedText(self.attributedString("FERTILE"))
                self.fertilityStatusInfoLabel.setText("Let's get it on!")
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - fertile")
            case FertilityStatus.notFertile:
                self.fertilityStatusLabel.setAttributedText(self.attributedString("NOT FERTILE"))
                if(status.fertilityCycle == FertilityCycle.preovulation) {
                    
                    self.fertilityStatusInfoLabel.setText("Please check for Cervical Fluid.")
                } else {
                    self.fertilityStatusInfoLabel.setText("Crossing our fingers for you!")
                }
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - not fertile")
            case FertilityStatus.period:
                self.fertilityStatusLabel.setAttributedText(self.attributedString("PERIOD"))
                self.fertilityStatusInfoLabel.setText("Try to get some rest.")
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - period")
            case FertilityStatus.empty:
                self.fertilityStatusLabel.setText("")
                self.fertilityStatusInfoLabel.setText("Please enter your Basal Body Temperature and other daily data for fertility status.")
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - no data")
            default:
                self.fertilityStatusLabel.setText("")
                self.fertilityStatusInfoLabel.setText("Please enter your Basal Body Temperature and other daily data for fertility status.")
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - no data")
            }
        }
    }
    
    func attributedString(statusInfo: String) -> NSAttributedString {
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.8
        paragraphStyle.alignment = NSTextAlignment.Center
        
        var attrString = NSMutableAttributedString(string: statusInfo)
        
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        return attrString
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
