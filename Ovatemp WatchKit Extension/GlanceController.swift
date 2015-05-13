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
    
    @IBOutlet weak var appIconGroup: WKInterfaceGroup!
    @IBOutlet weak var fertilityStatusInfoLabel: WKInterfaceLabel!
    
    let connectionManager = ConnectionManager.sharedInstance
    
    var selectedDay : Day {
        return connectionManager.selectedDay
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if Session.isCurrentUserLoggedIn() {
            
            println("APPLE WATCH : USER IS LOGGED IN TO OVATEMP")
            
            connectionManager.updateCurrentDay({ (day, error) -> () in
                if let error = error {
                    print("ERROR: \(error)")
                }else{
                    self.updateScreen()
                }
            })
            
        }else{
            println("APPLE WATCH : NOT LOGGED IN TO OVATEMP")
            updateScreenForNotLoggedIn()
        }
        
    }
    
    override func willActivate() {
        // Use Handoff to route the wearer to the enter info controller when the Glance is tapped.
        self.updateUserActivity("com.ovatemp.ovatemp.1", userInfo: ["controllerName": "PeriodPageViewController"], webpageURL: nil)
    }
    
    // MARK: Appearance
    
    func updateScreenForNotLoggedIn (){
        
        self.fertilityStatusLabel.setAttributedText(self.attributedString("Please log in."))
        self.fertilityStatusInfoLabel.setText(nil)
        self.fertilityStatusGroup.setBackgroundImage(nil)
        
    }
    
    func updateScreen () {
        
        println("INTERFACE CONTROLLER : UPDATE SCREEN")
        
        self.fertilityStatusInfoLabel.setText("Today's status:")
        
        let fertility = selectedDay.fertilityForDay()
        let userType = Session.retrieveUserTypeFromDefaults()
        
        switch fertility.fertilityStatus {
            
        case FertilityStatus.peakFertility:
            
            if userType == "TTC"{
                self.fertilityStatusGroup.setBackgroundImageNamed("fertile_conceive")
            }else{
                self.fertilityStatusGroup.setBackgroundImageNamed("fertile_avoid")
            }
            
        case FertilityStatus.fertile:
            
            if userType == "TTC"{
                self.fertilityStatusGroup.setBackgroundImageNamed("fertile_conceive")
            }else{
                self.fertilityStatusGroup.setBackgroundImageNamed("fertile_avoid")
            }
            
            
        case FertilityStatus.notFertile:
            
            if userType == "TTC"{
                self.fertilityStatusGroup.setBackgroundImageNamed("fertile_conceive")
            }else{
                self.fertilityStatusGroup.setBackgroundImageNamed("not_fertile_conceive")
            }
            
        case FertilityStatus.period:
            
            if userType == "TTC"{
                self.fertilityStatusGroup.setBackgroundImageNamed("period")
            }else{
                self.fertilityStatusGroup.setBackgroundImageNamed("period")
            }
            
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
    
    // Mark: Helpers
    
    func attributedString(statusInfo: String) -> NSAttributedString {
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.8
        paragraphStyle.alignment = NSTextAlignment.Center
        
        var attrString = NSMutableAttributedString(string: statusInfo)
        
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        return attrString
    }
    
}
