//
//  PeriodPage.swift
//  Ovatemp
//
//  Created by Arun Venkatesan on 1/23/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import Foundation
import WatchKit

class PeriodPageViewController: WKInterfaceController {
    
    @IBOutlet weak var periodSelectionLabel: WKInterfaceLabel!
    @IBOutlet weak var periodSelectNoneButton: WKInterfaceButton!
    @IBOutlet weak var periodSelectSpottingButton: WKInterfaceButton!
    @IBOutlet weak var periodSelectLightButton: WKInterfaceButton!
    @IBOutlet weak var periodSelectMediumButton: WKInterfaceButton!
    @IBOutlet weak var periodSelectHeavyButton: WKInterfaceButton!
    
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
        
        self.periodSelectNoneButton.setBackgroundImageNamed("btn_period_none_p")
        self.periodSelectSpottingButton.setBackgroundImageNamed("btn_period_spotting_p")
        self.periodSelectLightButton.setBackgroundImageNamed("btn_period_light_p")
        self.periodSelectMediumButton.setBackgroundImageNamed("btn_period_medium_p")
        self.periodSelectHeavyButton.setBackgroundImageNamed("btn_period_heavy_p")
    }
    
    @IBAction func didSelectPeriodNone() {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
        
        let todayDate = dateFormatter.stringFromDate(NSDate())
        
        let selectionDictionary = ["date": todayDate,"period": "none"]
        
        connectionManager.updateFertilityData (selectionDictionary, { (success, error) -> () in
            
            if(success) {
                
                self.periodSelectionLabel.setText("None")
                self.periodSelectNoneButton.setBackgroundImageNamed("btn_period_none_p")
            }
            
        })
    }
}