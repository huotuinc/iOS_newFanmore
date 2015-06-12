//
//  AccountSettingViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/28.
//  Copyright (c) 2015年 HT. All rights reserved.
//  账户设置

#import "AccountSettingViewController.h"
#import "MJSettingGroup.h"
#import "MJSettingArrowItem.h"
#import "MJSettingLabelItem.h"
#import "MJSettingItem.h"
#import "PersonMessageTableViewController.h"
#import "ChangePasswordController.h"
#import "MassageCenterController.h"
#import "userData.h"

@interface AccountSettingViewController ()

@end

@implementation AccountSettingViewController

/**
 *  第0组数据
 */
- (void)setupGroup0
{
    NSString * name = @"";
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:loginFlag] isEqualToString:@"right"]) {
        //1、登入成功用户数据本地化
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
        userData * usera =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        name = usera.name;
    }
    
    MJSettingItem *advice = [MJSettingLabelItem itemWithTitle:@"手机号" rightTitle:name];
    MJSettingItem *cache = [MJSettingArrowItem itemWithTitle:@"用户资料" destVcClass:nil];
    MJSettingItem *about = [MJSettingArrowItem itemWithTitle:@"密码修改" destVcClass:nil];
    MJSettingItem *handShake = [MJSettingArrowItem itemWithTitle:@"消息中心" destVcClass:nil];
    MJSettingGroup *group = [[MJSettingGroup alloc] init];
    group.items = @[advice, cache, about,handShake];
    [self.data addObject:group];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}


- (void)_initNav
{
    [self initBackAndTitle:@"账号设置"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.scrollEnabled = NO;
    //1显示导航栏
    [self _initNav];
    
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    // 2.添加数据
    [self setupGroup0];
    
    UIButton * quiteAccount = [[UIButton alloc] initWithFrame:CGRectMake(5, ScreenHeight - 140 -20, ScreenWidth - 10, 44)];
    [quiteAccount setTitle:@"退出账号" forState:UIControlStateNormal];
    [quiteAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quiteAccount.titleLabel.font = [UIFont systemFontOfSize:22];
    [quiteAccount setBackgroundImage:[UIImage imageNamed:@"button-BR"] forState:UIControlStateNormal];
    [quiteAccount addTarget:self action:@selector(QuiteAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quiteAccount];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row == 1) {
        
        PersonMessageTableViewController *person = [storyboard instantiateViewControllerWithIdentifier:@"PersonMessageTableViewController"];
        [self.navigationController pushViewController:person animated:YES];
    }
    if (indexPath.row == 2) {
        ChangePasswordController *change = [storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordController"];
        [self.navigationController pushViewController:change animated:YES];
    }
    
    if (indexPath.row == 3) {
        MassageCenterController *messageVC = [storyboard instantiateViewControllerWithIdentifier:@"MassageCenterController"];
        [self.navigationController pushViewController:messageVC animated:YES];
    }
}


- (void)QuiteAccount:(UIButton *)btn{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:loginUserName]) {
        
        LoginViewController * login = [[LoginViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = login;
    }
}
- (void)backAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
