//
//  CommunityForumViewController.h
//  Ovatemp
//
//  Created by Flip Sasser on 4/3/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityForumViewController : UIViewController <UIWebViewDelegate>

@property NSString *URL;
@property IBOutlet UIWebView *webView;

@property IBOutlet UIToolbar *webToolbar;
@property IBOutlet UIBarButtonItem *backButton;
@property IBOutlet UIBarButtonItem *forwardButton;
@property IBOutlet UIBarButtonItem *reloadButton;

@end
