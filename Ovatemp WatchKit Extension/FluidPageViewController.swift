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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
    }

}