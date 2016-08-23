//
//  WHLBluetoothController.h
//  Wheele
//
//  Created by Yaroslav Bulda on 22/02/16.
//  Copyright © 2016 torip3ng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WHLBluetoothReceivedString)(NSString *receivedStr);

@interface WHLBluetoothController : NSObject

@property (nonatomic, strong) WHLBluetoothReceivedString receiveBlock;
@property (nonatomic) BOOL isConnected;

- (void)sendString:(NSString *)string;

@end
