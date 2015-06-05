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
    CGFloat xxxx = (ScreenHeight - CGRectGetMinY(self.answerBtn.frame)) * 0.7+20;
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AnswerController *answer = [storyboard instantiateViewControllerWithIdentifier:@"AnswerController"];
    [self.navigationController pushViewController:answer animated:YES];
    
}
@end
