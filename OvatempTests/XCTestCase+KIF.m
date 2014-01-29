//
//  XCTestCase+KIF.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "XCTestCase+KIF.h"

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

@end
