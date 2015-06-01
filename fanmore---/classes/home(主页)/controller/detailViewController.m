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

}

/**
 *  设置titleLabel
 */

- (void)changeTitle:(NSString *)str
{
    self.title = str;
}


/**
 *   初始化
 */
- (void)setup{
    
    [self changeTitle:@"详情页面"];
    

    //导航栏右侧分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"分享"
                                                                                style:UIBarButtonItemStylePlain
                                                                              handler:^(id sender) {
                                                                                  NSLog(@"分享");
                                                                              }];
    
    
    
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
