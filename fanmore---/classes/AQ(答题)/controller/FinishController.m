//
//  FinishController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/1.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "FinishController.h"


@interface FinishController()

@end

@implementation FinishController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.host isEqualToString:@"closepage"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if ([request.URL.host isEqualToString:@"10M"]) {
        [MBProgressHUD showSuccess:@"+10M"];
    }
    return YES;
}


@end
