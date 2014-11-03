//
//  DateCollectionViewCell.h
//  Ovatemp
//
//  Created by Josh L on 11/3/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@end
