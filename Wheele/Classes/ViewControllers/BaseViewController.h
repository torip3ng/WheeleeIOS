//
//  BaseViewController.h
// 
//
//  Created by Yaroslav Bulda on 3/5/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

+ (UINavigationController *)viewControllerInNavigation;

- (void)showHudWithMessage:(NSString *)message inView:(UIView *)view;
- (void)showHudWithMessage:(NSString *)message;
- (void)showHud;
- (void)hideHud;

@end
