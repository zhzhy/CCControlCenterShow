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

@property (nonatomic) BOOL isControlCenterShow;

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
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    
    return self;
}

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    if (event.type == UIEventTypeTouches) {
        UITouch *touch = [[event allTouches] anyObject];
        NSLog(@"%d:%f", touch.phase, [touch locationInView:self].y);
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (self.isControlCenterShow) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CCWindowControlCenterDidShowNotification object:nil];
        self.isControlCenterShow = NO;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"resign");
}

@end
