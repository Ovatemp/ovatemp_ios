//
//  ONDO.m
//  Ovatemp
//
//  Created by Flip Sasser on 9/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ONDO.h"
#import "ONDOPairViewController.h"

static CBUUID *kONDOUUID;
static NSString *const kONDOIdentifier = @"1809";

@interface ONDO () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic) CBCentralManager *bluetoothManager;
@property (nonatomic) CBPeripheral *peripheral;

@end

@implementation ONDO

+ (ONDO *)sharedInstance
{
    static ONDO *__instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[ONDO alloc] init];
        __instance.bluetoothManager = [[CBCentralManager alloc] initWithDelegate: __instance queue: nil];
    });
    
    return __instance;
}

+ (ONDO *)sharedInstanceWithDelegate:(id<ONDODelegate>)delegate
{
    ONDO *instance = [ONDO sharedInstance];
    instance.delegate = delegate;
    
    return instance;
}

# pragma mark - Start/Stop Scan

- (void)startScan
{
    DDLogInfo(@"ONDO : STARTING SCAN FOR ONDO");
    
    if (!kONDOUUID) {
        kONDOUUID = [CBUUID UUIDWithString: kONDOIdentifier];
    }
    
    [self.bluetoothManager scanForPeripheralsWithServices: @[kONDOUUID] options: nil];
    self.isScanning = YES;
}

- (void)stopScan
{
    DDLogInfo(@"ONDO : STOPPING SCAN FOR ONDO");
    
    [self.bluetoothManager stopScan];
    self.isScanning = NO;
}

# pragma mark - Helpers

