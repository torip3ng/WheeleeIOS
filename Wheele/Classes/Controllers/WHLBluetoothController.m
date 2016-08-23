//
//  WHLBluetoothController.m
//  Wheele
//
//  Created by Yaroslav Bulda on 22/02/16.
//  Copyright © 2016 torip3ng. All rights reserved.
//

#import "WHLBluetoothController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface WHLBluetoothController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *characteristic;

@end

@implementation WHLBluetoothController

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)init {
    self = [super init];
    if (self) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

#pragma mark -
#pragma mark Manage

- (void)sendString:(NSString *)string {
    [self.peripheral writeValue:[string dataUsingEncoding:NSUTF8StringEncoding]
              forCharacteristic:self.characteristic
                           type:CBCharacteristicWriteWithoutResponse];
}

#pragma mark -
#pragma mark Setters / Getters 

- (BOOL)isConnected {
    return self.peripheral.state == CBPeripheralStateConnected;
}

#pragma mark -
#pragma mark Private

- (void)startScan {
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

#pragma mark -
#pragma mark CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self startScan];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"%@", peripheral);
    
    if ([peripheral.name isEqualToString:@"nRF5x"]) {
        [central stopScan];
        self.peripheral = peripheral;
        
        [central connectPeripheral:peripheral options:nil];

    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    self.peripheral = nil;
    self.characteristic = nil;
    [self startScan];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    self.peripheral = nil;
    self.characteristic = nil;
    [self startScan];
}

#pragma mark -
#pragma mark CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"ACB0"]]) {
            [self.peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"ACB1"]]) {
            self.characteristic = characteristic;
            [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSData *data = [characteristic value];
    NSString *value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@ %@", value, data);
    if (self.receiveBlock) {
        self.receiveBlock(value);
    }
}

@end
