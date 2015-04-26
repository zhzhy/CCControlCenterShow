//
//  ViewController.m
//  CCControlCenterShow
//
//  Created by DjangoZhang on 15/4/26.
//  Copyright (c) 2015年 DjangoZhang. All rights reserved.
//

#import "ViewController.h"

extern NSString * const CCWindowControlCenterDidShowNotification;
extern NSString * const CCWindowControlCenterDidHideNotification;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controlCenterDidShow:) name:CCWindowControlCenterDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controlCenterDidHide:) name:CCWindowControlCenterDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controlCenterDidShow:(NSNotification *)aNotification {
    NSLog(@"ControlCenter Did Show");
}

- (void)controlCenterDidHide:(NSNotification *)aNotification {
    NSLog(@"ControlCenter Did Hide");
}

@end
