//
//  DayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "DayCell.h"
#import "UIAlertView+WithBlock.h"

@implementation DayCell

- (void)awakeFromNib {
  self.selectionStyle = UITableViewCellSelectionStyleNone;

  self.page1.backgroundColor = [UIColor whiteColor];
  self.page2.backgroundColor = DAY_EDIT_PAGE_COLOR;
  self.page3.backgroundColor = DAY_EDIT_PAGE_COLOR;

  self.scrollView.delegate = self;
  self.pageControl.hidden = TRUE;
  self.isAccessibilityElement = FALSE;

  [self initializeControls];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
  uint pages = self.scrollView.contentSize.width / self.scrollView.frame.size.width;
  uint page = sender.contentOffset.x / sender.frame.size.width;
  BOOL hidden = (pages < 3 || page < 1);

  // We pretend there are only two pages
  self.pageControl.numberOfPages = pages - 1;
  self.pageControl.currentPage = page - 1;

  self.pageControl.hidden = hidden;
}

- (void)setDay:(Day *)day {
    _day = day;

  [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
  [self refreshControls];
}

- (void)refreshControls {
  NSLog(@"refreshControls not implemented for: %@", [self class]);
}

- (void)initializeControls {
  NSLog(@"initializeControls not implemented for %@", [self class]);
}

- (void)toggleDayProperty:(NSString *)key withIndex:(NSInteger)index {
  [self.day toggleProperty:key withIndex:index];
  [self refreshControls];
}

- (BOOL)isDayProperty:(NSString *)key ofType:(NSInteger)index {
  return [self.day isProperty:key ofType:index];
}

- (void)showCreateFormWithTitle:(NSString *)title andClass:(id)class {
  UIAlertView *form = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];

  [form setAlertViewStyle:UIAlertViewStylePlainTextInput];
  [form showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"Save"]) {
      [class createWithName:inputText success:^(NSDictionary *response) {
        [self refreshControls];
      }];
    }
  }];
}

@end
