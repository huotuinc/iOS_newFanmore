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
#import "WebController.h"

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

    if (self.ishaveget) {
        self.answerBtn.backgroundColor = [UIColor grayColor];
        self.answerBtn.backgroundColor = LWColor(163, 163, 163);
        self.answerBtn.layer.cornerRadius = 6;
        self.answerBtn.layer.borderColor = LWColor(163, 163, 163).CGColor;
        self.answerBtn.layer.borderWidth = 0.5;
        [self.answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.answerBtn.userInteractionEnabled = NO;
    }else{
        self.answerBtn.backgroundColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000];
        self.answerBtn.layer.cornerRadius = 6;
        self.answerBtn.layer.borderColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000].CGColor;
        self.answerBtn.layer.borderWidth = 0.5;
        [self.answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //获取题目s
        [self getQuestion];
        [self settime];
    }
    
    NSURL* url =  [NSURL URLWithString:self.detailUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    self.detailWebView.backgroundColor = [UIColor redColor];
    self.detailWebView.scrollView.backgroundColor = [UIColor whiteColor];
    [self.detailWebView loadRequest:request];
}


/**
 *  获取题目s
 */
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
             
             NSLog(@"%@",json);
         } failure:^(NSError *error) {
             
         }];
         
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
        WebController *answer = [storyboard instantiateViewControllerWithIdentifier:@"WebController"];
        answer.type = 4;
        answer.taskId = self.taskId;
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
                NSString * butTitle = [NSString stringWithFormat:@"答题领取%dM流量",self.flay];
                [wself.answerBtn setTitle:butTitle forState:UIControlStateNormal];
                //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                wself.answerBtn.userInteractionEnabled = YES;

            });
        }else{
            int seconds = timeout % timeAll;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [wself.answerBtn setTitle:[NSString stringWithFormat:@"答题领取%dM流量(%@)",self.flay,strTime] forState:UIControlStateNormal];
                wself.answerBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
