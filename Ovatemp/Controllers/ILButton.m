//
//  ILButton.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/3/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILButton.h"

@implementation ILButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder]; if(!self) return nil;
    
    [self setDefault];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame]; if(!self) return nil;
    
    [self setDefault];
    
    return self;
}

#pragma mark - Button Styles

- (void)setDefault
{
    UIColor *lightPurple = [UIColor colorWithRed: 143.0/255.0 green: 130.0/255.0 blue: 157.0/255.0 alpha: 1];
    
    self.layer.borderWidth = 2;
    self.layer.cornerRadius = 5;
    
    self.layer.borderColor = [UIColor purpleColor].CGColor;
    self.layer.backgroundColor = lightPurple.CGColor;
    
    [self setTintColor: [UIColor whiteColor]];
}

@end
