//
//  CoachingWebViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CoachingWebViewController.h"

@interface CoachingWebViewController ()

@end

@implementation CoachingWebViewController

- (void)viewWillAppear:(BOOL)animated {
  [self.webView loadHTMLString:self.webViewContents baseURL:nil];
  [self.webView setMediaPlaybackRequiresUserAction:NO];
}

- (IBAction)backButtonTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:TRUE];
}

@end
