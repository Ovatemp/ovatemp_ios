//
//  SignsDayCell.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayCell.h"
#import "DayToggleButton.h"

@interface SignsDayCell : DayCell
@property (weak, nonatomic) IBOutlet UIImageView *opkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ferningImageView;
@property (weak, nonatomic) IBOutlet DayToggleButton *opkNegativeButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *opkPositiveButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *ferningNegativeButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *ferningPositiveButton;

@end
