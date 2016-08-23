//
//  BaseViewController.m
//
//
//  Created by Yaroslav Bulda on 3/5/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "BaseViewController.h"

#import <MBProgressHUD.h>

@interface BaseViewController () <MBProgressHUDDelegate> {
    MBProgressHUD *_hud;
}

@end

@implementation BaseViewController

#pragma mark -
#pragma mark Class methods

+ (UINavigationController *)viewControllerInNavigation {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[self new]];
//    navigationController.navigationBar.translucent = NO;
    return navigationController;
}

#pragma mark -
#pragma mark Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:nil
                                             action:nil];
    
//    self.navigationItem.backBarButtonItem.imageInsets = UIEdgeInsetsMake(0.f, -25.f, 0.f, 0.f);
}

#pragma mark -
#pragma mark Customization helpers

//- (void)setTitle:(NSString *)title {
//    UILabel *titleLabel = (UILabel *) self.navigationItem.titleView;
//    if (titleLabel == nil) {
//        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.backgroundColor = [UIColor clearColor];
//        titleLabel.shadowColor = [UIColor clearColor];
//        
//        UIFont *font = [UIFont fontWithName:@"SFUIText-Regular" size:18.f];
//        titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title
//                                                                    attributes:@{NSFontAttributeName:font,
//                                                                                 NSForegroundColorAttributeName:UIColorFromRGB(0x929292)}];
//        
//        [titleLabel sizeToFit];
//        
//        self.navigationItem.titleView = titleLabel;
////        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:-1.f forBarMetrics:UIBarMetricsDefault];
//        return;
//    }
//    
//    titleLabel.text = title;
//    [titleLabel sizeToFit];
//}

#pragma mark -
#pragma mark MBProgressHud methods

- (void)showHudWithMessage:(NSString *)message inView:(UIView *)view {
    if (_hud) {
        return;
    }
    
    _hud = [[MBProgressHUD alloc] init];
    _hud.delegate = self;
    [view addSubview:_hud];
    
    _hud.labelText = message;
    _hud.opacity = 0.5f;
    _hud.removeFromSuperViewOnHide = YES;
    
    [_hud show:YES];
}

- (void)showHudWithMessage:(NSString *)message {
    [self showHudWithMessage:message inView:self.navigationController.view];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)showHud {
    [self showHudWithMessage:@""];
}

- (void)hideHud {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [_hud hide:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate Methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    _hud = nil;
}

@end
