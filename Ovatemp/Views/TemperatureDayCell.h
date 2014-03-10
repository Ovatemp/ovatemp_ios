//
//  TemperatureDayCell.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayCell.h"
#import "CycleChartView.h"
#import "OTScrollView.h"

@interface TemperatureDayCell : DayCell

@property (weak, nonatomic) IBOutlet OTScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *temperatureLabel;
@property (nonatomic, weak) IBOutlet CycleChartView *cycleChartView;
@property (weak, nonatomic) IBOutlet UILabel *editTemperatureLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *setTemperatureButton;
@property (weak, nonatomic) IBOutlet UISwitch *disturbanceSwitch;

@end
