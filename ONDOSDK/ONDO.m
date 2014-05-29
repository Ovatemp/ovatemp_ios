//
//  ONDO.m
//  Ovatemp
//
//  Created by Flip Sasser on 9/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ONDO.h"
#import "ONDOPairViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

static ONDO *kONDOInstance;
static CBUUID *kONDOUUID;
static NSString * const kONDOIdentifier = @"1809";

@interface ONDO () <CBCentralManagerDelegate, CBPeripheralDelegate> {
  CBCentralManager *_bluetoothManager;
  NSMutableArray *_connectingDevices;
}

@property BOOL isReading;

@end

@implementation ONDO

+ (void)pairDeviceWithDelegate:(id<ONDODelegate>)delegate {
  self.sharedInstance.delegate = delegate;
  [self.sharedInstance pair];
}

+ (ONDO *)sharedInstance {
  if (!kONDOInstance) {
    kONDOInstance = [self new];
  }
  return kONDOInstance;
}

+ (void)showPairingWizardWithDelegate:(id<ONDODelegate>)delegate {
  UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
  if (rootViewController.presentedViewController) {
    rootViewController = rootViewController.presentedViewController;
  }

  ONDOPairViewController *ondoController = [ONDOPairViewController new];
  ondoController.delegate = delegate;
  self.sharedInstance.delegate = ondoController;
  [rootViewController presentViewController:[ondoController buildNavigationController] animated:YES completion:nil];
}


+ (void)startWithDelegate:(id<ONDODelegate>)delegate {
  self.sharedInstance.delegate = delegate;
  [self.sharedInstance connect];
}

- (void)connect {
  self.isReading = YES;
  [self start];
}

- (NSArray *)devices {
  return [ONDODevice all];
}

- (void)pair {
  self.isReading = NO;
  [self start];
}

# pragma mark - Helpers

- (CGFloat)dataToFloat:(NSData *)data {
  uint8_t *dataPointer = (uint8_t *)data.bytes;
  dataPointer++;

  int32_t tempData = (int32_t)CFSwapInt32LittleToHost(*(uint32_t *)dataPointer);
  dataPointer += 4;

  if (tempData == 0x007FFFFF) {
    return 0.0f;
  }

  int8_t exponent = (int8_t)(tempData >> 24);
  int32_t mantissa = (int32_t)(tempData & 0x00FFFFFF);
  return (CGFloat)(mantissa * pow(10, exponent));
}

- (void)notifyOnError:(NSError *)error {
  if (error && [self.delegate respondsToSelector:@selector(ONDO:didEncounterError:)]) {
    [self.delegate ONDO:self didEncounterError:error];
  }
}

# pragma mark - Bluetooth

- (void)start {
  if (_bluetoothManager) {
    [_bluetoothManager stopScan];
    _bluetoothManager = nil;
  }
  _bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

# pragma mark -- Identifying thermometers

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  switch (central.state) {
    case CBCentralManagerStatePoweredOff:
    case CBCentralManagerStateResetting:
      if ([self.delegate respondsToSelector:@selector(ONDOsaysBluetoothIsDisabled:)]) {
        [self.delegate ONDOsaysBluetoothIsDisabled:self];
      }
      break;
    case CBCentralManagerStateUnauthorized:
    case CBCentralManagerStateUnknown:
    case CBCentralManagerStateUnsupported:
      if ([self.delegate respondsToSelector:@selector(ONDOsaysLEBluetoothIsUnavailable:)]) {
        [self.delegate ONDOsaysLEBluetoothIsUnavailable:self];
      }
      break;
    case CBCentralManagerStatePoweredOn:
      if (!kONDOUUID) {
        kONDOUUID = [CBUUID UUIDWithString:kONDOIdentifier];
      }
      [central scanForPeripheralsWithServices:@[kONDOUUID] options:nil];
      break;
  }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
  // Connect to the peripheral advertising Ovatemp's temperature
  peripheral.delegate = self;
  NSDictionary *options = @{CBConnectPeripheralOptionNotifyOnConnectionKey: @YES,
                            CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES,
                            CBConnectPeripheralOptionNotifyOnNotificationKey: @YES};
  [central connectPeripheral:peripheral options:options];

  // Stash the device we're connecting
  if (!_connectingDevices) {
    _connectingDevices = [NSMutableArray new];
  }
  [_connectingDevices addObject:peripheral];

  // Stop looking for devices
//  [central stopScan];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
  NSString *uuid = peripheral.identifier.UUIDString;
  ONDODevice *device = [ONDODevice find:uuid];

  if (self.isReading) {
    // Start negotiations to finally read a temperature
    [peripheral discoverServices:@[kONDOUUID]];
  } else {
    // Make sure we store a record for this device
    if (!device) {
      device = [ONDODevice create:uuid];
      device.name = [NSString stringWithFormat:@"ONDO #%i", (int)self.devices.count];
      [device save];
      if ([self.delegate respondsToSelector:@selector(ONDO:didAddDevice:)]) {
        [self.delegate ONDO:self didAddDevice:device];
      }
    }
    [central cancelPeripheralConnection:peripheral];
  }

  if (device && [self.delegate respondsToSelector:@selector(ONDO:didConnectToDevice:)]) {
    [self.delegate ONDO:self didConnectToDevice:device];
  }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
  NSLog(@"Disconnected peripheral %@", peripheral);
  [_connectingDevices removeObject:peripheral];
  _bluetoothManager = nil;
  if (error) {
    [self notifyOnError:error];
  }
}

# pragma mark - Reading thermometers

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
  if (error) {
    [self notifyOnError:error];
  } else {
    CBUUID *temperatureCharacterisicUUID = [CBUUID UUIDWithString:@"2A1C"];
    CBService *temperatureService = peripheral.services.firstObject;
    [peripheral discoverCharacteristics:@[temperatureCharacterisicUUID]
                             forService:temperatureService];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
  if (error) {
    [self notifyOnError:error];
  } else {
    CBCharacteristic *temperatureCharacteristic = service.characteristics.firstObject;
    NSLog(@"Reading characteristic %@", temperatureCharacteristic);
    [peripheral setNotifyValue:YES forCharacteristic:temperatureCharacteristic];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  if (error) {
    NSLog(@"ZOMG");
    [self notifyOnError:error];
  } else {
    NSLog(@"Read characteristic %@", characteristic);
    CGFloat temperature = [self dataToFloat:characteristic.value];
    if (temperature > 0) {
      if ([self.delegate respondsToSelector:@selector(ONDO:didReceiveTemperature:)]) {
        [self.delegate ONDO:self didReceiveTemperature:temperature];
      }
    } else {
      NSError *error = [NSError errorWithDomain:@"Ovatemp"
                                           code:500
                                       userInfo:@{@"error": @"Could not read ONDO data. Is your battery charged?"}];
      [self notifyOnError:error];
    }
  }
  [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}

@end
