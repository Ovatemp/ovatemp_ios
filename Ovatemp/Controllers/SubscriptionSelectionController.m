//
//  SubscriptionSelectionController.m
//  Ovatemp
//
//  Created by Ed Schmalzle on 7/9/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SubscriptionSelectionController.h"

#import "Alert.h"
#import "GradientSegmentedControl.h"
#import "SubscriptionHelper.h"
#import "SubscriptionMenuTableViewCell.h"

#import <StoreKit/StoreKit.h>

static NSArray const *kExerciseList;

@interface SubscriptionSelectionController ()
@end

@implementation SubscriptionSelectionController {
  SubscriptionHelper *_subscriptionHelper;
  NSArray *_products;
}

#pragma mark - UIViewController overrides

- (void) viewWillAppear:(BOOL)animated {

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(productPurchased:)
                                               name:SubscriptionHelperProductPurchasedNotification
                                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.segmentedControl.hidden = YES;
  self.segmentedControl.backgroundColor = [UIColor clearColor];
  [self startLoading];

  _subscriptionHelper = [SubscriptionHelper sharedInstance];
  if(!_products) {
    [_subscriptionHelper requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
      [self stopLoading];

      if (success) {
        _products = products;
        float basePrice = 0;
        for (int i = 0; i < products.count; i++) {
          SKProduct *product = products[i];
          int months = i * 3;
          NSString *description;
          switch (months) {
            case 0:
              description = @"monthly";
              break;
            default:
              description = [NSString stringWithFormat:@"%i months", months];
              break;
          }

          NSString *subtitle;
          if (basePrice == 0) {
            basePrice = product.price.floatValue;
          } else {
            int percentage = 100 - round(product.price.floatValue / months / basePrice * 100);
            subtitle = [NSString stringWithFormat:@"(%i%% off)", percentage];
          }
          NSString *title = [NSString stringWithFormat:@"$%.2f\n%@", product.price.floatValue, description];
          GradientSegmentedControlButton *button = [self.segmentedControl addButtonWithTitle:title subtitle:subtitle];
          [button addTarget:self action:@selector(selectProduct:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.segmentedControl.hidden = NO;
      } else {
        [[Alert alertWithTitle:@"Connect"
                      message:@"There was an issue when trying to connect with In-App Purchases.\nPlease try again later."] show];
      }
    }];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

# pragma mark - StoreKit notifications

- (void)productPurchased: (NSNotification *)notification {
  [self.navigationController popViewControllerAnimated:NO];
}

# pragma mark - UIButtons

- (void)selectProduct:(GradientSegmentedControlButton *)sender {
  SKProduct *selectedProduct = _products[sender.index];
  SKPayment * payment = [SKPayment paymentWithProduct: selectedProduct];
  [[SKPaymentQueue defaultQueue] addPayment:payment];
}

@end
