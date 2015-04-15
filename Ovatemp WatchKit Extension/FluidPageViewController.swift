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
    
    
    var fluidSelectedState = FluidState.noData
    
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
    
    func updateFluidData(fluidSelection: String, changeSelection: FluidState) {
        
        let fluidSelectionString = "day[date]=\(todayDate)&day[cervical_fluid]="+fluidSelection
        
        connectionManager.updateFertilityData (fluidSelectionString, completion: { (success, error) -> () in
            if(error == nil) {
                self.updateScreen()
            }
        })
    }
    
    func updateScreenForNotLoggedIn() {
        
    }
    
    func updateScreen() {
        
        println("FLUID CONTROLLER : UPDATE SCREEN")
        
        let fluidState = selectedDay.fluidStateForDay()
        
        self.resetButtonImages()
        
        switch fluidState {

            case self.fluidSelectedState:
                self.fluidSelectionLabel.setText("Select")
                self.fluidSelectionLabel.setTextColor(UIColor.lightGrayColor())
                self.fluidSelectedState = FluidState.noData
                
            case FluidState.dry:
                self.fluidSelectionLabel.setText("Dry")
                self.fluidSelectionLabel.setTextColor(UIColor.whiteColor())
                self.anitmateGroupSelection(self.fluidSelectDryGroup)
                self.fluidSelectedState = FluidState.dry
                
            case FluidState.sticky:
                self.fluidSelectionLabel.setText("Sticky")
                self.fluidSelectionLabel.setTextColor(UIColor.whiteColor())
                self.anitmateGroupSelection(self.fluidSelectStickyGroup)
                self.fluidSelectedState = FluidState.sticky
                
            case FluidState.creamy:
                self.fluidSelectionLabel.setText("Creamy")
                self.fluidSelectionLabel.setTextColor(UIColor.whiteColor())
                self.anitmateGroupSelection(self.fluidSelectCreamyGroup)
                self.fluidSelectedState = FluidState.creamy
                
            case FluidState.eggwhite:
                self.fluidSelectionLabel.setText("Eggwhite")
                self.fluidSelectionLabel.setTextColor(UIColor.whiteColor())
                self.anitmateGroupSelection(self.fluidSelectEggwhiteGroup)
                self.fluidSelectedState = FluidState.eggwhite
                
            default:
                self.fluidSelectionLabel.setText("Select")
                self.fluidSelectionLabel.setTextColor(UIColor.lightGrayColor())
                self.fluidSelectedState = FluidState.noData
        }
    }
    
    func resetButtonImages() {
        
        self.fluidSelectDryGroup.setBackgroundImageNamed("Comp 1_0")
        self.fluidSelectStickyGroup.setBackgroundImageNamed("Comp 1_0")
        self.fluidSelectCreamyGroup.setBackgroundImageNamed("Comp 1_0")
        self.fluidSelectEggwhiteGroup.setBackgroundImageNamed("Comp 1_0")
        
    }
    
    func anitmateGroupSelection (buttonGroup: WKInterfaceGroup) {
        buttonGroup.setBackgroundImageNamed("Comp 1_")
        buttonGroup.startAnimatingWithImagesInRange(NSRange(location: 0, length: 29), duration: 1, repeatCount: 1)
    }
    
    @IBAction func didSelectFluidDry() {
        
        if(fluidSelectedState == FluidState.dry) {
            
            self.updateFluidData("", changeSelection: FluidState.dry)
        } else {
            
            self.updateFluidData("dry", changeSelection: FluidState.dry)
        }
    }
    
    @IBAction func didSelectFluidSticky() {
        
        if(fluidSelectedState == FluidState.sticky) {
            
            self.updateFluidData("", changeSelection: FluidState.sticky)
        } else {
            
            self.updateFluidData("sticky", changeSelection: FluidState.sticky)
        }
    }
    
    @IBAction func didSelectFluidCreamy() {
        
        if(fluidSelectedState == FluidState.creamy) {
            
            self.updateFluidData("", changeSelection: FluidState.creamy)
        } else {
            
            self.updateFluidData("creamy", changeSelection: FluidState.creamy)
        }
    }
    
    @IBAction func didSelectFluidEggwhite() {
        
        if(fluidSelectedState == FluidState.eggwhite) {
            
            self.updateFluidData("", changeSelection: FluidState.eggwhite)
        } else {
            
            self.updateFluidData("eggwhite", changeSelection: FluidState.eggwhite)
        }
    }
    
}