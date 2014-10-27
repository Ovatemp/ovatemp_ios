//
//  TemperatureCellEditView.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TemperatureCellEditView.h"

@interface TemperatureCellEditView ()

@property UILabel *temperatureLabel;
@property UISlider *temperatureSlider;

@end

@implementation TemperatureCellEditView

- (CGRect)buildCustomUI:(CGRect)frame {
    UILabel *temperatureLabel = [[UILabel alloc] init];
    temperatureLabel.accessibilityLabel = @"Temperature Value";
    temperatureLabel.font = [UIFont boldSystemFontOfSize:41.0f];
    temperatureLabel.text = @"8008.900º F";
    temperatureLabel.textAlignment = NSTextAlignmentCenter;
    temperatureLabel.textColor = LIGHT;
    [temperatureLabel sizeToFit];
    CGRect temperatureLabelFrame = temperatureLabel.frame;
    temperatureLabelFrame.origin.x = SUPERVIEW_SPACING;
    temperatureLabelFrame.size.width = frame.size.width - SUPERVIEW_SPACING * 2;
    temperatureLabel.frame = temperatureLabelFrame;
    [self addSubview:temperatureLabel];
    self.temperatureLabel = temperatureLabel;
    
    UISlider *slider = [[UISlider alloc] init];
    slider.accessibilityLabel = @"Change Temperature";
    slider.minimumValue = 90.0f;
    slider.maximumValue = 105.0f;
    CGRect sliderFrame = slider.frame;
    sliderFrame.origin.x = SUPERVIEW_SPACING;
    sliderFrame.size.width = frame.size.width - SUPERVIEW_SPACING * 2;
    sliderFrame.origin.y = CGRectGetMaxY(self.temperatureLabel.frame) + SIBLING_SPACING;
    slider.frame = sliderFrame;
    [slider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(saveSliderValue:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self addSubview:slider];
    self.temperatureSlider = slider;
    
    frame.size.height = CGRectGetMaxY(slider.frame) + SUPERVIEW_SPACING;
    return frame;
}

- (void)setValue:(id)value {
    if (value) {
        // Convert to Celsius
        float tempInCelsius = (([value floatValue] - 32) / 1.8000f);
        
        // Display C or F
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *temperatureString;
        
        BOOL tempPrefFahrenheit = [defaults boolForKey:@"temperatureUnitPreferenceFahrenheit"];
        
        if (tempPrefFahrenheit) {
            temperatureString = [NSString stringWithFormat:@"%.1fºF", [value floatValue]];
        } else {
            temperatureString = [NSString stringWithFormat:@"%.1fºC", tempInCelsius];
        }
//        NSString *temperatureString = [NSString stringWithFormat:@"%.1fºF / %.1fºC", [value floatValue], tempInCelsius];
        self.temperatureLabel.text = temperatureString;
        self.temperatureSlider.value = [value floatValue];
        self.temperatureLabel.font = [self.temperatureLabel.font fontWithSize:35.0f];
    } else {
        self.temperatureLabel.text = nil;
        self.temperatureSlider.value = 98.6f;
    }
}

- (void)saveSliderValue:(id)sender {
    [self updateSliderValue:sender];
    [self.delegate attributeValueChanged:self.attribute newValue:@(self.temperatureSlider.value)];
}

- (void)updateSliderValue:(id)sender {
    self.value = @(self.temperatureSlider.value);
}

@end
