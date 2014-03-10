//
//  XCTestCase+KIF.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "XCTestCase+KIF.h"
#import "OvatempTestHelpers.h"
#import "SessionViewController.h"
#import "ConnectionManager.h"
#import "UIAccessibilityElement-KIFAdditions.h"

@implementation XCTestCase (KIF)

- (void)failWithException:(NSException *)exception stopTest:(BOOL)stop {
  [self failWithExceptions:@[exception] stopTest:stop];
}

- (void)failWithExceptions:(NSArray *)exceptions stopTest:(BOOL)stop {
  for (NSException *exception in exceptions) {
    NSLog(@"EXCEPTION! %@:%i: %@", exception.filePathInProject, exception.lineNumber.intValue, exception.reason);
  }

  if (stop) {
    NSException *exception = exceptions.firstObject;
    [exception raise];
  }
}

# pragma mark - Session helpers

- (void)resetUsers {
  [ConnectionManager post:@"/test_actions/reset_users"
                   params:@{}
                  success:^(NSDictionary *response) { NSLog(@"reset server's users"); }
                  failure:^(NSError *error) { NSLog(@"couldn't reset server's users"); }];
}

- (void)registerUser {
  if (![ACTIVE_VIEW_CONTROLLER isKindOfClass:[SessionViewController class]]) {
    [self logOut];
  }
  [self resetUsers];
  [tester waitForViewWithAccessibilityLabel:@"New Session Screen"];

  [tester clearTextFromAndThenEnterText:@"test@example.com" intoViewWithAccessibilityLabel:@"Email Field"];
  [tester clearTextFromAndThenEnterText:@"password" intoViewWithAccessibilityLabel:@"Password Field"];
  [tester tapViewWithAccessibilityLabel:@"Sign Up Button"];

  [tester waitForViewWithAccessibilityLabel:@"More"];
}

- (void)logOut {
/*
  UIAccessibilityElement *sessionScreen = [UIAccessibilityElement accessibilityElementWithLabel:@"Session Screen" value:nil traits:UIAccessibilityTraitNone tappable:NO];*/
  
  if (![ACTIVE_VIEW_CONTROLLER isKindOfClass:[SessionViewController class]]) {
    NSLog(@"Logging out because %@ is not a SessionViewController", ACTIVE_VIEW_CONTROLLER);
    // Navigate to the "More" tab
    
    [tester waitForViewWithAccessibilityLabel:@"More"];
    [tester tapViewWithAccessibilityLabel:@"More"];

    // Log the user out
    [tester waitForViewWithAccessibilityLabel:@"Log Out Button"];
    [tester tapViewWithAccessibilityLabel:@"Log Out Button"];
  }
  [tester waitForViewWithAccessibilityLabel:@"New Session Screen"];
}

@end
