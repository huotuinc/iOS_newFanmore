//
//  BegController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/12.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "BegController.h"

@interface BegController ()

@end

@implementation BegController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.trafficField.layer setMasksToBounds:YES];
    self.trafficField.layer.borderWidth = 0.5;
    self.trafficField.layer.borderColor = [UIColor colorWithRed:0.000 green:0.588 blue:1.000 alpha:1.000].CGColor;
    self.trafficField.layer.cornerRadius = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
