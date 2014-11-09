//
//  TrackingMoodTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingMoodTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *moodPlaceholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodCollapsedLabel;
@property (weak, nonatomic) IBOutlet UITableView *moodTableView;

@end
