//
//  TrackingOvulationTestTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/9/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingOvulationTestTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *ovulationCollapsedLabel;

@property (weak, nonatomic) IBOutlet UIButton *ovulationTypeNegativeImageView;
@property (weak, nonatomic) IBOutlet UILabel *ovulationTypeNegativeLabel;

@property (weak, nonatomic) IBOutlet UIButton *oulationTypePositiveImageView;
@property (weak, nonatomic) IBOutlet UILabel *ovulationTypePositiveLabel;

@end
