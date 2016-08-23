//
//  WHLControlViewController.m
//  Wheele
//
//  Created by Yaroslav Bulda on 22/02/16.
//  Copyright © 2016 torip3ng. All rights reserved.
//

#import "WHLControlViewController.h"
#import "WHLControlVCViewModel.h"

#import "WHLJoyControlView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>

@interface WHLControlViewController () <WHLJoyControlViewDelegate>

@property (nonatomic, strong) WHLControlVCViewModel *viewModel;

@end

@implementation WHLControlViewController

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewModel = [WHLControlVCViewModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
#pragma mark WHLJoyControlViewDelegate

- (void)joyContol:(WHLJoyControlView *)joyControl didChangePositionToXvalue:(NSInteger)xValue andYvalue:(NSInteger)yValue {
    NSLog(@"x:%li y:%li", (long)xValue, (long)yValue);
    [self.viewModel sendCommandWithXValue:xValue andYValue:yValue];
}

@end
