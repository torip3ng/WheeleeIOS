//
//  WHLJoyControlView.h
//  Wheele
//
//  Created by Yaroslav Bulda on 23/02/16.
//  Copyright © 2016 torip3ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WHLJoyControlView;

@protocol WHLJoyControlViewDelegate <NSObject>

- (void)joyContol:(WHLJoyControlView *)joyControl didChangePositionToXvalue:(NSInteger)xValue andYvalue:(NSInteger)yValue;

@end

@interface WHLJoyControlView : UIView

@property (weak, nonatomic) IBOutlet id<WHLJoyControlViewDelegate> delegate;

@end
