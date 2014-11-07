//
//  TrackingPeriodTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/6/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingPeriodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodCollapsedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *periodTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *periodTypeCollapsedLabel;

@property (weak, nonatomic) IBOutlet UIButton *noneImageView;
@property (weak, nonatomic) IBOutlet UILabel *noneLabel;
@property (weak, nonatomic) IBOutlet UIButton *spottingImageView;
@property (weak, nonatomic) IBOutlet UILabel *spottingLabel;
@property (weak, nonatomic) IBOutlet UIButton *lightImageView;
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;
@property (weak, nonatomic) IBOutlet UIButton *mediumImageView;
@property (weak, nonatomic) IBOutlet UILabel *mediumLabel;
@property (weak, nonatomic) IBOutlet UIButton *heavyImageView;
@property (weak, nonatomic) IBOutlet UILabel *heavyLabel;

@end
