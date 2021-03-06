
//  InviteCodeViewController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//  师徒联盟的

#import "UIViewController+MMDrawerController.h"
#import "InviteCodeViewController.h"
#import "InviteCodeCell.h"
#import "RootViewController.h"
#import "DiscipleViewController.h"
#import "userData.h"
#import "Master.h"


#define MASTER @"master"

@interface InviteCodeViewController ()

@property (nonatomic, strong) NSString *shareUrl;

@property (nonatomic, strong) NSString *shareDes;

/**师徒联盟接口返回数据*/
@property (nonatomic,strong) Master * master;

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
    
    //获取网络数据
    
    [self _initNav];
    //分享码按钮
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData *  user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    [self.shareButton setTitle:[NSString stringWithFormat:@"分享邀请码%@", user.invCode] forState:UIControlStateNormal];
    
    [self setupLables];
    //注册转跳通知
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(setButtonRed) userInfo:nil repeats:YES];
    
    [timer fire];
    
    

    
    
}

- (void)setButtonRed {
    //动画 背景变红
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(setButtonBlue)];
    
//    self.shareButton.layer.borderColor = [UIColor colorWithRed:0.919 green:0.288 blue:0.144 alpha:1.000].CGColor;
    self.shareButton.backgroundColor = [UIColor colorWithRed:0.000 green:0.279 blue:0.711 alpha:1.000]
    ;
    
    [UIView commitAnimations];
}

- (void)setButtonBlue {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    
//    self.shareButton.layer.borderColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000].CGColor;
    self.shareButton.backgroundColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000];
    
    [UIView commitAnimations];
}


- (void)setupLables{
    
    __weak InviteCodeViewController * wself = self;
    NSString *urlStr = [MainURL stringByAppendingPathComponent:@"shituInfo"];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:MASTER];
    self.master = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    if (!self.master) {
        [MBProgressHUD showMessage:nil];
    }
    [UserLoginTool loginRequestGet:urlStr parame:nil success:^(id json) {
//        NSLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [aaa show];
            return ;
        }
        
        if ([json[@"resultCode"] intValue] == 1 && [json[@"systemResultCode"] intValue] == 1) {
            
            wself.master = [Master objectWithKeyValues:json[@"resultData"]];
            wself.yesterdayLabel.text = [NSString stringWithFormat:@"%@M", [NSString xiaoshudianweishudeal:wself.master.yestodayM]];
            wself.discipleContribution.text = [NSString stringWithFormat:@"%@M", [NSString xiaoshudianweishudeal:wself.master.totalM]];
            wself.discipleCount.text = [NSString stringWithFormat:@"%d人",wself.master.apprNum];
            wself.shareUrl = wself.master.shareURL;
            wself.shareDes = wself.master.shareDescription;
            wself.rulesLabel.text = wself.master.about;
            
            
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:MASTER];
            [NSKeyedArchiver archiveRootObject:wself.master toFile:fileName];
           
        }
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    
}



/**
 *  账号被顶掉
 *
 *  @param alertView   <#alertView description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    __weak InviteCodeViewController * wself = self;
    if (buttonIndex == 0) {
        
        LoginViewController * aa = [[LoginViewController alloc] init];
        UINavigationController * bb = [[UINavigationController alloc] initWithRootViewController:aa];
        [self presentViewController:bb animated:YES completion:^{
            [wself setupLables];
            
        }];
    }else{
        
    }
}



- (IBAction)shareAction:(UIButton *)sender {
//    NSLog(@"分享邀请吗");
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"master" ofType:@"jpg"];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData *  user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:nil defaultContent:[NSString stringWithFormat:@"粉猫师徒验证码%@",user.invCode] image:[ShareSDK imageWithPath:imagePath] title:self.shareDes url:self.shareUrl description:nil mediaType:SSPublishContentMediaTypeNews];
    [publishContent addSinaWeiboUnitWithContent:self.shareUrl image:INHERIT_VALUE locationCoordinate:nil];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
   
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        if (state == SSResponseStateSuccess)
        {
            [MBProgressHUD showSuccess:@"分享成功"];
            NSString *urlStr = [MainURL stringByAppendingPathComponent:@"taskTurnedNotify"];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [UserLoginTool loginRequestGet:urlStr parame:params success:^(id json) {
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
//            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];
//    NSLog(@"分享");

}

@end