- (CGFloat)dataToFloat:(NSData *)data
{
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

- (void)notifyOnError:(NSError *)error
{
    if (error && [self.delegate respondsToSelector: @selector(ONDO:didEncounterError:)]) {
        [self.delegate ONDO: self didEncounterError: error];
    }
}

- (CBCentralManagerState)centralManagerState
{
    return self.bluetoothManager.state;
}

# pragma mark - CBCentralManager Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            DDLogWarn(@"CENTRAL MANAGER STATE: POWERED OFF");
            break;
        case CBCentralManagerStateResetting:
            DDLogWarn(@"CENTRAL MANAGER STATE: RESETTING");
            if ([self.delegate respondsToSelector:@selector(ONDOsaysBluetoothIsDisabled:)]) {
                [self.delegate ONDOsaysBluetoothIsDisabled:self];
            }
            if ([self.testDelegate respondsToSelector:@selector(ONDOsaysBluetoothIsDisabled:)]) {
                [self.testDelegate ONDOsaysBluetoothIsDisabled:self];
            }
            break;
        case CBCentralManagerStateUnauthorized:
            DDLogWarn(@"CENTRAL MANAGER STATE: UNAUTHORIZED");
            break;
        case CBCentralManagerStateUnknown:
            DDLogWarn(@"CENTRAL MANAGER STATE: UNKNOWN");
            break;
        case CBCentralManagerStateUnsupported:
            DDLogWarn(@"CENTRAL MANAGER STATE: UNSUPPORTED");
            if ([self.delegate respondsToSelector:@selector(ONDOsaysLEBluetoothIsUnavailable:)]) {
                [self.delegate ONDOsaysLEBluetoothIsUnavailable:self];
            }
            if ([self.testDelegate respondsToSelector:@selector(ONDOsaysLEBluetoothIsUnavailable:)]) {
                [self.testDelegate ONDOsaysLEBluetoothIsUnavailable:self];
            }
            break;
        case CBCentralManagerStatePoweredOn:
            DDLogInfo(@"CENTRAL MANAGER STATE: POWERED ON!");
            if (self.isScanning) {
                [self startScan];
            }
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    DDLogInfo(@"CENTRAL MANAGER : DID DISCOVER PERIPHERAL: %@", peripheral);

    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    
//    NSDictionary *options = @{CBConnectPeripheralOptionNotifyOnConnectionKey: @NO,
//                            CBConnectPeripheralOptionNotifyOnDisconnectionKey: @NO,
//                            CBConnectPeripheralOptionNotifyOnNotificationKey: @NO};
    
    [self.bluetoothManager connectPeripheral: self.peripheral options: nil];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    DDLogInfo(@"CENTRAL MANAGER : DID CONNECT PERIPHERAL: %@", peripheral);
    
    [self.peripheral discoverServices:@[kONDOUUID]];
    
    if ([self.delegate respondsToSelector:@selector(ONDOdidConnect:)]) {
        [self.delegate ONDOdidConnect: self];
    }
    if ([self.testDelegate respondsToSelector:@selector(ONDOdidConnect:)]) {
        [self.testDelegate ONDOdidConnect: self];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    DDLogInfo(@"CENTRAL MANAGER : DID DISCONNECT PERIPHERAL: %@", peripheral);
    
    [self startScan];

    if (error && error.code != CBErrorPeripheralDisconnected) {
        [self notifyOnError:error];
    }
}

# pragma mark - CBPeripheral Delegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        DDLogError(@"CENTRAL MANAGER : ERROR DISCOVERING SERVICES: %@", error);
        [self notifyOnError:error];
    } else {
        DDLogInfo(@"CENTRAL MANAGER : DID DISCOVER SERVICES: %@", peripheral);
        CBUUID *temperatureCharacterisicUUID = [CBUUID UUIDWithString:@"2A1C"];
        CBService *temperatureService = peripheral.services.firstObject;
        [self.peripheral discoverCharacteristics:@[temperatureCharacterisicUUID]
                                      forService:temperatureService];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        DDLogError(@"CENTRAL MANAGER : ERROR DISCOVERING CHARACTERISTICS %@", error);
        [self notifyOnError:error];
    } else {
        DDLogInfo(@"CENTRAL MANAGER : DID DISCOVER CHARACTERISTICS: %@ ; FOR SERVICE: %@", service.characteristics, service);
        CBCharacteristic *temperatureCharacteristic = service.characteristics.firstObject;
        [self.peripheral setNotifyValue: YES forCharacteristic: temperatureCharacteristic];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        DDLogError(@"CENTRAL MANAGER : ERROR UPDATING NOTIFICATION STATE FOR CHARACTERISTIC: %@", characteristic);
        DDLogError(@"ERROR: %@", error);
    }else{
        DDLogInfo(@"CENTRAL MANAGER : DID UPDATE NOTIFICATION STATE FOR CHARACTERISTIC: %@", characteristic);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        DDLogError(@"CENTRAL MANAGER : ERROR UPDATING VALUE FOR CHARACTERISTIC: %@", error);
        [self notifyOnError:error];
    } else {
        DDLogInfo(@"CENTRAL MANAGER : DID UPDATE VALUE FOR CHARACTERISTIC");
        DDLogInfo(@"READ CHARACTERISTIC: %@", characteristic);
        CGFloat temperature = [self dataToFloat: characteristic.value];
        DDLogVerbose(@"TEMPERATURE: %f", temperature);
        if (temperature > 0) {
            if ([self.delegate respondsToSelector: @selector(ONDO:didReceiveTemperature:)]) {
                [self.delegate ONDO: self didReceiveTemperature: temperature];
            }
            if ([self.testDelegate respondsToSelector: @selector(ONDO:didReceiveTemperature:)]) {
                [self.testDelegate ONDO: self didReceiveTemperature: temperature];
            }
        } else {
            DDLogError(@"CENTRAL MANAGER : TEMPERATURE NOT VALID");
            NSError *error = [NSError errorWithDomain: @"Ovatemp" code: 500 userInfo: @{@"error": @"Could not read ONDO data. Is your battery charged?"}];
            [self notifyOnError: error];
        }
    }
    [self.peripheral setNotifyValue: NO forCharacteristic: characteristic];
}

@end
