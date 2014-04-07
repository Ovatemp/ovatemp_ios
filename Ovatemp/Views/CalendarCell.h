//
//  CalendarCell.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *leftBorder;
@property (weak, nonatomic) IBOutlet UIView *fertilityWindowView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@end
