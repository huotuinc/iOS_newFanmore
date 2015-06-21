//
//  detailViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "detailViewController.h"
#import "AnswerController.h"
#import "LoginViewController.h"
#import "UserLoginTool.h"
#import "taskDetail.h"

@interface detailViewController ()


/**详情页面的网页*/
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;


@property (weak, nonatomic) IBOutlet UIButton *answerBtn;

/**几道答题*/
@property(nonatomic,strong) NSMutableArray * detailTasks;

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
    // 初始化
    [self setup];
    
//    NSLog(@"")
    [self getQuestion];
    
    [self settime];
    
#warning 测试
//    NSURL *url = [NSURL URLWithString:@"www.qidian.com"];
    NSURL* url =  [NSURL URLWithString:self.detailUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    //CGFloat xxxx = (ScreenHeight - CGRectGetMinY(self.answerBtn.frame)) * 0.7+20;
    self.detailWebView.backgroundColor = [UIColor redColor];
    self.detailWebView.scrollView.backgroundColor = [UIColor whiteColor];
    //self.detailWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, xxxx, 0);
    
//    UIWindow * win = [UIApplication sharedApplication].windows;
//    win.backgroundColor = [UIColor whiteColor];
    [self.detailWebView loadRequest:request];
}


- (void)getQuestion{
    
    NSString * url = [MainURL stringByAppendingPathComponent:@"taskDetail"];
    NSLog(@"%@",url);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"taskId"] = @(self.taskId);
    [UserLoginTool loginRequestGet:url parame:params success:^(id json) {
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSLog(@"xxxxxxxxxxxxx----%@",json);
            NSArray * detailTaskS = [taskDetail objectArrayWithKeyValuesArray:json[@"resultData"][@"taskDetail"]];
            [self.detailTasks addObjectsFromArray:detailTaskS];
         }
     } failure:^(NSError *error) {
        
        NSLog(@"xxxx%@",[error description]);
    }];
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
//    [self settime];
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
 *   初始化
 */
- (void)setup{
    
    
    
    
    //导航栏右侧分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"分享"
                                                                                 style:UIBarButtonItemStylePlain    handler:^(id sender) {
                                                                         
                                                                                     
                                                                                     NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
                                                                                     
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容" defaultContent:@"测试一下" image:[ShareSDK imageWithPath:imagePath] title:@"ShareSDK" url:@"http://www.mob.com" description:@"这是一条测试信息" mediaType:SSPublishContentMediaTypeNews];
     //创建弹出菜单容器
     id<ISSContainer> container = [ShareSDK container];
                                                                                   
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                                                 
     if (state == SSResponseStateSuccess)
     {
         NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
     }else if (state == SSResponseStateFail){
         NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
     }
     }];
         NSLog(@"分享");
     }];
}

/**
 *  关闭手势
 */
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //    myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
}


- (IBAction)goQusetionAction:(id)sender {
    
    NSLog(@"xxxxxxx开始答题");
    
    
    //判断是否需要登入
    NSString * flag = [[NSUserDefaults standardUserDefaults] stringForKey:loginFlag];
    if ([flag isEqualToString:@"wrong"]) {//如果没有登入要登入
        
        LoginViewController * loginVc = [[LoginViewController alloc] init];
        UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:na animated:YES completion:nil];
        return;
    }
    //答题类型
    if ([self.type intValue] == 1) {//答题类
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AnswerController *answer = [storyboard instantiateViewControllerWithIdentifier:@"AnswerController"];
        answer.questions = self.detailTasks;
        answer.type = @(1);
        answer.taskId = self.taskId;
        [self.navigationController pushViewController:answer animated:YES];
    }
    
    if ([self.type intValue] == 2) {//报名类
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AnswerController *answer = [storyboard instantiateViewControllerWithIdentifier:@"JoinController"];
        [self.navigationController pushViewController:answer animated:YES];
    }
    
    if ([self.type intValue] == 3) {//画册类
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AnswerController *answer = [storyboard instantiateViewControllerWithIdentifier:@"AnswerController"];
        answer.questions = self.detailTasks;
        answer.type = @(3);
        answer.taskId = self.taskId;
        [self.navigationController pushViewController:answer animated:YES];
    }
    
    if ([self.type intValue] == 4) {//游戏类
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AnswerController *answer = [storyboard instantiateViewControllerWithIdentifier:@"AnswerController"];
        [self.navigationController pushViewController:answer animated:YES];
    }
    
  
}


/**
 * 设置验证码的倒计时
 */
- (void)settime{
    
    __weak detailViewController * wself = self;
    
    /*************倒计时************/
   
    __block int timeout= [[[NSUserDefaults standardUserDefaults] stringForKey:AppReadSeconds] intValue]-1; //倒计时时间
    NSLog(@"xxxxxxxxxxxx%d",timeout);
    __block int timeAll= [[[NSUserDefaults standardUserDefaults] stringForKey:AppReadSeconds] intValue]; //倒计时时间
    timeout = self.backTime-1;
    timeAll = self.backTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                NSString * time = [[NSUserDefaults standardUserDefaults] stringForKey:AppReadSeconds];
                NSString * butTitle = [NSString stringWithFormat:@"答题留取%dM流量",self.flay];
                [wself.answerBtn setTitle:butTitle forState:UIControlStateNormal];
                //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                wself.answerBtn.userInteractionEnabled = YES;
//                [wself goQusetionAction:nil];
            });
        }else{
//            int minutes = timeout / timeAll;
//            NSString * time = [[NSUserDefaults standardUserDefaults] stringForKey:AppReadSeconds];
            int seconds = timeout % timeAll;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [wself.answerBtn setTitle:[NSString stringWithFormat:@"答题留取%dM流量(%@)",self.flay,strTime] forState:UIControlStateNormal];
                wself.answerBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
