//
//  TrackingStatusTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 10/30/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrackingCellDelegate <NSObject>

-(void)pushViewController:(UIViewController *)viewController;

@end

@interface TrackingStatusTableViewCell : UITableViewCell

@property(nonatomic,strong)id<TrackingCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *notesButton;
@property (weak, nonatomic) IBOutlet UILabel *notEnoughInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UILabel *enterMoreInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cycleImageView;

@property (weak, nonatomic) IBOutlet UILabel *peakLabel;
@property (weak, nonatomic) IBOutlet UILabel *fertilityLabel;

@end
