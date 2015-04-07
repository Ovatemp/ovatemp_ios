//
//  ONDO.m
//  Ovatemp
//
//  Created by Flip Sasser on 9/10/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

#import "ONDO.h"
#import "ONDOPairViewController.h"

static ONDO *kONDOInstance;
static CBUUID *kONDOUUID;
static NSString * const kONDOIdentifier = @"1809";

@interface ONDO () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic) CBCentralManager *bluetoothManager;
@property (nonatomic) CBPeripheral *ondoPeripheral;

@property BOOL isReading;

@end

@implementation ONDO

+ (void)pairDeviceWithDelegate:(id<ONDODelegate>)delegate
{
    self.sharedInstance.delegate = delegate;
    [self.sharedInstance pair];
}

+ (ONDO *)sharedInstance
{
    if (!kONDOInstance) {
        kONDOInstance = [self new];
    }
    return kONDOInstance;
}

+ (void)showPairingWizardWithDelegate:(id<ONDODelegate>)delegate
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootViewController.presentedViewController) {
        rootViewController = rootViewController.presentedViewController;
    }

    ONDOPairViewController *ondoController = [ONDOPairViewController new];
    ondoController.delegate = delegate;
    self.sharedInstance.delegate = ondoController;
    [rootViewController presentViewController:[ondoController buildNavigationController] animated:YES completion:nil];
}

+ (void)startWithDelegate:(id<ONDODelegate>)delegate
{
    self.sharedInstance.delegate = delegate;
    [self.sharedInstance connect];
}

- (void)connect
{
    self.isReading = YES;
    [self start];
}

- (NSArray *)devices
{
    return [ONDODevice all];
}

- (void)pair
{
    self.isReading = NO;
    [self start];
}

- (void)start
{
    if (self.bluetoothManager) {
        [self.bluetoothManager stopScan];
        self.bluetoothManager = nil;
    }
    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate: self queue: nil];
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
    if (error && [self.delegate respondsToSelector:@selector(ONDO:didEncounterError:)]) {
        [self.delegate ONDO:self didEncounterError:error];
    }
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
            break;
        case CBCentralManagerStatePoweredOn:
            DDLogInfo(@"CENTRAL MANAGER STATE: POWERED ON!");
            if (!kONDOUUID) {
                kONDOUUID = [CBUUID UUIDWithString:kONDOIdentifier];
            }
            [central scanForPeripheralsWithServices:@[kONDOUUID] options:nil];
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    DDLogInfo(@"CENTRAL MANAGER : DID DISCOVER PERIPHERAL: %@", peripheral);

    // Connect to the peripheral advertising Ovatemp's temperature
    peripheral.delegate = self;
    NSDictionary *options = @{CBConnectPeripheralOptionNotifyOnConnectionKey: @YES,
                            CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES,
                            CBConnectPeripheralOptionNotifyOnNotificationKey: @YES};
    [central connectPeripheral: peripheral options: options];

    // Stash the device we're connecting
    self.ondoPeripheral = peripheral;
    //[central stopScan];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    DDLogInfo(@"CENTRAL MANAGER : DID CONNECT PERIPHERAL: %@", peripheral);
    
    NSString *uuid = peripheral.identifier.UUIDString;
    ONDODevice *device = [ONDODevice find:uuid];

    if (self.isReading) {
        DDLogInfo(@"ONDO : IS READING");
        // Start negotiations to finally read a temperature
        [peripheral discoverServices:@[kONDOUUID]];
    } else {
        DDLogInfo(@"ONDO : IS PAIRING");
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

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    DDLogInfo(@"CENTRAL MANAGER : DID DISCONNECT PERIPHERAL: %@", peripheral);
    
    if (!kONDOUUID) {
        kONDOUUID = [CBUUID UUIDWithString:kONDOIdentifier];
    }
    [central scanForPeripheralsWithServices:@[kONDOUUID] options:nil];

    // If error code is anything other than 7 - CBErrorPeripheralDisconnected return the error
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
        [peripheral discoverCharacteristics:@[temperatureCharacterisicUUID]
                                 forService:temperatureService];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        DDLogError(@"CENTRAL MANAGER : ERROR DISCOVERING CHARACTERISTICS %@", error);
        [self notifyOnError:error];
    } else {
        DDLogInfo(@"CENTRAL MANAGER : DID DISCOVER CHARACTERISTICS: %@", service.characteristics);
        DDLogInfo(@"CENTRAL MANAGER : FOR SERVICE: %@", service);
        CBCharacteristic *temperatureCharacteristic = service.characteristics.firstObject;
        [peripheral setNotifyValue:YES forCharacteristic:temperatureCharacteristic];
        DDLogInfo(@"CENTRAL MANAGER : SET NOTIFY VALUE = YES : FOR CHARACTERISTIC : %@", temperatureCharacteristic);
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
        CGFloat temperature = [self dataToFloat:characteristic.value];
        if (temperature > 0) {
            if ([self.delegate respondsToSelector:@selector(ONDO:didReceiveTemperature:)]) {
                [self.delegate ONDO:self didReceiveTemperature:temperature];
            }
        } else {
            NSError *error = [NSError errorWithDomain: @"Ovatemp" code: 500 userInfo: @{@"error": @"Could not read ONDO data. Is your battery charged?"}];
            [self notifyOnError: error];
        }
    }
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}

@end
