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
        
    }

}