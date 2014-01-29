//
//  SessionViewController.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SessionType {
  SessionRegister,
  SessionLogin,
  SessionResetPassword
} SessionType;

@interface SessionViewController : UITableViewController

@end
