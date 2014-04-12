//
//  TemperatureCellStaticView.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TemperatureCellStaticView.h"

#import "Calendar.h"
#import "CycleChartView.h"
#import "Day.h"

@interface TemperatureCellStaticView () {
  UIImageView *_cycleImageView;
  UILabel *_temperatureLabel;
}

@property (readonly) UIImageView *cycleImageView;
@property (readonly) UILabel *temperatureLabel;

@end

@implementation TemperatureCellStaticView

# pragma mark - Setup

- (void)setValue:(id)value {
  [super setValue:value];

  CycleChartView *ccv = [[CycleChartView alloc] init];

  [ccv calculateStyle:self.cycleImageView.bounds.size];
  ccv.cycle = [Calendar day].cycle;
  [self.cycleImageView setImage:[ccv drawChart:self.cycleImageView.bounds.size]];

  if (value) {
    NSString *temperatureString = [NSString stringWithFormat:@"%.1fºF", [value floatValue]];
    self.temperatureLabel.text = temperatureString;
  } else {
    self.temperatureLabel.text = nil;
  }
}

# pragma mark - UI Elements

- (UIImageView *)cycleImageView {
   if (!_cycleImageView) {
     CGFloat top = CGRectGetMaxY(self.label.frame) + SIBLING_SPACING;
     CGRect frame = CGRectMake(SUPERVIEW_SPACING, top,
                               self.frame.size.width, self.frame.size.height - top);
     _cycleImageView = [[UIImageView alloc] initWithFrame:frame];
     [self addSubview:_cycleImageView];
     _cycleImageView.backgroundColor = [UIColor redColor];
  }
  return _cycleImageView;
}

@end