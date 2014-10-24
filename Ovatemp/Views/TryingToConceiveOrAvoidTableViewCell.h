//
//  TryingToConceiveOrAvoidTableViewCell.h
//  Ovatemp
//
//  Created by Josh L on 10/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TryingToConceiveOrAvoidTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tryingToImage;
@property (weak, nonatomic) IBOutlet UILabel *tryingToLabel;
@property (weak, nonatomic) IBOutlet UISwitch *tryingToSwitch;

@end
