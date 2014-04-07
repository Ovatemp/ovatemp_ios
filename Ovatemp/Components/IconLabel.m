//
//  IconLabel.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/9/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "IconLabel.h"

@interface IconLabel () {
  UIEdgeInsets _imageInsets;
  UIImageView *_imageView;
}
@end

@implementation IconLabel

@synthesize image = _image;

- (UIImage *)image {
  return _image;
}

- (void)setImage:(UIImage *)image {
  [self sizeToFit];
  if (image) {
    _image = image;
    if (!_imageView) {
      _imageView = [[UIImageView alloc] initWithImage:_image];
      [self addSubview:_imageView];
    } else {
      _imageView.image = _image;
      [_imageView sizeToFit];
    }
    CGPoint imageOrigin = CGPointMake(0, (self.frame.size.height - _image.size.height) / 2);
    CGRect imageFrame = {.origin = imageOrigin, .size = _image.size};
    _imageView.frame = imageFrame;
    _imageInsets = UIEdgeInsetsMake(0, _image.size.width + SIBLING_SPACING, 0, 0);
  } else {
    _image = nil;
    [_imageView removeFromSuperview];
    _imageView = nil;
    _imageInsets = UIEdgeInsetsZero;
  }
  [self sizeToFit];
}


- (void)drawTextInRect:(CGRect)rect {
  [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _imageInsets)];
}

- (CGSize)intrinsicContentSize {
  CGSize size = [super intrinsicContentSize];
  size.width += _imageInsets.left + _imageInsets.right + 1;
  size.height += _imageInsets.top + _imageInsets.bottom;
  return size;
}

- (CGSize)sizeThatFits:(CGSize)size {
  CGSize newSize = [super sizeThatFits:size];
  newSize.width += _imageInsets.left + _imageInsets.right + 1;
  newSize.height += _imageInsets.top + _imageInsets.bottom;
  return newSize;
}

@end