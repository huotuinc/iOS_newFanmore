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
#import "SDImageCache.h"

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
    
    [self saveControllerToAppDelegate:self];
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


// 计算某个路径下的缓存文件大小
- (long long)countCacheFileSizeInPath:(NSString *)path
{
    CGFloat size = 0.0;
    
    
    // 创建文件管理对象
    NSFileManager *manager = [NSFileManager defaultManager]; //单例
    // 获取路径下所有的文件名
    NSArray *fileNames = [manager subpathsOfDirectoryAtPath:path error:nil];
    // 遍历文件夹 计算文件大小
    for (NSString *fileName in fileNames)
    {
        // 通过路径拼接出文件的路径
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, fileName];
        // 获取文件的相关信息
        NSDictionary *attrbutesDic = [manager attributesOfItemAtPath:filePath error:nil];
        long long fileSize = [attrbutesDic[NSFileSize] longLongValue];
        size += fileSize;
    }
    
    return size;
    
}


- (CGFloat)countCacheFileSize
{
    float cache = 0;
    // 缓存主要存在于两个文件夹中
    // /Library/Caches/com.zhujiacong.TimeMovie/fsCachedData/  webView
    // /Library/Caches/com.hackemist.SDWebImageCache.default/  SDWebImage
    // 第一个文件夹
    // 获取沙盒路径
    NSString * shapath = NSHomeDirectory();
    shapath = [shapath stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default/"];
       cache = [self countCacheFileSizeInPath:shapath];
    CGFloat cacheSize = (CGFloat)cache / 1024.0 / 1024.0;
    return cacheSize;
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
    
    //计算缓存
    CGFloat aa = [self countCacheFileSize];
    
    
    MJSettingItem *advice = [MJSettingArrowItem itemWithIcon:nil title:@"意见反馈" destVcClass:[FeedBackViewController class]];
    
    MJSettingItem *cache = [MJSettingLabelItem itemWithTitle:@"清理缓存" rightTitle:[NSString stringWithFormat:@"缓存大小%.1fM",aa]];
    
    
    MJSettingItem *about = [MJSettingArrowItem itemWithIcon:nil title:@"关于我们" destVcClass:[WebController class]];
    MJSettingItem *guize = [MJSettingArrowItem itemWithIcon:nil title:@"投放指南" destVcClass:[WebController class]];
    MJSettingItem *gz = [MJSettingArrowItem itemWithIcon:nil title:@"规则说明" destVcClass:[WebController class]];
    MJSettingItem *touch = [MJSettingLabelItem itemWithTitle:@"客服热线" rightTitle:glo.customerServicePhone];
    touch.option = ^{
        
        UIAlertView * aaa= [[UIAlertView alloc] initWithTitle:@"客服热线" message:[NSString stringWithFormat:@"确定要拨打%@吗?",glo.customerServicePhone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [aaa show];
     };
    MJSettingGroup *group = [[MJSettingGroup alloc] init];
    group.items = @[advice, cache, about,guize,gz,touch];
    [self.data addObject:group];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
//        NSLog(@"0");
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
    if(indexPath.row == 0){
        NSString * aa = [[NSUserDefaults standardUserDefaults] stringForKey:loginFlag];
        if ([aa isEqualToString:@"wrong"]) {
            
            LoginViewController * aa = [[LoginViewController alloc] init];
            UINavigationController *ab = [[UINavigationController alloc] initWithRootViewController:aa];
            [self presentViewController:ab animated:YES completion:nil];
            return;
        }
    }
    if (indexPath.row == 1) {
        
        [[SDImageCache sharedImageCache] clearDisk];
        
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString * dataPath = [path stringByAppendingPathComponent:@"taskID"];
        if (dataPath) {
            
            NSFileManager * fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:dataPath error:nil];
        }
        //1、保存全局信息
        NSString *fileName = [path stringByAppendingPathComponent:InitGlobalDate];
        GlobalData *glo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName]; //保存用户信息
        _num = glo.customerServicePhone;
        
        MJSettingItem *advice = [MJSettingArrowItem itemWithIcon:nil title:@"意见反馈" destVcClass:[FeedBackViewController class]];
        
        MJSettingItem *cache = [MJSettingLabelItem itemWithTitle:@"清理缓存" rightTitle:[NSString stringWithFormat:@"0M"]];
        
        
        MJSettingItem *about = [MJSettingArrowItem itemWithIcon:nil title:@"关于我们" destVcClass:[WebController class]];
        MJSettingItem *guize = [MJSettingArrowItem itemWithIcon:nil title:@"投放指南" destVcClass:[WebController class]];
        MJSettingItem *gz = [MJSettingArrowItem itemWithIcon:nil title:@"规则说明" destVcClass:[WebController class]];
        MJSettingItem *touch = [MJSettingLabelItem itemWithTitle:@"客服热线" rightTitle:glo.customerServicePhone];
        touch.option = ^{
            
            UIAlertView * aaa= [[UIAlertView alloc] initWithTitle:@"客服热线" message:[NSString stringWithFormat:@"确定要拨打%@吗?",glo.customerServicePhone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [aaa show];
        };
        MJSettingGroup *group = [[MJSettingGroup alloc] init];
        group.items = @[advice, cache, about,guize,gz,touch];
        [self.data removeAllObjects];
        [self.data addObject:group];
        
       
        [self.tableView reloadData];
    }
    
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
            
        }else if (indexPath.row == 3) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WebController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"WebController"];
            detailVc.type = 1;
            detailVc.title = @"投放指南";
            [self.navigationController pushViewController:detailVc  animated:YES];
        }else if(indexPath.row == 4){
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

//通知专跳
- (void)operWebViewCn:(NSNotification *) notification {
//    NSLog(@"%@",notification);
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




- (void)backAction:(UIButton *)btn{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGRect)rectForHeaderInSection:(NSInteger)section{
    
    return CGRectMake(100, 0, 0, 0);
}

@end
