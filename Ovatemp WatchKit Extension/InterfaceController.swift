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

    let connectionManager = ConnectionManager.sharedInstance

    var selectedDay : Day {
        return connectionManager.selectedDay
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
    }

    override func willActivate() {
        super.willActivate()
        
        self.loadAssets()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Network
    
    func loadAssets () {
        
        if Session.isCurrentUserLoggedIn() {
            
            println("APPLE WATCH : USER IS LOGGED IN TO OVATEMP")
            
            connectionManager.updateCurrentDay({ (day, error) -> () in
                if let error = error {
                    print("ERROR: \(error)")
                }else{
                    self.updateScreen()
                }
            })
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateScreen", name: "SelectedDayUpdate", object: nil)
            
        }else{
            println("APPLE WATCH : NOT LOGGED IN TO OVATEMP")
            updateScreenForNotLoggedIn()
        }
        
    }
    
    // MARK: Appearance
    
    func updateScreenForNotLoggedIn (){
        
        self.fertilityStatusLabel.setAttributedText(self.attributedString("Please log in."))
        self.fertilityStatusInfoLabel.setText(nil)
        self.fertilityStatusGroup.setBackgroundImage(nil)
        
    }
    
    func updateScreen () {
        
        println("INTERFACE CONTROLLER : UPDATE SCREEN")
        
        let fertility = selectedDay.fertilityForDay()
        let userType = Session.retrieveUserTypeFromDefaults()
        
        self.fertilityStatusInfoLabel.setText("")
        
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
                
                if let cyclePhase = selectedDay.cyclePhase {
                    if cyclePhase == "preovulation"{
                        if userType == "TTC"{
                            self.fertilityStatusGroup.setBackgroundImageNamed("not_fertile_conceive")
                        }else{
                            self.fertilityStatusGroup.setBackgroundImageNamed("not_fertile_avoid")
                        }
                    }else{
                        if userType == "TTC"{
                            self.fertilityStatusGroup.setBackgroundImageNamed("not_fertile_conceive")
                        }else{
                            self.fertilityStatusGroup.setBackgroundImageNamed("fertile_conceive")
                        }
                    }
                }else{
                    if userType == "TTC"{
                        self.fertilityStatusGroup.setBackgroundImageNamed("not_fertile_conceive")
                    }else{
                        self.fertilityStatusGroup.setBackgroundImageNamed("not_fertile_avoid")
                    }
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
    
    // MARK: Helpers
    
    func attributedString(statusInfo: String) -> NSAttributedString {
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.8
        paragraphStyle.alignment = NSTextAlignment.Center
        
        var attrString = NSMutableAttributedString(string: statusInfo)
        
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        return attrString
    }

}
