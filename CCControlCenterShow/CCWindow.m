//
//  CCWindow.m
//  CCControlCenterShow
//
//  Created by DjangoZhang on 15/4/26.
//  Copyright (c) 2015年 DjangoZhang. All rights reserved.
//

#import "CCWindow.h"

#import <objc/runtime.h>

NSString * const CCWindowControlCenterDidShowNotification = @"CCWindowControlCenterDidShowNotification";
NSString * const CCWindowControlCenterDidHideNotification = @"CCWindowControlCenterDidHideNotification";

@interface CCWindow ()

@property (nonatomic) BOOL isTouchMovingFromBottom;
@property (nonatomic) BOOL shouldControlCenterShow;

@end

@implementation CCWindow

+ (void)load {
    Method allocMethodOfUIWindow = class_getClassMethod([UIWindow class], @selector(alloc));
    Method allocMethodOfCCWindow = class_getClassMethod([CCWindow class], @selector(alloc));
    if (allocMethodOfUIWindow != nil &&
        allocMethodOfCCWindow != nil) {
        method_setImplementation(allocMethodOfUIWindow, method_getImplementation(allocMethodOfCCWindow));
    }

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    
    return self;
}

- (BOOL)isTouchBeginingFromBottom:(UITouch *)touch {
    CGPoint beginPoint = [touch locationInView:self];
    if (self.bounds.size.height - beginPoint.y < self.bounds.size.height * 0.95f) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isTouchMovingOutBottom:(UITouch *)touch {
    CGPoint movingPoint = [touch locationInView:self];
    if (self.bounds.size.height - movingPoint.y >= 40) {
        return YES;
    }
    
    return NO;
}

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    if (event.type == UIEventTypeTouches) {
        UITouch *touch = [[event allTouches] anyObject];
        NSLog(@"%d:%f", touch.phase, [touch locationInView:self].y);
        if (touch.phase == UITouchPhaseBegan &&
            [self isTouchBeginingFromBottom:touch]) {
            self.isTouchMovingFromBottom = YES;
        } else if (touch.phase != UITouchPhaseBegan &&
                   self.isTouchMovingFromBottom  &&
                   [self isTouchMovingOutBottom:touch]) {
            self.isTouchMovingFromBottom = NO;
            self.shouldControlCenterShow = YES;
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    self.isTouchMovingFromBottom = NO;
    self.shouldControlCenterShow = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:CCWindowControlCenterDidHideNotification object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"resign");
    if (self.shouldControlCenterShow) {
        self.shouldControlCenterShow = NO;
        [self postControlCenterShowNotification];
    } else if (self.isTouchMovingFromBottom) {
        [self performSelector:@selector(touchesMovedSlowly) withObject:nil afterDelay:1.0f];
    }
}

- (void)touchesMovedSlowly {
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        [self postControlCenterShowNotification];
    }
}

- (void)postControlCenterShowNotification {
    NSLog(@"send");
    [[NSNotificationCenter defaultCenter] postNotificationName:CCWindowControlCenterDidShowNotification object:nil];
}

@end
