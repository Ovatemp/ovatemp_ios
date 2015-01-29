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
    @IBOutlet weak var fluidSelectStickyButton: WKInterfaceButton!
    @IBOutlet weak var fluidSelectCreamyButton: WKInterfaceButton!
    @IBOutlet weak var fluidSelectEggwhiteButton: WKInterfaceButton!
    
    var fluidSelectedState = FluidState.noData
    
    let connectionManager = ConnectionManager()
    
    var todayDate : String = ""
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
        
        self.todayDate = dateFormatter.stringFromDate(NSDate())
        
        // Configure interface objects here.
        connectionManager.requestFluidStatus { (status, error) -> () in
            
            self.updateFluidButtons(status)
        }
    }
    
    func resetButtonImages() {
        
        self.fluidSelectDryButton.setBackgroundImageNamed("btn_fluid_dry")
        self.fluidSelectStickyButton.setBackgroundImageNamed("btn_fluid_sticky")
        self.fluidSelectCreamyButton.setBackgroundImageNamed("btn_fluid_creamy")
        self.fluidSelectEggwhiteButton.setBackgroundImageNamed("btn_fluid_eggwhite")
    }
    
    @IBAction func didSelectFluidDry() {
        
        if(fluidSelectedState == FluidState.dry) {
            
            self.updateFluidData("", changeSelection: FluidState.dry)
        } else {
            
            self.updateFluidData("dry", changeSelection: FluidState.dry)
        }
    }
    
    
    func updateFluidData(fluidSelection: String, changeSelection: FluidState) {
        
        let fluidSelectionString = "day[date]=\(todayDate)&day[cervical_fluid]="+fluidSelection
        
        connectionManager.updateFertilityData (fluidSelectionString, { (success, error) -> () in
            
            if(success) {
                
                self.updateFluidButtons(changeSelection)
            }
        })
    }
    
    func updateFluidButtons(changeSelection: FluidState) {
        
        self.resetButtonImages()
        
        switch changeSelection {
            
        case self.fluidSelectedState:
            self.fluidSelectionLabel.setText("Select")
            self.fluidSelectionLabel.setTextColor(UIColor.lightGrayColor())
            self.fluidSelectedState = FluidState.noData
            
        case FluidState.dry:
            self.fluidSelectionLabel.setText("Dry")
            self.fluidSelectionLabel.setTextColor(UIColor.whiteColor())
            self.fluidSelectDryButton.setBackgroundImageNamed("btn_fluid_dry_p")
            self.fluidSelectedState = FluidState.dry
            
        case FluidState.sticky:
            self.fluidSelectionLabel.setText("Sticky")
            self.fluidSelectionLabel.setTextColor(UIColor.whiteColor())
            self.fluidSelectStickyButton.setBackgroundImageNamed("btn_fluid_sticky_p")
            self.fluidSelectedState = FluidState.sticky
            
        case FluidState.creamy:
            self.fluidSelectionLabel.setText("Creamy")
            self.fluidSelectionLabel.setTextColor(UIColor.whiteColor())
            self.fluidSelectCreamyButton.setBackgroundImageNamed("btn_fluid_creamy_p")
            self.fluidSelectedState = FluidState.creamy
            
        case FluidState.eggwhite:
            self.fluidSelectionLabel.setText("Eggwhite")
            self.fluidSelectionLabel.setTextColor(UIColor.whiteColor())
            self.fluidSelectEggwhiteButton.setBackgroundImageNamed("btn_fluid_eggwhite_p")
            self.fluidSelectedState = FluidState.eggwhite
            
        default:
            self.fluidSelectionLabel.setText("Select")
            self.fluidSelectionLabel.setTextColor(UIColor.lightGrayColor())
            self.fluidSelectedState = FluidState.noData
        }
    }
}