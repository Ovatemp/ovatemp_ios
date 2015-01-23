//
//  GlanceController.swift
//  Ovatemp WatchKit Extension
//
//  Created by Arun Venkatesan on 1/19/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {
    
    @IBOutlet weak var fertilityStatusGroup: WKInterfaceGroup!
    @IBOutlet weak var fertilityStatusLabel: WKInterfaceLabel!
    
    let connectionManager = ConnectionManager()

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        // Configure interface objects here.
        connectionManager.requestFertilityStatus { (status, error) -> () in
            
            switch status {
                
            case FertilityStatus.peakFertility:
                self.fertilityStatusLabel.setText("PEAK FERTILITY")
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - fertile")
            case FertilityStatus.fertile:
                self.fertilityStatusLabel.setText("FERTILE")
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - fertile")
            case FertilityStatus.notFertile:
                self.fertilityStatusLabel.setText("NOT FERTILE")
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - not fertile")
            case FertilityStatus.period:
                self.fertilityStatusLabel.setText("PERIOD")
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - period")
            case FertilityStatus.empty:
                self.fertilityStatusLabel.setText("Please enter your Basal Body Temperature and other daily data for fertility status.")
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - no data")
            default:
                self.fertilityStatusLabel.setText("Please enter your Basal Body Temperature and other daily data for fertility status.")
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - no data")
            }
        }
    }

    override func willActivate() {
        
        // Use Handoff to route the wearer to the enter info controller when the Glance is tapped.
        self.updateUserActivity("com.ovatemp.ovatemp.1",
            userInfo: ["controllerName": "PeriodPageViewController"])
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
