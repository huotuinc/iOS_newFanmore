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
#import "WebController.h"
#import "GlobalData.h"

@interface settingViewController ()

@end

@implementation settingViewController

static NSString * _num = nil;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //1、保存全局信息
    NSString *fileName = [path stringByAppendingPathComponent:InitGlobalDate];
    GlobalData *glo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName]; //保存用户信息
    _num = glo.customerServicePhone;
    
    MJSettingItem *advice = [MJSettingArrowItem itemWithIcon:nil title:@"意见反馈" destVcClass:[FeedBackViewController class]];
    MJSettingItem *cache = [MJSettingLabelItem itemWithTitle:@"清理缓存" rightTitle:@"110KB"];
    MJSettingItem *about = [MJSettingArrowItem itemWithIcon:nil title:@"关于我们" destVcClass:[WebController class]];
    MJSettingItem *handShake = [MJSettingLabelItem itemWithTitle:@"当前版本" rightTitle:AppVersion];
    MJSettingItem *guize = [MJSettingArrowItem itemWithIcon:nil title:@"投放指南" destVcClass:[WebController class]];
    MJSettingItem *gz = [MJSettingArrowItem itemWithIcon:nil title:@"规则说明" destVcClass:[WebController class]];
    MJSettingItem *touch = [MJSettingLabelItem itemWithTitle:@"客服热线" rightTitle:glo.customerServicePhone];
    touch.option = ^{
        
        UIAlertView * aaa= [[UIAlertView alloc] initWithTitle:@"客服热线" message:[NSString stringWithFormat:@"确定要拨打%@吗?",glo.customerServicePhone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [aaa show];
     };
    MJSettingGroup *group = [[MJSettingGroup alloc] init];
    group.items = @[advice, cache, about,handShake,guize,gz,touch];
    [self.data addObject:group];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"0");
    }else{ //确定
        NSString *number=[NSString stringWithFormat:@"%@",_num];
        NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }
}
- (void)_initNav
{
    [self initBackAndTitle:@"更多设置"];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    MJSettingGroup *group = self.data[indexPath.section];
    MJSettingItem *item = group.items[indexPath.row];
    
    if (item.option) { // block有值(点击这个cell,.有特定的操作需要执行)
        item.option();
    } else if ([item isKindOfClass:[MJSettingArrowItem class]]) { // 箭头
        MJSettingArrowItem *arrowItem = (MJSettingArrowItem *)item;
        
        // 如果没有需要跳转的控制器
        if (arrowItem.destVcClass == nil) return;
        if (indexPath.row == 2) {//关于我们
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WebController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"WebController"];
            detailVc.type = 5;
            detailVc.title = @"关于我们";
            [self.navigationController pushViewController:detailVc  animated:YES];
            
        }else if (indexPath.row == 4) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WebController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"WebController"];
            detailVc.type = 1;
            detailVc.title = @"投放指南";
            [self.navigationController pushViewController:detailVc  animated:YES];
        }else if(indexPath.row == 5){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WebController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"WebController"];
            detailVc.type = 2;
            detailVc.title = @"规则说明";
            [self.navigationController pushViewController:detailVc  animated:YES];
            
        }else{
            UIViewController *vc = [[arrowItem.destVcClass alloc] init];
            vc.title = arrowItem.title;
            [self.navigationController pushViewController:vc  animated:YES];
        }
        
    }
}




- (void)backAction:(UIButton *)btn{
    
    NSLog(@"xxxxxxxxxxxxxx推出登入");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGRect)rectForHeaderInSection:(NSInteger)section{
    
    return CGRectMake(100, 0, 0, 0);
}

@end
