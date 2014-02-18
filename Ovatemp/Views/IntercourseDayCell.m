//
//  IntercourseDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "IntercourseDayCell.h"

@implementation IntercourseDayCell

- (void)updateControls {
  if(self.day.intercourse) {
    self.intercourseLabel.text = [self.day.intercourse capitalizedString];
    self.intercourseImageView.hidden = FALSE;
  }

  self.unprotectedButton.selected = [self.day isProperty:@"intercourse" ofType:INTERCOURSE_UNPROTECTED];
  self.protectedButton.selected = [self.day isProperty:@"intercourse" ofType:INTERCOURSE_PROTECTED];


  for(UIButton *button in @[self.unprotectedButton, self.protectedButton]) {
    if(button.selected) {
      self.intercourseImageView.image = [button imageForState:UIControlStateNormal];
    }
  }
}

- (IBAction)protectedTapped:(id)sender {
  [self.day updateProperty:@"intercourse" withIndex:INTERCOURSE_PROTECTED];
  [self updateControls];

}

- (IBAction)unprotectedTapped:(id)sender {
  [self.day updateProperty:@"intercourse" withIndex:INTERCOURSE_UNPROTECTED];
  [self updateControls];
}

- (void)initializeControls {
  [self.protectedButton setImage:[UIImage imageNamed:@"Protected"] forState:UIControlStateNormal];
  [self.unprotectedButton    setImage:[UIImage imageNamed:@"Unprotected"] forState:UIControlStateNormal];
}

@end