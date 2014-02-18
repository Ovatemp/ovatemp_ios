//
//  IntercourseDayCell.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayCell.h"

@interface IntercourseDayCell : DayCell
@property (weak, nonatomic) IBOutlet UILabel *intercourseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *intercourseImageView;
@property (weak, nonatomic) IBOutlet DayToggleButton *protectedButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *unprotectedButton;

@end
