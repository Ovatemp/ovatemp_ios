//
//  Cycle.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/11/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Cycle.h"

@interface Cycle () {
  Day *_day;
}
@end

@implementation Cycle

- (Cycle *)initWithDay:(Day *)day {
  // Download from the server
  self = [super init];
  if(!self) { return nil; }

  _day = day;
  // create all the days and have them update from the server

  return self;
}

- (Cycle *)previousCycle {
  if(!_day) {
    return nil;
  }

  return [[Cycle alloc] initWithDay:[_day previousDay]];
}

- (Cycle *)nextCycle {
  if(!_day) {
    return nil;
  }

  return [[Cycle alloc] initWithDay:[[self.days lastObject] nextDay]];
}

- (NSArray *)days {
  if(!_day) {
    return @[];
  }
  return @[_day];
}

@end
