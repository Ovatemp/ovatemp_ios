//
//  SubscriptionMenuCell.h
//  Ovatemp
//
//  Created by Ed Schmalzle on 7/14/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
@import StoreKit;

@interface SubscriptionMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)setPropertiesForProduct:(SKProduct *) product;

@end
