//
//  TrafficShowController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/2.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "TrafficShowController.h"

@interface TrafficShowController ()

@end

@implementation TrafficShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.PICView.progress = 0.8;
    self.PICView.thicknessRatio = 0.1;
    self.PICView.showText = NO;
    self.PICView.innerBackgroundColor = [UIColor colorWithRed:245 green:245 blue:245 alpha:1];
    self.PICView.outerBackgroundColor = [UIColor colorWithRed:1 green:141 blue:255 alpha:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
