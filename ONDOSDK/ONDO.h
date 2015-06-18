//
//  ONDO.h
//  Ovatemp
//
//  Created by Flip Sasser on 9/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "ONDODevice.h"

@class ONDO;

@protocol ONDODelegate <NSObject>

@optional

- (void)ONDOsaysBluetoothIsDisabled:(ONDO *)ondo;
- (void)ONDOsaysLEBluetoothIsUnavailable:(ONDO *)ondo;

- (void)ONDOdidConnect:(ONDO *)ondo;
- (void)ONDO:(ONDO *)ondo didEncounterError:(NSError *)error;
- (void)ONDO:(ONDO *)ondo didReceiveTemperature:(CGFloat)temperature;

@end

@interface ONDO : NSObject

+ (ONDO *)sharedInstance;
+ (ONDO *)sharedInstanceWithDelegate:(id<ONDODelegate>)delegate;

- (void)startScan;
- (void)stopScan;

- (CBCentralManagerState)centralManagerState;
- (NSUInteger)batteryLevel;

@property (nonatomic) BOOL isScanning;

@property (weak, nonatomic) id<ONDODelegate> delegate;
@property (weak, nonatomic) id<ONDODelegate> testDelegate;

@end
