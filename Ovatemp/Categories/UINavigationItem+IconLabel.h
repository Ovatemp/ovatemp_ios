//
//  UINavigationItem+IconLabel.h
//  Ovatemp
//
//  Created by Flip Sasser on 4/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IconLabel.h"

@interface UINavigationItem (IconLabel)

@property (readonly) IconLabel *iconLabel;
@property UIImage *titleIcon;

@end
