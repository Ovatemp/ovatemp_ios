//
//  WebViewController.h
//  Ovatemp
//
//  Created by Flip Sasser on 4/8/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

+ (id)withURL:(NSString *)url;

@property NSString *URL;
@property IBOutlet UIWebView *webView;

@property IBOutlet UIToolbar *webToolbar;
@property IBOutlet UIBarButtonItem *backButton;
@property IBOutlet UIBarButtonItem *forwardButton;
@property IBOutlet UIBarButtonItem *reloadButton;

@end
