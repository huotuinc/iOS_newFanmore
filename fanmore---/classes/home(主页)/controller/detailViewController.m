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

@interface detailViewController ()


/**详情页面的网页*/
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;


@property (weak, nonatomic) IBOutlet UIButton *answerBtn;

@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化
    [self setup];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"view-new" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    CGFloat xxxx = (ScreenHeight - CGRectGetMinY(self.answerBtn.frame)) * 0.7+20;
    self.detailWebView.backgroundColor = [UIColor whiteColor];
    self.detailWebView.scrollView.backgroundColor = [UIColor whiteColor];
    self.detailWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, xxxx, 0);
    [self.detailWebView loadRequest:request];
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
                                                                                     id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                                                                                                        defaultContent:@"测试一下"
                                                                                                                                 image:[ShareSDK imageWithPath:imagePath]
                                                                                                                                 title:@"ShareSDK"
                                                                                                                                   url:@"http://www.mob.com"
                                                                                                                           description:@"这是一条测试信息"
                                                                                                                             mediaType:SSPublishContentMediaTypeNews];
                                                                                     //创建弹出菜单容器
                                                                                     id<ISSContainer> container = [ShareSDK container];
//                                                                                     [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
                                                                                     
                                                                                     //弹出分享菜单
                                                                                     [ShareSDK showShareActionSheet:container
                                                                                                          shareList:nil
                                                                                                            content:publishContent
                                                                                                      statusBarTips:YES
                                                                                                        authOptions:nil
                                                                                                       shareOptions:nil
                                                                                                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                                                 
                                                                                                                 if (state == SSResponseStateSuccess)
                                                                                                                 {
                                                                                                                     NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                                                                                                 }
                                                                                                                 else if (state == SSResponseStateFail)
                                                                                                                 {
                                                                                                                     NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                                                                                                 }
                                                                                                             }];NSLog(@"分享");
                                                                    }];
    }

/**
 *  关闭手势
 */
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
}


- (IBAction)goQusetionAction:(id)sender {
    
    NSLog(@"xxxxxxx开始答题");
    
    NSString * flag = [[NSUserDefaults standardUserDefaults] stringForKey:loginFlag];
    if ([flag isEqualToString:@"wrong"]) {//如果没有登入要登入
        
        LoginViewController * loginVc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVc animated:YES];
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AnswerController *answer = [storyboard instantiateViewControllerWithIdentifier:@"AnswerController"];
    [self.navigationController pushViewController:answer animated:YES];
    
}


/**
 * 设置验证码的倒计时
 */
- (void)settime{
    
    
    __weak detailViewController * wself = self;
    
    /*************倒计时************/
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSString * time = [[NSUserDefaults standardUserDefaults] stringForKey:AppReadSeconds];
                NSString * butTitle = [NSString stringWithFormat:@"答题留取M流量(%@)",time];
                [wself.answerBtn setTitle:butTitle forState:UIControlStateNormal];
                //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                wself.answerBtn.userInteractionEnabled = YES;
                [wself goQusetionAction:nil];
            });
        }else{
            //            int minutes = timeout / 60;
            
            NSString * time = [[NSUserDefaults standardUserDefaults] stringForKey:AppReadSeconds];
            int seconds = timeout % [time intValue];
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [wself.answerBtn setTitle:[NSString stringWithFormat:@"答题留取流量(%@)",strTime] forState:UIControlStateNormal];
                wself.answerBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
