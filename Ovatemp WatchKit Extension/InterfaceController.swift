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
    
    let connectionManager = ConnectionManager()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        connectionManager.requestFertilityStatus { (status, error) -> () in
            
            println("status: \(status)")
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
