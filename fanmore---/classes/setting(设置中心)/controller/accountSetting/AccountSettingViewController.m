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
#import "FMButton.h"

@interface AccountSettingViewController ()

@end

@implementation AccountSettingViewController

/**
 *  第0组数据
 */
- (void)setupGroup0
{

    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData * usera =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
     NSString* name = usera.name;
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    [self saveControllerToAppDelegate:self];
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
    
    FMButton * quiteAccount = [[FMButton alloc] initWithFrame:CGRectMake(5, ScreenHeight - 140 -20, ScreenWidth - 10, 44)];
    [quiteAccount setTitle:@"退出账号" forState:UIControlStateNormal];
//    [quiteAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quiteAccount.titleLabel.font = [UIFont systemFontOfSize:20];
//    [quiteAccount setBackgroundImage:[UIImage imageNamed:@"button-BR"] forState:UIControlStateNormal];
    [quiteAccount addTarget:self action:@selector(QuiteAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quiteAccount];
    
    
    //注册转跳通知
    
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
    
    UIAlertView * ac = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [ac show];


    
}

/**
 *  退出账号提示按钮
 *
 *  @param alertView   <#alertView description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
        [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
    
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:loginUserName];
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
        //1、保存个人信息
        NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
        [NSKeyedArchiver archiveRootObject:nil toFile:fileName];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//通知专跳
- (void)operWebViewCn:(NSNotification *) notification {
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    detailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    detailVc.taskId = (int)notification.userInfo[@"id"]; //获取问题编号
//    detailVc.type = (int)notification.userInfo[@"type"];  //答题类型
//    detailVc.detailUrl = notification.userInfo[@"detailUrl"];//网页详情的url
//    detailVc.backTime = (int)notification.userInfo[@"backTime"];
//    detailVc.flay = [notification.userInfo[@"flay"] floatValue];
//    detailVc.shareUrl = notification.userInfo[@"shareUrl"];
//    detailVc.titless = notification.userInfo[@"title"];
//    detailVc.pictureUrl = notification.userInfo[@"pictureUrl"];
    if ((int)notification.userInfo[@"type"] == 1) {
        detailVc.title = @"答题任务";
    }else if((int)notification.userInfo[@"type"] == 2){
        detailVc.title = @"报名任务";
    }else if((int)notification.userInfo[@"type"] == 3){
        detailVc.title = @"画册类任务";
    }else{
        detailVc.title = @"游戏类任务";
    }
    
    detailVc.ishaveget=NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReciveTaskId object:nil];
    [self.navigationController pushViewController:detailVc animated:YES];
    
}


@end
