//
//  WeightTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 10/23/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "WeightTableViewCell.h"

@implementation WeightTableViewCell

NSMutableArray *weightPickerData;

- (void)awakeFromNib {
    // Initialization code
    
    weightPickerData = [[NSMutableArray alloc] init];
    
    for (int i = 100; i < 1000; i++) {
        [weightPickerData addObject:[NSString stringWithFormat:@"%d", i]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
