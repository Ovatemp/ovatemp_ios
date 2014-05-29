//
//  ONDO.h
//  Ovatemp
//
//  Created by Flip Sasser on 9/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONDODevice.h"

@class ONDO;

@protocol ONDODelegate <NSObject>

@optional

- (void)ONDOsaysBluetoothIsDisabled:(ONDO *)ondo;
- (void)ONDOsaysLEBluetoothIsUnavailable:(ONDO *)ondo;
- (void)ONDO:(ONDO *)ondo didAddDevice:(ONDODevice *)device;
- (void)ONDO:(ONDO *)ondo didConnectToDevice:(ONDODevice *)device;
- (void)ONDO:(ONDO *)ondo didEncounterError:(NSError *)error;
- (void)ONDO:(ONDO *)ondo didReceiveTemperature:(CGFloat)temperature;

@end

@interface ONDO : NSObject

+ (void)pairDeviceWithDelegate:(id<ONDODelegate>)delegate;
+ (ONDO *)sharedInstance;
+ (void)showPairingWizardWithDelegate:(id<ONDODelegate>)delegate;
+ (void)startWithDelegate:(id<ONDODelegate>)delegate;

@property id <ONDODelegate> delegate;
@property (readonly) NSArray *devices;

@end
