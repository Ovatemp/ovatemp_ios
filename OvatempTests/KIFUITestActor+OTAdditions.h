//
//  KIFUITestActor+OTAdditions.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/19/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "KIFUITestActor.h"
#import "OvatempTestHelpers.h"

@interface KIFUITestActor (OTAdditions)

- (void)resetUsers;
- (void)registerUser;
- (void)logOut;
- (UITextField *)enterDate:(NSDate*)date intoDatePickerTextFieldWithAccessibilityLabel:(NSString*)label;

@end
