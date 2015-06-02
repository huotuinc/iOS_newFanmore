
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


@interface InviteCodeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation InviteCodeViewController





#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *imageArray = [[NSArray alloc] initWithObjects:@"disciple",@"search",@"person", nil];
    NSArray *centerArray = [[NSArray alloc] initWithObjects:@"徒弟总贡献",@"昨日总贡献",@"徒弟总人数", nil];
    InviteCodeCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"InviteCodeCell" owner:nil options:nil] lastObject];
    cell.headView.image = [UIImage imageNamed:imageArray[indexPath.row]];
    cell.headView.contentMode = UIViewContentModeScaleAspectFit;
    cell.centerLabel.text = centerArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.rightLabel.text = @"100M";
    }
    if (indexPath.row == 1) {
        cell.rightLabel.text = @"50M";
    }
    if (indexPath.row == 2) {
        cell.rightLabel.text = @"60人";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 2) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DiscipleViewController *disciple = [storyboard instantiateViewControllerWithIdentifier:@"DiscipleViewController"];
        [self.navigationController pushViewController:disciple animated:YES];
    }
}



#pragma initView

- (void)_initTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[UIView alloc] init];
    self.tableView.scrollEnabled = NO;
}

- (void)_initNav
{
    [self initBackAndTitle:@"我的邀请码"];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
    rightBarButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"分享" style:UIBarButtonItemStylePlain handler:^(id sender) {
    
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNav];
    
    [self _initTableView];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)rightBarButtonAction:(UIButton *)sender
{
#warning 分享
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"" bundle:<#(NSBundle *)#>]
    
    
}

- (IBAction)copyAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.myInviteLabel.text;
    [MBProgressHUD showSuccess:@"复制成功"];
    
}
@end
