//
//  WHLJoyControlView.m
//  Wheele
//
//  Created by Yaroslav Bulda on 23/02/16.
//  Copyright © 2016 torip3ng. All rights reserved.
//

#import "WHLJoyControlView.h"

@interface WHLJoyControlView ()

@property (nonatomic, strong) UIImageView *padImageView;
@property (nonatomic, strong) UIImageView *btnImageView;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic) CGFloat joyPadRadiusSquared;
@property (nonatomic) CGFloat joyPadRadius;

@property (nonatomic) NSInteger range;
@property (nonatomic) NSInteger currentValueX, currentValueY;

@end

@implementation WHLJoyControlView

#pragma mark -
#pragma mark Constant defination

static NSString *const WHLJoyPadDefaulImage = @"defaultJoyPad";
static NSString *const WHLJoyBtnDefaulImage = @"defaultJoyBtn";

#pragma mark -
#pragma mark Lifecycle methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = UIColor.clearColor;
    
    self.padImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:WHLJoyPadDefaulImage]];
    [self addSubview:self.padImageView];
    
    self.btnImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:WHLJoyBtnDefaulImage]];
    self.btnImageView.frame = CGRectMake(0.f, 0.f, 50.f, 50.f);
    self.btnImageView.userInteractionEnabled = YES;
    self.btnImageView.center = self.padImageView.center;
    [self addSubview:self.btnImageView];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panJoyBtn:)];
    [self.panGesture setMaximumNumberOfTouches:1];
    [self.btnImageView addGestureRecognizer:self.panGesture];
    
    self.joyPadRadius = self.frame.size.width/2 - self.btnImageView.frame.size.width/2;
    
    self.joyPadRadiusSquared = self.joyPadRadius * self.joyPadRadius;
    self.range = 200;
    
    self.currentValueX = self.currentValueY = 0;
}

#pragma mark -
#pragma mark GestureRecognizer methods

- (void)panJoyBtn:(UIPanGestureRecognizer *)gestureRecognizer {
    UIView *joyBtn = [gestureRecognizer view];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint newPos = [self calcNewPositionWithTranslation:[gestureRecognizer translationInView:[self superview]]];
        
        [joyBtn setCenter:newPos];
        [gestureRecognizer setTranslation:CGPointZero inView:[self superview]];
        
        [self sendMessageToDelegateWithXpos:newPos.x andYpos:newPos.y];
    } else {
        [self stop];
    }
}

#pragma mark -
#pragma mark Delegate methods

- (void)sendMessageToDelegateWithXpos:(CGFloat)xpos andYpos:(CGFloat)ypos {
    NSInteger tempXvalue = (xpos - self.btnImageView.frame.size.width/2 - self.joyPadRadius) / self.joyPadRadius * self.range;
    NSInteger tempYvalue = (self.joyPadRadius - ypos + self.btnImageView.frame.size.width/2) / self.joyPadRadius * self.range;
    
    if (tempXvalue != self.currentValueX || tempYvalue != self.currentValueY) {
        self.currentValueX = tempXvalue;
        self.currentValueY = tempYvalue;
        
        if ([self.delegate respondsToSelector:@selector(joyContol:didChangePositionToXvalue:andYvalue:)]) {
            [self.delegate joyContol:self didChangePositionToXvalue:self.currentValueX andYvalue:self.currentValueY];
        }
    }
}

#pragma mark -
#pragma mark Private

- (void)stop {
    [UIView animateWithDuration:0.1f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.btnImageView.center = self.padImageView.center;
                     }
                     completion:^(BOOL finished) {
                         [self sendMessageToDelegateWithXpos:self.btnImageView.center.x andYpos:self.btnImageView.center.y];
                     }];
}

#pragma mark -
#pragma mark Geomery methods

- (CGPoint)calcNewPositionWithTranslation:(CGPoint)translation {
    CGPoint touchPos = [self ccpAdd:self.btnImageView.center and:translation];
    return [self calcNewPositionWithPos:touchPos];
}

- (CGPoint)calcNewPositionWithPos:(CGPoint)pos {
    CGPoint delta =  [self ccpSub:pos and:self.padImageView.center];
    CGPoint newPos = pos;
    
    float joybtnAngle = [self ccpToAngle:delta];
    float joybtnDistSquared = [self distanceFromJoypadSquared:newPos];
    
    if (joybtnDistSquared > self.joyPadRadiusSquared) {
        newPos = [self ccpAdd:self.padImageView.center and:[self ccpMult:[self ccpForAngle:joybtnAngle] and:self.joyPadRadius]];
        joybtnDistSquared = self.joyPadRadiusSquared;
    }
    
    return newPos;
}

- (CGFloat)distanceFromJoypadSquared:(CGPoint)p {
    return [self ccpLengthSQ:[self ccpSub:p and:self.padImageView.center]];
}

- (CGPoint)ccpAdd:(CGPoint)v1 and:(CGPoint)v2 {
    return CGPointMake(v1.x + v2.x, v1.y + v2.y);
}

- (CGPoint)ccpSub:(CGPoint)v1 and:(CGPoint)v2 {
    return CGPointMake(v1.x - v2.x, v1.y - v2.y);
}

- (CGPoint)ccpMult:(CGPoint)v and:(CGFloat)s {
    return CGPointMake(v.x*s, v.y*s);
}

- (CGFloat)ccpToAngle:(CGPoint)v {
    return atan2f(v.y, v.x);
}

- (CGFloat)ccpDot:(CGPoint)v1 and:(CGPoint)v2 {
    return v1.x*v2.x + v1.y*v2.y;
}

- (CGFloat)ccpLengthSQ:(CGPoint)v {
    return [self ccpDot:v and:v];
}

- (CGPoint)ccpForAngle:(CGFloat)a {
    return CGPointMake(cosf(a), sinf(a));
}

@end
