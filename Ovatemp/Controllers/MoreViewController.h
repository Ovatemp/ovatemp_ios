//
//  MoreViewController.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *tryingToConceive;
@property (weak, nonatomic) IBOutlet UISwitch *tryingToAvoid;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;

@end
