//
//  detailViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()<UIActionSheetDelegate>

/**网页webView*/
@property(nonatomic,weak)UIWebView * detailWebView;

@property(nonatomic,weak)UIButton * answerBtn;
@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    [self setup];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"protect" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.detailWebView loadRequest:request];
}

/**
 *   初始化
 */
- (void)setup{
    
    self.title = @"详情页面";
    
    //导航栏返回按钮
    UIButton *leftbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbackButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    leftbackButton.frame=CGRectMake(0, 0, 38, 50);
    [leftbackButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftbackButton];
    
    //导航栏右侧分享按钮
    UIButton *rightbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightbackButton setTitle:@"分享" forState:UIControlStateNormal];
    rightbackButton.frame=CGRectMake(0, 0, 50,50);
    [rightbackButton addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightbackButton];

    
    UIWebView * contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,ScreenWidth, ScreenHeight*0.9-64)];
    self.detailWebView = contentWebView;
    contentWebView.backgroundColor = LWColor(26, 111, 123);
    [self.view addSubview:contentWebView];
    //让网页自适应大小
    contentWebView.scalesPageToFit = YES;
    UIButton * ansBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentWebView.frame), ScreenWidth, ScreenHeight*0.1)];
    [ansBtn setBackgroundColor:LWColor(111, 111, 111)];
    [ansBtn setTitle:@"答题领取流量" forState:UIControlStateNormal];
    self.answerBtn = ansBtn;
    [ansBtn addTarget:self action:@selector(answerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ansBtn];
}


- (void)shareBtn:(UIButton *)btn{
    
    NSLog(@"分享");
}
- (void)backAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)answerBtnClick:(UIButton*)btn{
    
    UIActionSheet * optionSheet =  [[UIActionSheet alloc] initWithTitle:@"答题选项" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"单选",@"多选", nil];
    [optionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        
        NSLog(@"单选");
    }
}
@end
