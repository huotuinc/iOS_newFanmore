//
//  detailViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//  ss
#import "detailViewController.h"
#import "AnswerController.h"
#import "LoginViewController.h"
#import "UserLoginTool.h"
#import "taskDetail.h"
#import "WebController.h"
#import "userData.h"
#import "HAMineLoveCarDBOperator.h"
#import "SDWebImageManager.h"
#import "taskData.h"


@interface detailViewController ()<LoginViewDelegate>


/**详情页面的网页*/
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;


@property (weak, nonatomic) IBOutlet UIButton *answerBtn;

/**几道答题*/
@property(nonatomic,strong) NSMutableArray * detailTasks;


/**几道答题*/
@property(nonatomic,strong) taskData * sampleData;

@end

@implementation detailViewController



- (NSMutableArray *)detailTasks{
    
    if (_detailTasks == nil) {
        
        _detailTasks = [NSMutableArray array];
    }
    
    return _detailTasks;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    //获取题目s
    [self getQuestion];
    
    [MBProgressHUD showMessage:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
    [self saveControllerToAppDelegate:self];
}



- (void)setupview{
    
    if(self.sampleData.type == 1){
        self.title = @"答题类";
    }else if(self.sampleData.type == 2){
        self.title = @"报名类";
    }else if (self.sampleData.type == 3){
        self.title = @"画册类";
    }else{
        self.title = @"游戏类";
    }
    if(self.sampleData.last <= 0){
        self.answerBtn.backgroundColor = LWColor(163, 163, 163);
        self.answerBtn.layer.cornerRadius = 6;
        self.answerBtn.layer.borderColor = LWColor(163, 163, 163).CGColor;
        self.answerBtn.layer.borderWidth = 0.5;
        [self.answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.answerBtn.userInteractionEnabled = NO;
        //        NSString *ml = [self xiaoshudianweishudeal:self.flay];
        [self.answerBtn setTitle:[NSString stringWithFormat:@"已抢完"] forState:UIControlStateNormal];
        self.answerBtn.backgroundColor = [UIColor grayColor];
    }else if (self.ishaveget) {//已答完
        self.answerBtn.backgroundColor = LWColor(163, 163, 163);
        self.answerBtn.layer.cornerRadius = 6;
        self.answerBtn.layer.borderColor = LWColor(163, 163, 163).CGColor;
        self.answerBtn.layer.borderWidth = 0.5;
        [self.answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.answerBtn.userInteractionEnabled = NO;
        //        NSString *ml = [self xiaoshudianweishudeal:self.flay];
        [self.answerBtn setTitle:[NSString stringWithFormat:@"已答完"] forState:UIControlStateNormal];
        self.answerBtn.backgroundColor = [UIColor grayColor];
        
    }else{//未答
        
        self.answerBtn.backgroundColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000];
        self.answerBtn.layer.cornerRadius = 6;
        self.answerBtn.layer.borderColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000].CGColor;
        self.answerBtn.layer.borderWidth = 0.5;
        [self.answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //判读登入状态下是否已读过题
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //1、保存个人信息
        NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
        userData * userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        BOOL aa = [HAMineLoveCarDBOperator exqueryFMDBWithCondition:userInfo.name withTaskId:self.taskId];
        if (!aa) {
            [HAMineLoveCarDBOperator insertIntoFMDBWithSql:userInfo.name withTaskId:self.taskId];
            [self settime];
        }
        
        
        //设置按钮标题
        NSString *ml = [NSString xiaoshudianweishudeal:self.sampleData.maxBonus];
        
        if (self.sampleData.type == 1) {//答题类
             self.title = @"答题类";
            [self.answerBtn setTitle:[NSString stringWithFormat:@"答题领取%@M流量",ml] forState:UIControlStateNormal];
        }
        
        if (self.sampleData.type == 2) {//报名类
             self.title = @"报名类";
            [self.answerBtn setTitle:[NSString stringWithFormat:@"报名领取%@M流量",ml] forState:UIControlStateNormal];
        }
        
        if (self.sampleData.type == 3) {//画册类
             self.title = @"画册类";
            [self.answerBtn setTitle:[NSString stringWithFormat:@"答题领取%@M流量",ml] forState:UIControlStateNormal];
        }
        
        if (self.sampleData.type  == 4) {//游戏类
             self.title = @"游戏类";
            [self.answerBtn setTitle:[NSString stringWithFormat:@"玩游戏领取%@M流量",ml] forState:UIControlStateNormal];
        }
    }
    
    NSURL* url =  [NSURL URLWithString:self.sampleData.contextURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    self.detailWebView.backgroundColor = [UIColor whiteColor];
    self.detailWebView.scrollView.backgroundColor = [UIColor whiteColor];
    [self.detailWebView loadRequest:request];
}

/**
 *  获取题目s
 */
- (void)getQuestion{
    
    NSString * url = [MainURL stringByAppendingPathComponent:@"taskDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"taskId"] = @(self.taskId);
    
    __weak detailViewController * wself = self;
    [UserLoginTool loginRequestGet:url parame:params success:^(id json) {
        [MBProgressHUD hideHUD];
//        NSLog(@"xxxxx%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [aaa show];
            return ;
           
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * detailTaskS = [taskDetail objectArrayWithKeyValuesArray:json[@"resultData"][@"taskDetail"]];
            wself.sampleData = [taskData objectWithKeyValues:json[@"resultData"][@"task"]];
            [wself.detailTasks removeAllObjects];
            [wself.detailTasks addObjectsFromArray:detailTaskS];
            
            [wself setupview];
            // 初始化
            [wself setup];
         }
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
    
    if (buttonIndex == 0) {
        
        LoginViewController * aa = [[LoginViewController alloc] init];
        UINavigationController * bb = [[UINavigationController alloc] initWithRootViewController:aa];
        [self presentViewController:bb animated:YES completion:^{
            
        }];
    }else{
        
    }
}


/**
 *  设置titleLabel
 *
 */

- (void)changeTitle:(NSString *)str
{
    self.title = str;
}


/**
 *   初始化导航栏
 */
- (void)setup{
    
       //导航栏右侧分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"分享"
                                                                                 style:UIBarButtonItemStylePlain    handler:^(id sender) {
                                                                         
    NSString * login = [[NSUserDefaults standardUserDefaults] stringForKey:loginFlag];
    if ([login isEqualToString:@"wrong"]) {
        [MBProgressHUD showError:@"未登录"];
        LoginViewController * aa= [[LoginViewController alloc] init];
        aa.delegate = self;
        UINavigationController * bb = [[UINavigationController alloc] initWithRootViewController:aa];
        [self presentViewController:bb animated:YES completion:nil];
        return;
        
    }else{
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:self.sampleData.shareURL defaultContent:@"分享得链接得粉猫流量" image:[ShareSDK imageWithUrl:self.sampleData.pictureURL] title:self.sampleData.title url:self.sampleData.shareURL description:nil mediaType:SSPublishContentMediaTypeNews];
     //创建弹出菜单容器
     id<ISSContainer> container = [ShareSDK container];
                                                                                   
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
     if (state == SSResponseStateSuccess)
     {
         [MBProgressHUD showSuccess:@"分享成功"];
         NSString *urlStr = [MainURL stringByAppendingPathComponent:@"taskTurnedNotify"];
         NSMutableDictionary * params = [NSMutableDictionary dictionary];
         params[@"taskId"] = @(self.taskId);
         int sType = 0;
         if (type == 1) {
             sType = 2;  //新浪微博
         }else if(type == 6){
             sType = 3;  //qq 空间
         }else if(type == 23){
             sType = 1;  //qq 空间
         }
         params[@"channel"] = @(sType);
         [UserLoginTool loginRequestGet:urlStr parame:params success:^(id json) {
             if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
                 [MBProgressHUD showError:@"账号被登入"];
                 return ;
             }
             if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {
                 
                 if ([json[@"resultData"][@"illgel"] intValue]!=0 ||[json[@"resultData"][@"reward"] floatValue] <= 0.0) {
                     [MBProgressHUD  showSuccess:@"分享成功"];
                 }else if([json[@"resultData"][@"reward"] floatValue]> 0){
                     
                     CGFloat rewad = [json[@"resultData"][@"reward"] floatValue];
//                     NSLog(@"%@",[NSString xiaoshudianweishudeal:rewad]);
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
         [MBProgressHUD showError:@"分享失败"];

     }
     }];
    }
     }];
                                                                               
}



- (IBAction)goQusetionAction:(id)sender {
    
    //判断是否需要登入
    NSString * flag = [[NSUserDefaults standardUserDefaults] stringForKey:loginFlag];
    if ([flag isEqualToString:@"wrong"]) {//如果没有登入要登入
        
        LoginViewController * loginVc = [[LoginViewController alloc] init];
        loginVc.delegate = self;
        UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:na animated:YES completion:nil];
        return;
    }
    
    if (!self.detailTasks.count) {
        [MBProgressHUD showError:@"后台返回数据异常"];
        return;
    }
    //答题类型
    if (self.sampleData.type== 1) {//答题类
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AnswerController *answer = [storyboard instantiateViewControllerWithIdentifier:@"AnswerController"];
        answer.questions = self.detailTasks;
        answer.type = @(1);
        answer.taskId = self.taskId;
        answer.flay = self.sampleData.maxBonus;
        [self.navigationController pushViewController:answer animated:YES];
    }
    
    if (self.sampleData.type == 2) {//报名类
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JoinController *answer = [storyboard instantiateViewControllerWithIdentifier:@"JoinController"];
        answer.questions = self.detailTasks;
        answer.title = @"报名";
        answer.type = @(2);//报名
        answer.taskId = self.taskId;
        answer.flay = self.sampleData.maxBonus;
        [self.navigationController pushViewController:answer animated:YES];
    }
    
    if (self.sampleData.type == 3) {//画册类
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AnswerController *answer = [storyboard instantiateViewControllerWithIdentifier:@"AnswerController"];
        answer.questions = self.detailTasks;
        answer.type = @(3);
        answer.taskId = self.taskId;
        [self.navigationController pushViewController:answer animated:YES];
    }
    
    if (self.sampleData.type  == 4) {//游戏类
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WebController *answer = [storyboard instantiateViewControllerWithIdentifier:@"WebController"];
        answer.type = 4;
        answer.taskId = self.taskId;
        taskDetail * tas = self.detailTasks[0];
        answer.relexUrl = tas.relexUrl;
        [self.navigationController pushViewController:answer animated:YES];
    }
    
  
}


/**
 * 设置验证码的倒计时
 */
- (void)settime{
    
    __weak detailViewController * wself = self;
    
    /*************倒计时************/
    __block int timeout = 0;
    __block int timeAll = 0;
    if ([self.sampleData.timeToStart intValue] > 0) {
        timeout = [self.sampleData.timeToStart intValue]-1;
        timeAll = [self.sampleData.timeToStart intValue];
    }else{
        timeout = self.sampleData.backTime-1;
        timeAll = self.sampleData.backTime;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设
                 wself.answerBtn.layer.borderColor = [UIColor colorWithRed:1 green:141 blue:255 alpha:1].CGColor;
                self.answerBtn.backgroundColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000];
                if (self.sampleData.type == 1) {//答题类
                    NSString * butTitle = [NSString stringWithFormat:@"答题领取%@M流量",[NSString xiaoshudianweishudeal:self.sampleData.maxBonus]];
                    [wself.answerBtn setTitle:butTitle forState:UIControlStateNormal];
                    wself.answerBtn.userInteractionEnabled = YES;
                }
                
                if (self.sampleData.type == 2) {//报名类
                    
                    NSString * butTitle = [NSString stringWithFormat:@"报名领取%@M流量",[NSString xiaoshudianweishudeal:self.sampleData.maxBonus]];
                    [wself.answerBtn setTitle:butTitle forState:UIControlStateNormal];
                    //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                    //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                    wself.answerBtn.userInteractionEnabled = YES;
                }
                
                if (self.sampleData.type == 3) {//画册类
                    
                    NSString * butTitle = [NSString stringWithFormat:@"答题领取%@M流量",[NSString xiaoshudianweishudeal:self.sampleData.maxBonus]];
                    [wself.answerBtn setTitle:butTitle forState:UIControlStateNormal];
                    //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                    //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                    wself.answerBtn.userInteractionEnabled = YES;
                }
                
                if (self.sampleData.type  == 4) {//游戏类
                    
                    NSString * butTitle = [NSString stringWithFormat:@"玩游戏领取%@M流量",[NSString xiaoshudianweishudeal:self.sampleData.maxBonus]];
                    [wself.answerBtn setTitle:butTitle forState:UIControlStateNormal];
                    //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                    //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                    wself.answerBtn.userInteractionEnabled = YES;
                }
                
                

            });
        }else{
            int seconds = timeout % timeAll;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
                
                if (self.sampleData.type == 1) {//答题类
                    [wself.answerBtn setTitle:[NSString stringWithFormat:@"答题领取%@M流量(%@)",[NSString xiaoshudianweishudeal:self.sampleData.maxBonus],strTime] forState:UIControlStateNormal];
                    wself.answerBtn.userInteractionEnabled = NO;
                }
                
                if (self.sampleData.type == 2) {//报名类
                    [wself.answerBtn setTitle:[NSString stringWithFormat:@"答题领取%@M流量(%@)",[NSString xiaoshudianweishudeal:self.sampleData.maxBonus],strTime] forState:UIControlStateNormal];
                    wself.answerBtn.userInteractionEnabled = NO;
                }
                
                if (self.sampleData.type == 3) {//画册类
                    [wself.answerBtn setTitle:[NSString stringWithFormat:@"答题领取%@M流量(%@)",[NSString xiaoshudianweishudeal:self.sampleData.maxBonus],strTime] forState:UIControlStateNormal];
                    wself.answerBtn.userInteractionEnabled = NO;
                }
                
                if (self.sampleData.type  == 4) {//游戏类
                    [wself.answerBtn setTitle:[NSString stringWithFormat:@"答题领取%@M流量(%@)",[NSString xiaoshudianweishudeal:self.sampleData.maxBonus],strTime] forState:UIControlStateNormal];
                    wself.answerBtn.userInteractionEnabled = NO;
                }

                [wself.answerBtn setBackgroundColor:[UIColor grayColor]];
                wself.answerBtn.layer.borderColor = [UIColor grayColor].CGColor;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)LoginViewDelegate:(int)PushType{


    [self getQuestion];
    
}



- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(detailViewBackToHome:)]) {
        
        [self.delegate detailViewBackToHome:self.taskId];
    }
    
}
@end
