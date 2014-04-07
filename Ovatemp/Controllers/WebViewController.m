//
//  WebViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/8/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "WebViewController.h"

#import "ConnectionManager.h"

#import "UIViewController+ConnectionManager.h"
#import "UIViewController+Loading.h"

@interface WebViewController ()

@end

@implementation WebViewController

# pragma mark - Setup

+ (id)withURL:(NSString *)url {
  id controller = [[self alloc] initWithNibName:@"WebViewController" bundle:nil];
  [(WebViewController *)controller setURL:url];
  return controller;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self startLoading];
  self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  NSURL *url = [NSURL URLWithString:self.URL];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  [self.webView loadRequest:request];
  [self.webView setMediaPlaybackRequiresUserAction:NO];
  
}

# pragma Web view delegate methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [self webViewDidFinishLoad:webView];
  [self presentError:error];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [self stopLoading];
}

@end
