//
//  DayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "DayCell.h"

@implementation DayCell

- (void)awakeFromNib{
  self.selectionStyle = UITableViewCellSelectionStyleNone;

  [self initializeControls];
}

- (void)setDay:(Day *)day {
    _day = day;
    
  [self updateControls];
}

- (void)updateControls {
  NSLog(@"updateControls not implemented for: %@", [self class]);
}

- (void)initializeControls {
  NSLog(@"initializeControls not implemented for %@", [self class]);
}

@end
