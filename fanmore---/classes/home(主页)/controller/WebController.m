//
//  WebController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/17.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "WebController.h"
#import "GlobalData.h"

@interface WebController ()<UIWebViewDelegate>

@end

@implementation WebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    
    self.webView.backgroundColor = [UIColor whiteColor];
    if(self.type == 1){//账号设置
        
        
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //1、保存全局信息
        NSString *fileName = [path stringByAppendingPathComponent:InitGlobalDate];
        GlobalData * glob = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        NSLog(@"%@",glob.aboutURL);
        NSURL * urlstr = [NSURL URLWithString:glob.aboutURL];
        NSURLRequest * request = [NSURLRequest requestWithURL:urlstr];
        [self.webView loadRequest:request];
        
    }else if(self.type == 2){
        
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //1、保存全局信息
        NSString *fileName = [path stringByAppendingPathComponent:InitGlobalDate];
        GlobalData * glob = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        NSLog(@"%@",glob.serviceURL);
        NSURL * urlstr = [NSURL URLWithString:glob.serviceURL];
        NSURLRequest * request = [NSURLRequest requestWithURL:urlstr];
        [self.webView loadRequest:request];
        
        
    }else{ //答题
        
        NSString * urlStr = [NSString stringWithFormat:@"http://apitest.51flashmall.com:8080/fanmoreweb"];
        urlStr = [urlStr stringByAppendingPathComponent:@"appanswer"];
        urlStr = [urlStr stringByAppendingString:self.answerType];
        urlStr = [NSString stringWithFormat:@"%@taskReward=%d&rights=%d&wrongs=%lu&chance=%d",urlStr,self.reward,_ritghtAnswer,(_totleQuestion-_ritghtAnswer),_chance];
        NSLog(@"%@",urlStr);
        NSURL * urlstr = [NSURL URLWithString:urlStr];
        NSURLRequest * request = [NSURLRequest requestWithURL:urlstr];
        [self.webView loadRequest:request];
    }
    
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    });
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

@end
