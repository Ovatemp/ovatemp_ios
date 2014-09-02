//
//  SubscriptionSelectionController.m
//  Ovatemp
//
//  Created by Ed Schmalzle on 7/9/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SubscriptionSelectionController.h"
#import "SubscriptionHelper.h"
#import <StoreKit/StoreKit.h>
#import "SubscriptionMenuCell.h"


static NSString * const kSubscriptionPlanCell = @"SubscriptionMenuCell";
static NSArray const *kExerciseList;
static NSString * const kExerciseName = @"name";
static NSString * const kExerciseIcon = @"icon";

@interface SubscriptionSelectionController ()
@end

@implementation SubscriptionSelectionController {
  SubscriptionHelper *_subscriptionHelper;
  NSArray *_products;
}

#pragma mark - UIViewController overrides

- (void) viewWillAppear:(BOOL)animated {

  if (!kExerciseList) {
    kExerciseList = @[
                         @{kExerciseName: @"   Acupressure",
                           kExerciseIcon: @"Acupressure.png"},
                         @{kExerciseName: @"   Diet & Lifestyle",
                           kExerciseIcon: @"DietAndLifestyle.png"},
                         @{kExerciseName: @"Massage",
                           kExerciseIcon: @"Massage.png"},
                         @{kExerciseName: @"  Meditations",
                           kExerciseIcon: @"Meditations.png"},
                         ];
  }

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

//    _subscriptionHelper = [SubscriptionHelper sharedInstance];
//    if(!_products) {
//      [_subscriptionHelper requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
//        if (success) {
//          _products = products;
//          [self.tableView reloadData];
//        }
//      }];
//    }
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
  return kExerciseList.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSubscriptionPlanCell forIndexPath:indexPath];

  NSDictionary *exercise = kExerciseList[indexPath.row];
  cell.imageView.image = [UIImage imageNamed:exercise[kExerciseIcon]];
  cell.textLabel.text = exercise[kExerciseName];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  SKProduct *selectedProduct = _products[indexPath.row];

  SKPayment * payment = [SKPayment paymentWithProduct: selectedProduct];
  [[SKPaymentQueue defaultQueue] addPayment:payment];

  // TODO: on success, send user to coaching
  // TODO: on failure, display message and send user to subscription selection
}

@end
