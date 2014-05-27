//
//  NSObject+Analytics.m
//  Ovatemp
//
//  Created by Flip Sasser on 5/27/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "NSObject+Analytics.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

#import <Mixpanel/Mixpanel.h>

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
