//
//  FertilityStatusView.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "FertilityStatusView.h"

@implementation FertilityStatusView

NSArray *avoidingPregnancyMessages;
NSArray *avoidingPregnancyColors;
NSArray *seekingPregnancyMessages;
NSArray *seekingPregnancyColors;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
      self.label = self.subviews.firstObject;

      self.label.font = [UIFont systemFontOfSize:16];
      self.label.textColor = [UIColor whiteColor];
      self.label.textAlignment = NSTextAlignmentCenter;

      NSMutableArray *messages = [NSMutableArray array];
      NSMutableArray *colors = [NSMutableArray array];

      // Trying to avoid pregnancy
      messages[CYCLE_PHASE_PERIOD] = @"Try to avoid intercourse";
      colors  [CYCLE_PHASE_PERIOD] = Color(155,155,155);

      messages[CYCLE_PHASE_PREOVULATION] = @"Whoa! You're fertile!";
      colors  [CYCLE_PHASE_PREOVULATION] = Color(240, 12, 35);

      messages[CYCLE_PHASE_OVULATION] = @"Extremely fertile! Keep your knickers on.";
      colors  [CYCLE_PHASE_OVULATION] = Color(240, 12, 35);

      messages[CYCLE_PHASE_POSTOVULATION] = @"Yay! Good to go!";
      colors  [CYCLE_PHASE_POSTOVULATION] = Color(41, 109, 131);

      avoidingPregnancyMessages = [messages copy];
      avoidingPregnancyColors = [colors copy];

      // Trying to get pregnant
      messages[CYCLE_PHASE_PERIOD] = @"Try to avoid intercourse";
      colors  [CYCLE_PHASE_PERIOD] = Color(240, 12, 35);

      messages[CYCLE_PHASE_PREOVULATION] = @"You're fertile. Let's get it on!";
      colors  [CYCLE_PHASE_PREOVULATION] = Color(56, 192, 191);

      messages[CYCLE_PHASE_OVULATION] = @"Peak fertility! Today is the day!";
      colors  [CYCLE_PHASE_OVULATION] = Color(41, 109, 131);

      messages[CYCLE_PHASE_POSTOVULATION] = @"Peak fertility! Today is the day!";
      colors  [CYCLE_PHASE_POSTOVULATION] = Color(155,155,155);

      seekingPregnancyMessages = [messages copy];
      seekingPregnancyColors = [colors copy];
    }
    return self;
}

- (void)updateWithDay:(Day *)day {
  if(!day.cyclePhase) {
    self.label.text = @"Keep tracking!";
    self.backgroundColor = Color(115, 115, 115);
    return;
  }

  CyclePhaseType phaseType = [kCyclePhaseTypes indexOfObject:day.cyclePhase];

  BOOL seekingPregnancy = TRUE;
  if(seekingPregnancy) {
    self.label.text = seekingPregnancyMessages[phaseType];
    self.backgroundColor = seekingPregnancyColors[phaseType];
  } else {
    self.label.text = avoidingPregnancyMessages[phaseType];
    self.backgroundColor = avoidingPregnancyColors[phaseType];
  }
}

@end
