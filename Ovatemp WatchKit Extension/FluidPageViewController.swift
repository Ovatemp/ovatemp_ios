//
//  FluidPageViewController.swift
//  Ovatemp
//
//  Created by Arun Venkatesan on 1/29/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import Foundation
import WatchKit

public enum FluidState {
    case noData
    case dry
    case sticky
    case creamy
    case eggwhite
}

class FluidPageViewController: WKInterfaceController {
    
    @IBOutlet weak var fluidSelectionLabel: WKInterfaceLabel!
    
    @IBOutlet weak var fluidSelectDryButton: WKInterfaceButton!
    @IBOutlet weak var fluidSelectDryGroup: WKInterfaceGroup!
    
    @IBOutlet weak var fluidSelectStickyButton: WKInterfaceButton!
    @IBOutlet weak var fluidSelectStickyGroup: WKInterfaceGroup!
    
    @IBOutlet weak var fluidSelectCreamyButton: WKInterfaceButton!
    @IBOutlet weak var fluidSelectCreamyGroup: WKInterfaceGroup!
    
    @IBOutlet weak var fluidSelectEggwhiteButton: WKInterfaceButton!
    @IBOutlet weak var fluidSelectEggwhiteGroup: WKInterfaceGroup!
    
    let connectionManager = ConnectionManager.sharedInstance
    
    var selectedDay : Day {
        return connectionManager.selectedDay
    }
    
    var todayDate : String? {
        return selectedDay.date
    }
    
    var selectedFluidState = FluidState.noData
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateScreen", name: "SelectedDayUpdate", object: nil)
    }
    
    override func willActivate() {
        
        if Session.isCurrentUserLoggedIn(){
            
            selectedFluidState = selectedDay.fluidStateForDay()
            updateScreen()
            
        }else{
            updateScreenForNotLoggedIn()
        }
        
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // Mark: Network
    
    func updateFluidData(fluidSelection: String, changeSelection: FluidState) {
        
        let fluidSelectionString = "day[date]=\(todayDate!)&day[cervical_fluid]="+fluidSelection
        
        connectionManager.updateFertilityData (fluidSelectionString, completion: { (success, error) -> () in
            
            if(error == nil) {
                self.selectedFluidState = self.selectedDay.fluidStateForDay()
                self.updateScreen()
            }
            
        })
    }
    
    // Mark: Appearance
    
    func updateScreenForNotLoggedIn() {
        
        resetButtonImages()
        
        fluidSelectionLabel.setText("Please, log in.")
        fluidSelectionLabel.setTextColor(UIColor.lightGrayColor())
        
    }
    
    func updateScreen() {
        
        println("FLUID CONTROLLER : UPDATE SCREEN")
        
        self.resetButtonImages()
        
        switch selectedFluidState {

            case FluidState.dry:
                
                self.fluidSelectionLabel.setText("Dry")
                self.fluidSelectionLabel.setTextColor(UIColor.whiteColor())
                self.anitmateGroupSelection(self.fluidSelectDryGroup)
            
            case FluidState.sticky:
                
                self.fluidSelectionLabel.setText("Sticky")
                self.fluidSelectionLabel.setTextColor(UIColor.whiteColor())
                self.anitmateGroupSelection(self.fluidSelectStickyGroup)
            
            case FluidState.creamy:
                
                self.fluidSelectionLabel.setText("Creamy")
                self.fluidSelectionLabel.setTextColor(UIColor.whiteColor())
                self.anitmateGroupSelection(self.fluidSelectCreamyGroup)
            
            case FluidState.eggwhite:
                
                self.fluidSelectionLabel.setText("Eggwhite")
                self.fluidSelectionLabel.setTextColor(UIColor.whiteColor())
                self.anitmateGroupSelection(self.fluidSelectEggwhiteGroup)
            
            default:
                
                self.fluidSelectionLabel.setText("Select")
                self.fluidSelectionLabel.setTextColor(UIColor.lightGrayColor())
            
        }
    }
    
    func resetButtonImages() {
        
        println("FLUID CONTROLLER : RESET BUTTON IMAGES")
        
        self.fluidSelectDryGroup.setBackgroundImageNamed("Comp 1_0")
        self.fluidSelectStickyGroup.setBackgroundImageNamed("Comp 1_0")
        self.fluidSelectCreamyGroup.setBackgroundImageNamed("Comp 1_0")
        self.fluidSelectEggwhiteGroup.setBackgroundImageNamed("Comp 1_0")
        
    }
    
    func anitmateGroupSelection (buttonGroup: WKInterfaceGroup) {
        buttonGroup.setBackgroundImageNamed("Comp 1_")
        buttonGroup.startAnimatingWithImagesInRange(NSRange(location: 0, length: 29), duration: 1, repeatCount: 1)
    }
    
    // Mark: IBAction's
    
    @IBAction func didSelectFluidDry() {
        
        if(selectedFluidState == FluidState.dry) {
            self.updateFluidData("", changeSelection: FluidState.dry)
            
        } else {
            self.updateFluidData("dry", changeSelection: FluidState.dry)
        }
    }
    
    @IBAction func didSelectFluidSticky() {
        
        if(selectedFluidState == FluidState.sticky) {
            self.updateFluidData("", changeSelection: FluidState.sticky)
            
        } else {
            self.updateFluidData("sticky", changeSelection: FluidState.sticky)
        }
    }
    
    @IBAction func didSelectFluidCreamy() {
        
        if(selectedFluidState == FluidState.creamy) {
            self.updateFluidData("", changeSelection: FluidState.creamy)
            
        } else {
            self.updateFluidData("creamy", changeSelection: FluidState.creamy)
        }
    }
    
    @IBAction func didSelectFluidEggwhite() {
        
        if(selectedFluidState == FluidState.eggwhite) {
            self.updateFluidData("", changeSelection: FluidState.eggwhite)
            
        } else {
            self.updateFluidData("eggwhite", changeSelection: FluidState.eggwhite)
        }
    }
    
}