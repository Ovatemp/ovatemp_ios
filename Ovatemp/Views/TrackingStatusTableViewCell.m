//
//  TrackingStatusTableViewCell.m
//  Ovatemp
//
//  Created by Josh L on 10/30/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TrackingStatusTableViewCell.h"

#import "TrackingNotesViewController.h"
#import "TrackingViewController.h"

@implementation TrackingStatusTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    // change notes button picture if we have a note saved for that date
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateKeyString = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",dateKeyString);
    NSString *keyString = [NSString stringWithFormat:@"note_%@", dateKeyString];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:keyString]) {
        [self.notesButton setImage:[UIImage imageNamed:@"icn_notes_entered"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)presentNotesView:(id)sender {
    
    TrackingNotesViewController *notesVC = [[TrackingNotesViewController alloc] init];
    
//    [[[[[UIApplication sharedApplication] delegate] window] rootViewController].navigationController pushViewController:notesVC animated:YES];
    
    [self PresentViewController:notesVC];
}

-(void)PresentViewController:(UIViewController *)controller {
    // modify your ViewController here
    
    [self.delegate pushViewController:controller];
}

@end
