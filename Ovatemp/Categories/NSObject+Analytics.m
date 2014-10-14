//
//  NSObject+Analytics.m
//  Ovatemp
//
//  Created by Flip Sasser on 5/27/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "NSObject+Analytics.h"

// Google Analytics
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "Mixpanel.h"

@implementation NSObject (Analytics)

- (void)trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value {
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                        action:action
                                                         label:label
                                                         value:value] build]];

  NSMutableDictionary *mixpanelProperties = [NSMutableDictionary dictionaryWithCapacity:2];
  if (action && label) {
    mixpanelProperties[action] = label;
  }
  if (value) {
    mixpanelProperties[@"Value"] = value.stringValue;
  }
  [[Mixpanel sharedInstance] track:category properties:mixpanelProperties];
}


@end
