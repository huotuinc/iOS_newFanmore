//
//  MenuViewController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "MenuViewController.h"
#import "asignViewController.h"
#import "RootViewController.h"
#import "InviteCodeViewController.h"
#import "settingViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "AccountSettingViewController.h"
#import "TodayForesController.h"
#import "TrafficShowController.h"


@interface MenuViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *flowLable;
@property (weak, nonatomic) IBOutlet UITableView *optionList;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImahe;

/**文字列表*/
@property(nonatomic,strong) NSArray * lists;
/**图片列表*/
@property(nonatomic,strong) NSArray * images;
@end

@implementation MenuViewController

- (NSArray *)lists
{
    if (_lists == nil) {
        
        _lists = [NSArray array];
        _lists = @[@"首页",@"账号设置",@"今日预告",@"师徒联盟",@"更多设置",@"签到中心"];
    }
    return _lists;
}

- (NSArray *)images
{
    if (_images == nil) {
        
        _images = [NSArray array];
        _images = @[@"home",@"account",@"tonday",@"teacher",@"more",@"signIn"];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.optionList.delegate = self;
    self.optionList.backgroundColor = [UIColor whiteColor];
    self.optionList.dataSource = self;
    self.optionList.scrollEnabled = NO;
    self.optionList.tableFooterView = [[UIView alloc] init];
    self.optionList.tableHeaderView = [[UIView alloc] init];
    
    self.flowLable.userInteractionEnabled = YES;
    [self.flowLable bk_whenTapped:^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TrafficShowController *traffic = [storyboard instantiateViewControllerWithIdentifier:@"TrafficShowController"];
        [self.navigationController pushViewController:traffic animated:YES];
    }];
    
     self.nameLable.userInteractionEnabled = YES;
    [self.nameLable bk_whenTapped:^{

        LoginViewController * login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏导航条
    
    self.title = @"菜单";
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

}

#pragma TableViewDelegate dateSource



-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.lists.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"fanmore";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = LWColor(18, 17, 125);
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.imageView.frame = CGRectMake(5, 5, 5, 5);
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    //图片名称
    NSString * name = self.images[indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, ScreenHeight * 0.075 - 12, ScreenHeight * 0.075 - 12)];
    imageView.image = [UIImage imageNamed:name];
    [cell addSubview:imageView];
    
    
    //文字
    
    NSString * title = self.lists[indexPath.row];
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(5 + ScreenHeight * 0.08 - 12 + 10, ScreenHeight * 0.075  / 2 - 15, 150, 30)];
    Label.text = title;
    Label.textColor = LWColor(12, 127, 254);
    Label.font = [UIFont systemFontOfSize:18];
    [cell addSubview:Label];
    
//    cell.textLabel.text = title;

    
    return cell;
}
#pragma TableViewDelegate delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (indexPath.row == 0) {
//        RootViewController * root = (RootViewController *)self.mm_drawerController;
//        [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    }
    switch (indexPath.row) {
        case 0:{
            RootViewController * root = (RootViewController *)self.mm_drawerController;
            [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 1:{
            AccountSettingViewController* Account = [[AccountSettingViewController alloc] init];
            [self.navigationController pushViewController:Account animated:YES];
            break;
        }
        case 2:{
            TodayForesController *today = [storyboard instantiateViewControllerWithIdentifier:@"TodayForesController"];
            [self.navigationController pushViewController:today animated:YES];
            break;
        }
        case 3:{
            InviteCodeViewController *invite = [storyboard instantiateViewControllerWithIdentifier:@"InviteCodeViewController"];
            [self.navigationController pushViewController:invite animated:YES];
            break;
        }
        case 4:{
            settingViewController * setVc = [[settingViewController alloc] init];
            [self.navigationController pushViewController:setVc animated:YES];
            break;
        }
        case 5:{
            
            asignViewController * asignVc = [storyboard instantiateViewControllerWithIdentifier:@"sign"];
            [self.navigationController pushViewController:asignVc animated:YES];
            break;
        }
            
        default:
            break;
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ScreenHeight * 0.075;
}




- (IBAction)backAction:(UIButton *)sender {
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
@end
