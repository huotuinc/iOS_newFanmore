
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNav];
    
//    http://192.168.0.14:8080/fanmoreweb/shituInfo?appKey=b73ca64567fb49ee963477263283a1bf&cityCode=1372&operation=FM2015AP&timestamp=1435066431429&imei=54604120-5BF8-4A37-96F1-1C6BA6AA881A&version=3.0.0&lat=37.785834&token=353a64340c2a4a1a864396a0c2eccd82&sign=6333bb24a4dc5e10cbf92f3f310d2902&lng=116.406417&cpaCode=default
//    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.14:8080/fanmoreweb/shituInfo"];
    NSString *urlStr = [MainURL stringByAppendingPathComponent:@"shituInfo"];
    [UserLoginTool loginRequestGet:urlStr parame:nil success:^(id json) {
       
        NSLog(@"000000%@",json);
        NSDictionary *dic = json[@"resultData"];
        
        self.yesterdayLabel.text = [NSString stringWithFormat:@"%@M",dic[@"yestodayM"]];
        self.discipleContribution.text = [NSString stringWithFormat:@"%@M", dic[@"totalM"]];
        self.discipleCount.text = [NSString stringWithFormat:@"%@人", dic[@"apprNum"]];
        self.shareUrl = dic[@"shareURL"];
    } failure:^(NSError *error) {
        
        NSLog(@"请求出错");
    }];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData *  user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    [self.shareButton setTitle:[NSString stringWithFormat:@"分享邀请码%@", user.invCode] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}










- (IBAction)shareAction:(UIButton *)sender {
    NSLog(@"分享邀请吗");
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:self.shareUrl defaultContent:@"测试一下" image:[ShareSDK imageWithPath:imagePath] title:@"分享粉猫app得流量" url:@"http://www.mob.com" description:@"这是一条测试信息" mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        if (state == SSResponseStateSuccess)
        {
            
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
            NSString *urlStr = [MainURL stringByAppendingPathComponent:@"taskTurnedNotify"];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            
            [UserLoginTool loginRequestGet:urlStr parame:params success:^(id json) {
                
                NSLog(@"%@",json);
            } failure:^(NSError *error) {
                
            }];
            
        }else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];
    NSLog(@"分享");

}
@end
