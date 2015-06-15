//
//  settingViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/27.
//  Copyright (c) 2015年 HT. All rights reserved.
//  设置中心

#import "settingViewController.h"
#import "MJSettingGroup.h"
#import "MJSettingArrowItem.h"
#import "MJSettingLabelItem.h"
#import "MJSettingItem.h"
#import "FeedBackViewController.h"


@interface settingViewController ()

@end

@implementation settingViewController


- (void)loadView{
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
   
    //1显示导航栏
    [self _initNav];
     self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 2.添加数据
    [self setupGroup0];
    
    
}
/**
 *  第0组数据
 */
- (void)setupGroup0
{
    MJSettingItem *advice = [MJSettingArrowItem itemWithIcon:nil title:@"意见反馈" destVcClass:[FeedBackViewController class]];
    MJSettingItem *cache = [MJSettingLabelItem itemWithTitle:@"清理缓存" rightTitle:@"110KB"];
    MJSettingItem *about = [MJSettingArrowItem itemWithIcon:nil title:@"关于我们"];
    MJSettingItem *handShake = [MJSettingLabelItem itemWithTitle:@"当前版本" rightTitle:AppVersion];
    MJSettingGroup *group = [[MJSettingGroup alloc] init];
    group.items = @[advice, cache, about,handShake];
    [self.data addObject:group];
}

- (void)_initNav
{
    [self initBackAndTitle:@"更多设置"];
}




- (void)backAction:(UIButton *)btn{
    
    NSLog(@"xxxxxxxxxxxxxx推出登入");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGRect)rectForHeaderInSection:(NSInteger)section{
    
    return CGRectMake(100, 0, 0, 0);
}

@end
