//
//  PeriodPage.swift
//  Ovatemp
//
//  Created by Arun Venkatesan on 1/23/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import Foundation
import WatchKit

class PeriodPageViewController: WKInterfaceController {
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func handleUserActivity(context: [NSObject : AnyObject]!) {
        
        if(context != nil) {
            
            super.becomeCurrentPage()
        }
    }
}