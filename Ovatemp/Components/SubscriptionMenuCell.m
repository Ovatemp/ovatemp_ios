//
//  SubscriptionMenuCell.m
//  Ovatemp
//
//  Created by Ed Schmalzle on 7/14/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SubscriptionMenuCell.h"

@implementation SubscriptionMenuCell

- (void)setPropertiesForProduct:(SKProduct *) product {
  
  self.nameLabel.text = [product localizedTitle];
  self.priceLabel.text = [NSString stringWithFormat: @"$%@", [product price] ];
}

@end
