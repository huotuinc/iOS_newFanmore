//
//  WebController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/17.
//  Copyright (c) 2015年 HT. All rights reserved.
//  网页ab

#import "WebController.h"
#import "GlobalData.h"
#import "HomeViewController.h"
#import "detailViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface WebController ()<UIWebViewDelegate>


//成功
@property(nonatomic,assign)SystemSoundID successSound;

//成功
@property(nonatomic,assign)SystemSoundID failedSound;

@end

@implementation WebController




- (SystemSoundID)failedSound{
    
    if (!_failedSound) {
        NSURL *url=[[NSBundle mainBundle] URLForResource:@"failed.wav" withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_failedSound);
    }
    return _failedSound;
}

- (SystemSoundID)successSound{
    
    if (!_successSound) {
        
        NSURL *url=[[NSBundle mainBundle] URLForResource:@"success.wav" withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_successSound);
    }
    
    return _successSound;
}




- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupWebview];
    self.webView.delegate = self;
    
    
//    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target: self action:@selector(backAction:)];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //1、保存全局信息
    NSString *fileName = [path stringByAppendingPathComponent:InitGlobalDate];
    GlobalData * glob = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];

    self.webView.backgroundColor = [UIColor whiteColor];
    if(self.type == 1){//账号设置
        
        NSURL * urlstr = [NSURL URLWithString:glob.serviceURL];
        NSURLRequest * request = [NSURLRequest requestWithURL:urlstr];
        [self.webView loadRequest:request];
        
    }else if(self.type == 2){//规则说明
        
        NSURL * urlstr = [NSURL URLWithString:glob.ruleURL];
        NSURLRequest * request = [NSURLRequest requestWithURL:urlstr];
        [self.webView loadRequest:request];
        
        
    } else if(self.type == 3){ //隐条款
       
        NSURL * urlstr = [NSURL URLWithString:glob.privacyPoliciesURL];
        NSURLRequest * request = [NSURLRequest requestWithURL:urlstr];
        [self.webView loadRequest:request];
        
    } else if(self.type == 4){ //游戏类
        
        NSURL * urlstr = [NSURL URLWithString:self.relexUrl];
        NSURLRequest * request = [NSURLRequest requestWithURL:urlstr];
        [self.webView loadRequest:request];
        
    }else if(self.type == 5){
        NSURL * urlstr = [NSURL URLWithString:glob.aboutURL];
        NSURLRequest * request = [NSURLRequest requestWithURL:urlstr];
        [self.webView loadRequest:request];
    }
    else{ //答题
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        NSString * urlStr = [NSString stringWithFormat:@"http://apitest.51flashmall.com:8080/fanmoreweb"];
        urlStr = [urlStr stringByAppendingPathComponent:@"appanswer"];
        urlStr = [urlStr stringByAppendingString:self.answerType];
        if ([self.answerType isEqualToString:@"rejected.html?"] || [self.answerType isEqualToString:@"failed.html?"] ) {
            AudioServicesPlayAlertSound(self.failedSound);
        }else if([self.answerType isEqualToString:@"success.html?"]){
            AudioServicesPlayAlertSound(self.successSound);
        }
        urlStr = [NSString stringWithFormat:@"%@taskReward=%.1f&rights=%d&wrongs=%lu&chance=%d",urlStr,self.reward,_ritghtAnswer,(_totleQuestion-_ritghtAnswer),_chance];
        NSURL * urlstr = [NSURL URLWithString:urlStr];
        NSURLRequest * request = [NSURLRequest requestWithURL:urlstr];
        [self.webView loadRequest:request];
    }
}
//- (void)setupWebview{
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    backButton.frame=CGRectMake(0, 0, 11, 20);
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
//}

- (void)backAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    __weak WebController * wself = self;
    if ([request.URL.scheme isEqualToString:@"newfanmore"]) {
        if ([request.URL.host isEqualToString:@"finishgame"]) {//玩游戏结束
            NSString * urlStr = [MainURL stringByAppendingPathComponent:@"answer"];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"taskId"] = @(self.taskId);
            [UserLoginTool loginRequestGet:urlStr parame:params success:^(id json) {
//                NSLog(@"拦截服务器回调地址%@",json);
                if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshHomeDate object:nil];
                    [wself.navigationController popToRootViewControllerAnimated:YES];
                }
          
            } failure:^(NSError *error) {
//                NSLog(@"%@",[error description]);
               
            }];
        }
        if ([request.URL.host isEqualToString:@"appanswercallback"]) { //答题完成
            
//            NSLog(@"答题完成了");
            if (self.illgel>0) {
                NSDictionary * aa = @{@"hTaskId":@(wself.taskId)};
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshHomeDate object:nil userInfo:aa];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else if(self.reward>0){
                
                
                NSDictionary * aa = @{@"hTaskId":@(wself.taskId)};

                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshHomeDate object:nil userInfo:aa];
               
                
                [MBProgressHUD showSuccess:[NSString stringWithFormat:@"恭喜获得%.1fM流量",wself.flay]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                });
                
            }else if (self.chance >0 ){
                for (UIViewController * aa in self.navigationController.childViewControllers) {
                    if ([aa isKindOfClass:[detailViewController class]]) {
                        
                        [self.navigationController popToViewController:aa animated:YES];
                        break;
                    }
                }
            }else{
                NSDictionary * aa = @{@"hTaskId":@(wself.taskId)};
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshHomeDate object:nil userInfo:aa];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            
        }
        return NO;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    return YES;
}

@end
