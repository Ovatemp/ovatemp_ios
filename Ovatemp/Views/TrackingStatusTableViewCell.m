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
