//
//  DateCollectionViewCell.m
//  Ovatemp
//
//  Created by Josh L on 11/3/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "DateCollectionViewCell.h"

@implementation DateCollectionViewCell

// These methods are required to force the colletion view cells to refresh

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay]; // force drawRect:
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    self.monthLabel.text = nil;
    self.dayLabel.text = nil;
    self.statusImageView.image = nil;
}

@end
