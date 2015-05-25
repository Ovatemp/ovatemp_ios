//
//  WebViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/8/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "WebViewController.h"

#import "Alert.h"

@interface WebViewController ()

@end

@implementation WebViewController

# pragma mark - Setup

+ (id)withURL:(NSString *)url
{
    id controller = [[self alloc] initWithNibName:@"WebViewController" bundle:nil];
    [(WebViewController *)controller setURL:url];
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    if ([self.navigationController.viewControllers count] == 1) {
        // Presented modally
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(didSelectDone)];
        self.navigationItem.rightBarButtonItem = doneButton;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self startLoading];

    self.tabBarController.tabBar.hidden = YES;
    self.webView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSURL *url = [NSURL URLWithString:self.URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    [self.webView setMediaPlaybackRequiresUserAction:NO];
    [self stopLoading];
    
    self.webView.hidden = NO;
}

- (void)didSelectDone
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

# pragma Web view delegate methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  [Alert presentError:error];
}

@end
