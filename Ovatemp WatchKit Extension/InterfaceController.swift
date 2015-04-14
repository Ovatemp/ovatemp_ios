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
    let sharedDefaults = NSUserDefaults(suiteName: "group.com.ovatemp.ovatemp")
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
    }

    override func willActivate() {

        super.willActivate()
        
        if let userToken = retrieveUserTokenFromDefaults(), userDeviceId = retrieveDeviceIdFromDefaults() {
            // User is logged in to Ovatemp
            print("APPLE WATCH : USER IS LOGGED IN TO OVATEMP")
            connectionManager.userToken = userToken
            connectionManager.deviceId = userDeviceId
            
            connectionManager.requestFertilityStatus { (fertility, error) -> () in
                if let error = error {
                    print("ERROR: \(error)")
                }else{
                    self.updateScreenForFertility(fertility)
                }
                
            }
            
        }else{
            // User is not logged in to Ovatemp
            print("APPLE WATCH : NOT LOGGED IN TO OVATEMP")
            updateScreenForNotLoggedIn()
            
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: Appearance
    
    func updateScreenForNotLoggedIn (){
        
        // Please log in, etc...
        
    }
    
    func updateScreenForFertility (fertility : Fertility ) {
        
        switch fertility.fertilityStatus {
            
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
                if(fertility.fertilityCycle == FertilityCycle.preovulation) {
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
    
    // MARK: Helpers
    
    func retrieveUserTokenFromDefaults() -> String? {
        
        let userToken = sharedDefaults?.objectForKey("CurrentUserToken") as? String
        return userToken
    }
    
    func retrieveDeviceIdFromDefaults() -> String? {
        
        let deviceId = sharedDefaults?.objectForKey("CurrentUserDeviceId") as? String
        return deviceId
    }
    
    func attributedString(statusInfo: String) -> NSAttributedString {
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.8
        paragraphStyle.alignment = NSTextAlignment.Center
        
        var attrString = NSMutableAttributedString(string: statusInfo)
        
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        return attrString
    }

}
