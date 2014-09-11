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

  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ShouldRotate"];

  if (!kExerciseList) {
    kExerciseList = @[
                         @{kExerciseName: @"    Acupressure",
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

- (void)logsubviews:(UIView *)view withDepth:(int)depth {
  NSString *indent = @"";
  for (int i = 0; i < depth; i++) {
    indent = [indent stringByAppendingString:@" "];
  }

  NSLog(@"%@%@", indent, view);
  for (UIView *subview in view.subviews) {
    [self logsubviews:subview withDepth:depth + 2];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShouldRotate"];
}

- (void)viewDidLoad {

  [super viewDidLoad];

    _subscriptionHelper = [SubscriptionHelper sharedInstance];
    if(!_products) {
      [_subscriptionHelper requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        NSLog(@"THINGS %@", products);
        if (success) {
          _products = products;
            [self buttonsAreEnabled:YES];
        } else {
          UIAlertView *noProducts = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"There was an issue when trying to connect with In-App Purchases. \nPlease try again later." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
          [noProducts show];
          /* Replace above UIAlertview with...
          [self buttonsAreEnabled:YES];
          ...for local testing */
        }
      }];
    }
  [self buttonsAreEnabled:NO];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//  return 52.0f;
//}

- (void) selectionMadeForProduct:(SKProduct*)selectedProduct {
  SKPayment * payment = [SKPayment paymentWithProduct: selectedProduct];
  [[SKPaymentQueue defaultQueue] addPayment:payment];

  // TODO: on success, send user to coaching
  // TODO: on failure, display message and send user to subscription selection
}

# pragma mark - UIButtons

- (IBAction)leftSegmentedButtonPressed:(GradientButton *)sender {
  SKProduct *selectedProduct = _products[0];
  [self selectionMadeForProduct:selectedProduct];
}

- (IBAction)centerSegmentedButtonPressed:(GradientButton *)sender {
  SKProduct *selectedProduct = _products[1];
  [self selectionMadeForProduct:selectedProduct];
}

- (IBAction)rightSegmentedButtonPressed:(GradientButton *)sender {
  SKProduct *selectedProduct = _products[2];
  [self selectionMadeForProduct:selectedProduct];
}

- (IBAction)centerDiscountButtonPressed:(GradientButton *)sender {
  [self centerSegmentedButtonPressed:sender];
}

- (IBAction)rightDiscountButtonPressed:(GradientButton *)sender {
  [self rightSegmentedButtonPressed:sender];
}

-(IBAction)restoreButtonTapped:(id)sender {

  [_subscriptionHelper restorePurchases];
}

- (void) buttonsAreEnabled:(BOOL)enabled {
  BOOL disabled = !enabled;
  _leftSegmentedButton.highlighted = disabled;
  _leftSegmentedButton.enabled = enabled;
  _centerSegmentedButton.highlighted = disabled;
  _centerSegmentedButton.enabled = enabled;
  _rightSegmentedButton.highlighted = disabled;
  _rightSegmentedButton.enabled = enabled;
  _centerDiscountButton.highlighted = disabled;
  _centerDiscountButton.enabled = enabled;
  _rightDiscountButton.highlighted = disabled;
  _rightDiscountButton.enabled = enabled;

}

@end
