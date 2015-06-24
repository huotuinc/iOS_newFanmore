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
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //1、保存全局信息
    NSString *fileName = [path stringByAppendingPathComponent:InitGlobalDate];
    GlobalData * glob = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];

    self.webView.backgroundColor = [UIColor whiteColor];
    if(self.type == 1){//账号设置
        
        NSURL * urlstr = [NSURL URLWithString:glob.serviceURL];
        NSURLRequest * request = [NSURLRequest requestWithURL:urlstr];
        [self.webView loadRequest:request];
        
    }else if(self.type == 2){
        
        NSURL * urlstr = [NSURL URLWithString:glob.ruleURL];
        NSURLRequest * request = [NSURLRequest requestWithURL:urlstr];
        [self.webView loadRequest:request];
        
        
    } else if(self.type == 3){ //隐条款
       
        NSURL * urlstr = [NSURL URLWithString:glob.privacyPoliciesURL];
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
    
    

}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.scheme isEqualToString:@"newfanmore"]) {
        if ([request.URL.host isEqualToString:@"finishgame"]) {
            
        }
        if ([request.URL.host isEqualToString:@"cloes"]) {
            
        }
    }
    return YES;
}

@end
