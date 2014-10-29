//
//  TryingToConceiveOrAvoidTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 10/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TryingToConceiveOrAvoidTableViewCell.h"

@implementation TryingToConceiveOrAvoidTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.tryingToSwitch.onTintColor = [UIColor ovatempAquaColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
