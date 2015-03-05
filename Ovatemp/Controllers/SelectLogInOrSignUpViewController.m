//
//  SelectLogInOrSignUpViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SelectLogInOrSignUpViewController.h"
#import "WebViewController.h"

@interface SelectLogInOrSignUpViewController ()

@end

@implementation SelectLogInOrSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self showTutorial];
    
    // Nav bar title font and color
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor ovatempDarkGreyTitleColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"LucidaSans" size:12], NSFontAttributeName,
                                    nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor ovatempAquaColor]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor ovatempAquaColor]];
}

- (void)showTutorial
{
//    UIViewController *presentedVC = [self.storyboard instantiateViewControllerWithIdentifier: @"popupViewController"];
//    
//    CCMPopupTransitioning *popup = [CCMPopupTransitioning sharedInstance];
//    popup.destinationBounds = CGRectMake(0, 0, 300, 400);
//    popup.presentedController = presentedVC;
//    popup.presentingController = self;
//    
//    [self presentViewController: presentedVC animated: YES completion: nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)doPresentTerms:(id)sender
{
    NSString *url = [ROOT_URL stringByAppendingString:@"/terms"];
    WebViewController *webViewController = [WebViewController withURL:url];
    webViewController.title = @"Terms and Conditions";
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
