//
//  TodayForesController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/28.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "TodayForesController.h"
#import "ForeshowTableViewCell.h"

@implementation TodayForesController

static NSString *homeCellidentify = @"ForeshowTableViewCell.h";

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}

- (void)viewDidLoad
{
    [self initBackAndTitle:@"今日预告"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ForeshowTableViewCell.h" bundle:nil] forCellReuseIdentifier:homeCellidentify];
    
    self.tableView.tableHeaderView = [[UIView alloc] init];
    self.tableView.allowsSelection = NO;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForeshowTableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ForeshowTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}



@end
