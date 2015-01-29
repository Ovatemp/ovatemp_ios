//
//  PositionPageViewController.swift
//  Ovatemp
//
//  Created by Arun Venkatesan on 1/29/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import Foundation
import WatchKit

public enum PositionState {
    case noData
    case lowClosedFirm
    case highOpenSoft
}

class PositionPageViewController: WKInterfaceController {
    
    @IBOutlet weak var positionSelectionLabel: WKInterfaceLabel!
    @IBOutlet weak var positionSelectLowClosedFirmButton: WKInterfaceButton!
    @IBOutlet weak var positionSelectHighOpenSoftButton: WKInterfaceButton!
}