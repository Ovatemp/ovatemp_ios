//
//  FertilityStatusView.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "FertilityStatusView.h"

#import "UserProfile.h"

@interface FertilityStatusView ()

@property Day *day;

@end

@implementation FertilityStatusView

NSArray *avoidingPregnancyMessages;
NSArray *avoidingPregnancyColors;
NSArray *seekingPregnancyMessages;
NSArray *seekingPregnancyColors;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
      // This is a bit of a hack, but it lets us use the view
      // class multiple times without having to deal with the rigamaroles
      // of a) connecting it in IB b) building it manually in code for each case
      self.label = self.subviews.firstObject;

      self.label.font = [UIFont systemFontOfSize:16];
      self.label.textColor = [UIColor whiteColor];
      self.label.textAlignment = NSTextAlignmentCenter;

      NSMutableArray *messages = [NSMutableArray array];
      NSMutableArray *colors = [NSMutableArray array];

      // Trying to avoid pregnancy
      messages[CYCLE_PHASE_PERIOD] = @"Aunt Flo is here";
      colors  [CYCLE_PHASE_PERIOD] = Color(255, 122, 119);

      messages[CYCLE_PHASE_PREOVULATION] = @"Dry days are safe days\n(watch out for cervical fluid)";
      colors  [CYCLE_PHASE_PREOVULATION] = Color(240, 12, 35);

      messages[CYCLE_PHASE_OVULATION] = @"You're fertile";
      colors  [CYCLE_PHASE_OVULATION] = Color(255, 103, 98);

      messages[CYCLE_PHASE_POSTOVULATION] = @"You're safe have some fun";
      colors  [CYCLE_PHASE_POSTOVULATION] = Color(155, 218, 79);

      avoidingPregnancyMessages = [messages copy];
      avoidingPregnancyColors = [colors copy];

      // Trying to get pregnant
      messages[CYCLE_PHASE_PERIOD] = @"Aunt Flo is here\nPamper yourself!";
      colors  [CYCLE_PHASE_PERIOD] = Color(255, 122, 119);

      messages[CYCLE_PHASE_PREOVULATION] = @"Fertile Window about to open\n(watch out for cervical fluid)";
      colors  [CYCLE_PHASE_PREOVULATION] = Color(157, 228, 227);

      messages[CYCLE_PHASE_OVULATION] = @"You're fertile\nLet's get it on!";
      colors  [CYCLE_PHASE_OVULATION] = Color(155, 218, 79);

      messages[CYCLE_PHASE_POSTOVULATION] = @"Two week wait\nCrossing our fingers ;)";
      colors  [CYCLE_PHASE_POSTOVULATION] = Color(155,155,155);

      seekingPregnancyMessages = [messages copy];
      seekingPregnancyColors = [colors copy];
    }
    return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self update];
}

- (void)updateWithDay:(Day *)day {
  self.day = day;
  [self update];
}

- (void)update {
  if (!self.day.cyclePhase) {
    self.label.text = @"Keep tracking!";
    self.backgroundColor = Color(115, 115, 115);
    return;
  }

  CyclePhaseType phaseType = [kCyclePhaseTypes indexOfObject:self.day.cyclePhase];

  if ([UserProfile current].tryingToConceive) {
    if(self.day.inFertilityWindow) {
      self.label.text = @"You're fertile. Let's get it on!";
      self.backgroundColor = Color(155, 218, 79);
    } else {
      self.label.text = seekingPregnancyMessages[phaseType];
      self.backgroundColor = seekingPregnancyColors[phaseType];
    }
  } else {
    if(self.day.inFertilityWindow) {
      self.label.text = @"You're fertile";
      self.backgroundColor = Color(255, 103, 98);
    } else {
      self.label.text = avoidingPregnancyMessages[phaseType];
      self.backgroundColor = avoidingPregnancyColors[phaseType];
    }
  }
}

@end
