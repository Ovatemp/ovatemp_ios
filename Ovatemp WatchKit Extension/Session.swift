//
//  Session.swift
//  Ovatemp
//
//  Created by Daniel Lozano on 4/15/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

import UIKit

class Session {
   
    class func isCurrentUserLoggedIn () -> Bool {
        let userToken = retrieveUserTokenFromDefaults()
        let deviceId = retrieveDeviceIdFromDefaults()
     
        return userToken != nil && deviceId != nil
    }
        
    class func retrieveUserTokenFromDefaults() -> String? {
        let sharedDefaults = NSUserDefaults(suiteName: "group.com.ovatemp.ovatemp")
        let userToken = sharedDefaults?.objectForKey("CurrentUserToken") as? String
        return userToken
    }
    
    class func retrieveDeviceIdFromDefaults() -> String? {
        let sharedDefaults = NSUserDefaults(suiteName: "group.com.ovatemp.ovatemp")
        let deviceId = sharedDefaults?.objectForKey("CurrentUserDeviceId") as? String
        return deviceId
    }
    
    class func retrieveUserTypeFromDefaults() -> String? {
        let sharedDefaults = NSUserDefaults(suiteName: "group.com.ovatemp.ovatemp")
        let userType = sharedDefaults?.objectForKey("SharedUserTypeKey") as? String
        print("USER TYPE \(userType)")
        return userType
    }
    
}
