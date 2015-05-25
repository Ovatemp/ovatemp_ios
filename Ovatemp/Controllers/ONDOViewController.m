//
//  ONDOViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/15/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ONDOViewController.h"

@import PassKit;

#import <CCMPopup/CCMPopupTransitioning.h>
#import "Stripe.h"
#import "Stripe+ApplePay.h"

#import "ONDO.h"
#import "OvatempAPI.h"
#import "AccountTableViewCell.h"
#import "WebViewController.h"
#import "ONDOSettingViewController.h"
#import "TutorialHelper.h"
#import "PaymentHelper.h"
#import "ApplePayHelper.h"

@interface ONDOViewController () <UITableViewDelegate, UITableViewDataSource, ONDODelegate, ONDOSettingsViewControllerDelegate>

@property AccountTableViewCell *accountTableViewCell;
@property (nonatomic) BOOL ondoSwitchedState;

@property (nonatomic) ApplePayHelper *applePayHelper;

@property (nonatomic) PKPaymentButton *payButton;
@property (nonatomic) NSDecimalNumber *totalAmount;

@end

@implementation ONDOViewController

NSArray *ondoMenuItems;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.applePayHelper = [[ApplePayHelper alloc] initWithViewController: self];
    
    [self customizeAppearance];
    [self addApplePayButton];
    
    ondoMenuItems = @[@"Setup ONDO", @"About ONDO", @"Instruction Manual"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    if (self.ondoSwitchedState) {
        self.ondoSwitchedState = NO;
        [TutorialHelper showTutorialForOndoInController: self];
    }
}

- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    NSDictionary *viewsDictionary = @{@"label" : self.ondoLabel,
                                      @"tableView" : self.tableView,
                                      @"payButton" : self.payButton};
    
    NSArray *buttonHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-10-[payButton]-10-|"
                                                                                   options: 0
                                                                                   metrics: nil
                                                                                     views: viewsDictionary];
    
    NSArray *buttonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:[label]-10-[payButton(==45)]-10-[tableView]"
                                                                                 options: 0
                                                                                 metrics: nil
                                                                                   views: viewsDictionary];
    
    NSLayoutConstraint *buttonCenterConstraint =   [NSLayoutConstraint constraintWithItem: self.payButton
                                                                                attribute: NSLayoutAttributeCenterX
                                                                                relatedBy: NSLayoutRelationEqual
                                                                                   toItem: self.view
                                                                                attribute: NSLayoutAttributeCenterX
                                                                               multiplier: 1
                                                                                 constant: 0];
    
    [self.view addConstraints: buttonHorizontalConstraints];
    [self.view addConstraints: buttonVerticalConstraints];
    [self.view addConstraint: buttonCenterConstraint];
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.title = @"ONDO";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"accountCell"];
}

- (void)addApplePayButton
{
    self.payButton = [self.applePayHelper paymentButton];
    [self.view addSubview: self.payButton];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [ondoMenuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountCell" forIndexPath:indexPath];
    [[cell textLabel] setText:[ondoMenuItems objectAtIndex:indexPath.row]];
    cell.layoutMargins = UIEdgeInsetsZero;
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            // Pair
            
            ONDOSettingViewController *ondoSettingVC = [[ONDOSettingViewController alloc] init];
            ondoSettingVC.delegate = self;
            
            CCMPopupTransitioning *popup = [CCMPopupTransitioning sharedInstance];
            popup.destinationBounds = CGRectMake(0, 0, 200, 200);
            popup.presentedController = ondoSettingVC;
            popup.presentingController = self;
            popup.dismissableByTouchingBackground = YES;
            popup.backgroundViewColor = [UIColor blackColor];
            popup.backgroundViewAlpha = 0.5f;
            popup.backgroundBlurRadius = 0;
            
            ondoSettingVC.view.layer.cornerRadius = 5;
            
            [self presentViewController: ondoSettingVC animated: YES completion: nil];
            
            break;
        }
            
        case 1: // About
        {
            [TutorialHelper showTutorialForOndoInController: self];
            break;
        }
            
        case 2: // Instructions
        {
            NSString *url = @"https://s3.amazonaws.com/ovatemp/UserManual_2014.02.26.pdf";
            WebViewController *webViewController = [WebViewController withURL:url];
            webViewController.title = @"Instruction Manual";
            [self.navigationController pushViewController:webViewController animated:YES];
            break;
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ONDOSettingsViewController Delegate

- (void)ondoSwitchedToState:(BOOL)state
{
    self.ondoSwitchedState = state;
}

@end
