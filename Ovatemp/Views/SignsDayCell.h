//
//  SignsDayCell.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayCell.h"

@interface SignsDayCell : DayCell
@property (weak, nonatomic) IBOutlet UIImageView *opkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ferningImageView;
@property (weak, nonatomic) IBOutlet UIButton *opkNegativeButton;
@property (weak, nonatomic) IBOutlet UIButton *opkPositiveButton;
@property (weak, nonatomic) IBOutlet UIButton *ferningNegativeButton;
@property (weak, nonatomic) IBOutlet UIButton *ferningPositiveButton;

@end
