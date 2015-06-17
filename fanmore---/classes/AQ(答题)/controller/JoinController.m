//
//  JoinController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/1.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "JoinController.h"

@implementation JoinController



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    if (ScreenWidth == 1334 / 2) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"7501334"]];
    }
    if (ScreenWidth == 2208 / 2) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"12422208"]];
    }
//    if (ScreenWidth == 320) {
//        <#statements#>
//    }
//    
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

@end
