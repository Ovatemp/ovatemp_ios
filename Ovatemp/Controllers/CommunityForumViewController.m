//
//  CommunityForumViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/3/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CommunityForumViewController.h"

#import "ConnectionManager.h"

#import "UIViewController+ConnectionManager.h"
#import "UIViewController+Loading.h"

@interface CommunityForumViewController ()

@end

@implementation CommunityForumViewController

# pragma mark - Setup

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

  NSString *apiParams = [[ConnectionManager sharedConnectionManager] queryStringForDictionary:@{@"return_path": self.URL}];
  NSString *fullURL = [API_URL stringByAppendingFormat:@"/community?%@", apiParams];
  NSURL *url = [NSURL URLWithString:fullURL];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  [self.webView loadRequest:request];
  [self.webView setMediaPlaybackRequiresUserAction:NO];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
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
