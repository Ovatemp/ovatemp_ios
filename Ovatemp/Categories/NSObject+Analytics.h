//
//  NSObject+Analytics.h
//  Ovatemp
//
//  Created by Flip Sasser on 5/27/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Analytics)

- (void)trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;

@end
