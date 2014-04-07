//
//  UINavigationItem+IconLabel.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UINavigationItem+IconLabel.h"

@interface UINavigationItem ()

@end

@implementation UINavigationItem (IconLabel)


- (IconLabel *)iconLabel {
  if (![self.titleView isKindOfClass:[IconLabel class]]) {
    return nil;
  }
  return (IconLabel *)self.titleView;
}

- (UIImage *)titleIcon {
  return self.iconLabel.image;
}

- (void)setTitleIcon:(UIImage *)titleIcon {
  IconLabel *iconLabel = self.iconLabel;
  if (!iconLabel) {
    iconLabel = [[IconLabel alloc] init];
    iconLabel.font = [UIFont boldSystemFontOfSize:17.0f];
  }
  iconLabel.text = self.title;
  iconLabel.image = titleIcon;
  self.titleView = iconLabel;
}

@end
