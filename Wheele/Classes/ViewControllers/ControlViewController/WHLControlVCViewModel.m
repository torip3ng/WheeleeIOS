//
//  WHLControlVCViewModel.m
//  Wheele
//
//  Created by Yaroslav Bulda on 22/02/16.
//  Copyright © 2016 torip3ng. All rights reserved.
//

#import "WHLControlVCViewModel.h"
#import "WHLBluetoothController.h"

@interface WHLControlVCViewModel ()

@property (nonatomic, strong) WHLBluetoothController *bluetoothController;

@end

@implementation WHLControlVCViewModel

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)init {
    self = [super init];
    if (self) {
        _bluetoothController = [WHLBluetoothController new];
    }
    return self;
}

- (void)sendCommandWithXValue:(NSInteger)xValue andYValue:(NSInteger)yValue {
    if (!self.bluetoothController.isConnected) {
        return;
    }
    
    NSString *command = [NSString stringWithFormat:@"%li;%li\n\r", (long)yValue, (long)xValue];
    NSLog(@"%@", command);
    
    [self.bluetoothController sendString:command];
}

@end
