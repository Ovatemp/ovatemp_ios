//
//  SimpleSupplement.h
//  Ovatemp
//
//  Created by Josh L on 11/16/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

// I created this object so I could maniplate symptoms without messing with the data model that was already in place
// I'm writing this with hours left in the engagement, don't judge

#import <Foundation/Foundation.h>

@interface SimpleSupplement : NSObject

@property BOOL belongsToAllUsers;
@property NSString *createdAt;
@property NSNumber *idNumber;
@property NSString *name;
@property NSString *updatedAt;
@property NSString *userID;

@end
