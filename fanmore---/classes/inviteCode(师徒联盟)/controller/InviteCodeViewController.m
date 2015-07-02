
//  InviteCodeViewController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIViewController+MMDrawerController.h>
#import "InviteCodeViewController.h"
#import "InviteCodeCell.h"
#import "RootViewController.h"
#import "DiscipleViewController.h"
#import "userData.h"


@interface InviteCodeViewController ()

@property (nonatomic, strong) NSString *shareUrl;

@end

@implementation InviteCodeViewController



- (void)_initNav
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"徒弟列表" style:UIBarButtonItemStylePlain handler:^(id sender) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DiscipleViewController *dis = [storyboard instantiateViewControllerWithIdentifier:@"DiscipleViewController"];
        [self.navigationController pushViewController:dis animated:YES];
    }];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNav];

    
    //获取网络数据
    [self setupLables];
    
    //分享码按钮
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData *  user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    [self.shareButton setTitle:[NSString stringWithFormat:@"分享邀请码%@", user.invCode] forState:UIControlStateNormal];
    
    
    //注册转跳通知
    
}






- (void)setupLables{
    
    __weak InviteCodeViewController * wself = self;
    NSString *urlStr = [MainURL stringByAppendingPathComponent:@"shituInfo"];
    [UserLoginTool loginRequestGet:urlStr parame:nil success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"resultCode"] intValue] == 1 && [json[@"systemResultCode"] intValue] == 1) {
            NSLog(@"000000%@",json);
            NSDictionary *dic = json[@"resultData"];
            NSLog(@"%lu", (unsigned long)dic.count);
            
            wself.yesterdayLabel.text = [NSString stringWithFormat:@"%@M", dic[@"yestodayM"]];
            wself.discipleContribution.text = [NSString stringWithFormat:@"%@M", dic[@"totalM"]];
            wself.discipleCount.text = [NSString stringWithFormat:@"%@人", dic[@"apprNum"]];
            wself.shareUrl = dic[@"shareURL"];
        }
    } failure:^(NSError *error) {
        
        //        NSLog(@"请求出错");
    }];
    
}







- (IBAction)shareAction:(UIButton *)sender {
//    NSLog(@"分享邀请吗");
    
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData *  user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"粉猫师徒验证吗%@",user.invCode] defaultContent:nil image:nil title:@"分享粉猫app得流量" url:nil description:nil mediaType:SSPublishContentMediaTypeText];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        if (state == SSResponseStateSuccess)
        {
            [MBProgressHUD showMessage:@"分享成功"];
            NSString *urlStr = [MainURL stringByAppendingPathComponent:@"taskTurnedNotify"];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [UserLoginTool loginRequestGet:urlStr parame:params success:^(id json) {
                if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
                    [MBProgressHUD showError:@"账号被登入"];
                    LoginViewController * aa = [[LoginViewController alloc] init];
                    UINavigationController * cc = [[UINavigationController alloc] initWithRootViewController:aa];
                    [self presentViewController:cc animated:YES completion:nil];
                    return ;
                }
                if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {
                    
                    if ([json[@"resultData"][@"illgel"] intValue]!=0 ||[json[@"resultData"][@"reward"] floatValue] <= 0.0) {
                        [MBProgressHUD  showSuccess:@"分享成功"];
                    }else if([json[@"resultData"][@"reward"] floatValue]> 0){
                        
                        CGFloat rewad = [json[@"resultData"][@"reward"] floatValue];
                        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"恭喜你获得了%@M流量",[NSString xiaoshudianweishudeal:rewad]]];
                        
                        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        
                        //1、保存个人信息
                        NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
                        userData * userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
                        CGFloat current = [userInfo.balance floatValue] + rewad;
                        userInfo.balance = [NSString stringWithFormat:@"%.1f",current];
                        [NSKeyedArchiver archiveRootObject:userInfo toFile:fileName];
                    }
                }
            } failure:^(NSError *error) {
                
            }];
            
        }else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];
//    NSLog(@"分享");

}

@end
