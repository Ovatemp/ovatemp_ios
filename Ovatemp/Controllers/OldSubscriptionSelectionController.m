//
//  SubscriptionSelectionController.m
//  Ovatemp
//
//  Created by Ed Schmalzle on 7/9/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "OldSubscriptionSelectionController.h"
#import "SubscriptionHelper.h"
#import <StoreKit/StoreKit.h>
#import "SubscriptionMenuCell.h"


static NSString * const kSubscriptionPlanCell = @"SubscriptionMenuCell";

@interface OldSubscriptionSelectionController ()
@end

@implementation OldSubscriptionSelectionController {
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

  _subscriptionHelper = [SubscriptionHelper sharedInstance];
  if(!_products) {
    [_subscriptionHelper requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
      if (success) {
        _products = products;
        [self.tableView reloadData];
      }
    }];
  }
}


- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
}

-(IBAction)restoreButtonTapped:(id)sender {

  [_subscriptionHelper restorePurchases];
}

# pragma mark - StoreKit notifications

- (void)productPurchased: (NSNotification *)notification {

  [self.navigationController popViewControllerAnimated:NO];
}


# pragma mark - Table View

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return [_products count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  SubscriptionMenuCell *cell = [tableView dequeueReusableCellWithIdentifier: kSubscriptionPlanCell forIndexPath:indexPath];
  [cell setPropertiesForProduct: [_products objectAtIndex: indexPath.row]];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  SKProduct *selectedProduct = _products[indexPath.row];

  SKPayment * payment = [SKPayment paymentWithProduct: selectedProduct];
  [[SKPaymentQueue defaultQueue] addPayment:payment];

  // TODO: on success, send user to coaching
  // TODO: on failure, display message and send user to subscription selection
}

@end
