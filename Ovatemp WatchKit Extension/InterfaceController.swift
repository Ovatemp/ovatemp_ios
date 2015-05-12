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

    @IBOutlet weak var dateLabel: WKInterfaceLabel!
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
        
        dateLabel.setText(selectedDay.date)
        
        let fertility = selectedDay.fertilityForDay()
        let userType = Session.retrieveUserTypeFromDefaults()
        
        switch fertility.fertilityStatus {
            
            case FertilityStatus.peakFertility:
                
                self.fertilityStatusLabel.setAttributedText(self.attributedString("PEAK FERTILITY"))
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - fertile")
                
                if userType == "TTC"{
                    self.fertilityStatusInfoLabel.setText("Optimal conditions for conception")
                }else{
                    self.fertilityStatusInfoLabel.setText("Practice safe sex or avoid intercourse")
                }
            
            case FertilityStatus.fertile:
                
                self.fertilityStatusLabel.setAttributedText(self.attributedString("FERTILE"))
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - fertile")

                if userType == "TTC"{
                    self.fertilityStatusInfoLabel.setText("Let's get it on!")
                    
                }else{
                    self.fertilityStatusInfoLabel.setText("Practice safe sex or avoid intercourse")
                }
                
            
            case FertilityStatus.notFertile:
                
                self.fertilityStatusLabel.setAttributedText(self.attributedString("NOT FERTILE"))
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - not fertile")
                
                if fertility.fertilityCycle == FertilityCycle.preovulation{
                    if userType == "TTC"{
                        self.fertilityStatusInfoLabel.setText("Fertile window about to open, check for cervical fluid.")
                    }else{
                        self.fertilityStatusInfoLabel.setText("You are safe on the evening of a dry day.")
                    }
                    
                }else{
                    if userType == "TTC"{
                        self.fertilityStatusInfoLabel.setText("Crossing our fingers for you.")
                    }else{
                        self.fertilityStatusInfoLabel.setText("You're safe to have unprotected sex until your next period.")
                    }
                }
            
            case FertilityStatus.period:
                
                self.fertilityStatusLabel.setAttributedText(self.attributedString("PERIOD"))
                self.fertilityStatusGroup.setBackgroundImageNamed("Fertility Status - period")
                
                if userType == "TTC"{
                    self.fertilityStatusInfoLabel.setText("Try to get some rest.")
                }else{
                    self.fertilityStatusInfoLabel.setText("The first five days of your cycle are safe.")
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
