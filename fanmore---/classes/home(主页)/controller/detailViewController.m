//
//  detailViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "detailViewController.h"
#import "AnswerController.h"

@interface detailViewController ()


/**详情页面的网页*/
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;


@property (weak, nonatomic) IBOutlet UIButton *answerBtn;

@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    [self setup];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"view-new" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    CGFloat xxxx = (ScreenHeight - CGRectGetMinY(self.answerBtn.frame)) * 0.6;
    self.detailWebView.backgroundColor = [UIColor whiteColor];
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
    
    self.title = @"详情页面";
    
    
    
    //导航栏右侧分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"分享"
                                                                                 style:UIBarButtonItemStylePlain    handler:^(id sender) {
                                                                                     NSLog(@"分享");
                                                                    }];
    }

/**
 *  关闭手势
 */
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
}


- (IBAction)goQusetionAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AnswerController *answer = [storyboard instantiateViewControllerWithIdentifier:@"AnswerController"];
    [self.navigationController pushViewController:answer animated:YES];
    
}
@end
