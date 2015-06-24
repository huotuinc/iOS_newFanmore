
//  InviteCodeViewController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIViewController+MMDrawerController.h>
#import "InviteCodeViewController.h"
#import "InviteCodeCell.h"
#import "RootViewController.h"
#import "DiscipleViewController.h"


@interface InviteCodeViewController ()

@end

@implementation InviteCodeViewController



- (void)_initNav
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"徒弟列表" style:UIBarButtonItemStylePlain handler:^(id sender) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DiscipleViewController *dis = [storyboard instantiateViewControllerWithIdentifier:@"DiscipleViewController"];
        [self.navigationController pushViewController:dis animated:YES];
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNav];
    
//    http://192.168.0.14:8080/fanmoreweb/shituInfo?appKey=b73ca64567fb49ee963477263283a1bf&cityCode=1372&operation=FM2015AP&timestamp=1435066431429&imei=54604120-5BF8-4A37-96F1-1C6BA6AA881A&version=3.0.0&lat=37.785834&token=353a64340c2a4a1a864396a0c2eccd82&sign=6333bb24a4dc5e10cbf92f3f310d2902&lng=116.406417&cpaCode=default
    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.14:8080/fanmoreweb/shituInfo"];
    [UserLoginTool loginRequestGet:urlStr parame:nil success:^(id json) {
       
        NSLog(@"000000%@",json);
    } failure:^(NSError *error) {
        
        NSLog(@"请求出错");
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}







- (void)rightBarButtonAction:(UIButton *)sender
{
#warning 分享
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"" bundle:<#(NSBundle *)#>]
    
    
}


- (IBAction)shareAction:(UIButton *)sender {
}
@end
