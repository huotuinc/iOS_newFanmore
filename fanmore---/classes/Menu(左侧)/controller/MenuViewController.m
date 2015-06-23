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
#import "userData.h"
#import "SDWebImageManager.h"
#import "SendController.h"
#import "BegController.h"
#import <SDWebImageManager.h>

@interface MenuViewController ()<UITableViewDelegate,UITableViewDataSource,LoginViewDelegate>
/**
 
 */

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *flowLable;
@property (weak, nonatomic) IBOutlet UITableView *optionList;

/**用户登入头像*/
@property (weak, nonatomic) IBOutlet UIButton *userProfileBtn;

/**文字列表*/
@property(nonatomic,strong) NSArray * lists;
/**图片列表*/
@property(nonatomic,strong) NSArray * images;


/**当前是否登入*/
@property(nonatomic,assign) BOOL isLogin;
@end

@implementation MenuViewController




- (BOOL)isLogin{

    //1、判断是否要登录
    NSString * flag = [[NSUserDefaults standardUserDefaults] stringForKey:loginFlag];
    NSLog(@"========xxxxx====%@",flag);
    _isLogin = [flag isEqualToString:@"right"];
    return _isLogin;
}

- (NSArray *)lists
{
    if (_lists == nil) {
        
        _lists = [NSArray array];
        _lists = @[@"首页",@"账号设置",@"今日预告",@"师徒联盟",@"更多设置",@"签到中心",@"送流量"];
    }
    return _lists;
}

- (NSArray *)images
{
    if (_images == nil) {
        
        _images = [NSArray array];
        _images = @[@"home",@"account",@"tonday",@"teacher",@"more",@"signIn",@"send"];
    }
    return _images;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"菜单";
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.optionList.delegate = self;
    self.optionList.backgroundColor = [UIColor whiteColor];
    self.optionList.dataSource = self;
    self.optionList.scrollEnabled = NO;
    self.optionList.tableFooterView = [[UIView alloc] init];
    self.optionList.tableHeaderView = [[UIView alloc] init];
    
  

    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        //隐藏导航条
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
//    if ([[[NSUserDefaults standardUserDefaults] stringForKey:loginFlag] isEqualToString:@"right"]) {
//        self.nameLable.userInteractionEnabled = NO;
//    }else {
//        self.nameLable.userInteractionEnabled = YES;
//        [self.nameLable bk_whenTapped:^{//登入按钮
//            
//            LoginViewController * login = [[LoginViewController alloc] init];
//            [self presentViewController:login animated:YES completion:nil];
//        }];
//    }
    
    if (self.isLogin) {
        
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
        userData *  user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        
        //1、设置用户名
        self.nameLable.hidden = NO;
        self.nameLable.text = user.name;
        //2、设置用户登入头像
        SDWebImageManager * manager = [SDWebImageManager sharedManager];
        NSURL * url = [NSURL URLWithString:user.pictureURL];
        [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (error == nil) {
                [self.userProfileBtn setBackgroundImage:image forState:UIControlStateNormal];
                [self.userProfileBtn setBackgroundImage:image forState:UIControlStateHighlighted];
            }
            
        }];
        //3、设置当前用户流量
        self.flowLable.hidden = NO;
        
        self.flowLable.text = [NSString stringWithFormat:@"%.1fM",[user.balance doubleValue]];
        
        self.flowLable.userInteractionEnabled = YES;
        [self.flowLable bk_whenTapped:^{ //流量详情
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TrafficShowController *traffic = [storyboard instantiateViewControllerWithIdentifier:@"TrafficShowController"];
                    traffic.userInfo = user;
            [self.navigationController pushViewController:traffic animated:YES];
        }];
        //4.关闭头像点击事件
        self.userProfileBtn.userInteractionEnabled = NO;
        
        //5.开启下个页面的点击事件
        self.backButton.userInteractionEnabled = YES;
        self.backButton.hidden = NO;
        
        //6.剩余流量按钮
        self.warningLabel.hidden = NO;
        
        //7.登录label隐藏
        self.loginLabel.hidden = YES;
    
        
    }else{
        
        
        [self.userProfileBtn setBackgroundImage:[UIImage imageNamed:@"mrtou_h"] forState:UIControlStateNormal];
        
        self.userProfileBtn.userInteractionEnabled = YES;
        
        //隐藏label
        self.nameLable.hidden = YES;
        self.backButton.hidden = YES;
        self.backButton.userInteractionEnabled = NO;
        
        self.flowLable.hidden = YES;
        self.flowLable.userInteractionEnabled = NO;
        
        self.warningLabel.hidden = YES;
        
        //显示登录按钮
        self.loginLabel.hidden = NO;
        self.loginLabel.userInteractionEnabled = YES;
        [self.loginLabel bk_whenTapped:^{
            LoginViewController * login = [[LoginViewController alloc] init];
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:login];
            [self presentViewController:na animated:YES completion:nil];
        }];
        
    }

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

    switch (indexPath.row) {//首页
        case 0:{
            RootViewController * root = (RootViewController *)self.mm_drawerController;
            [root toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 1:{//账号设置
            
            if (self.isLogin) {
                AccountSettingViewController* Account = [[AccountSettingViewController alloc] init];
                [self.navigationController pushViewController:Account animated:YES];
            }else{
                
                LoginViewController * login = [[LoginViewController alloc] init];
                login.loginType = 1;
                login.delegate = self;
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:login];
                [self presentViewController:na animated:YES completion:nil];
            }
            break;
        }
        case 2:{//今日预告
            if (self.isLogin) {
                TodayForesController *today = [storyboard instantiateViewControllerWithIdentifier:@"TodayForesController"];
                [self.navigationController pushViewController:today animated:YES];
            }else{
                LoginViewController * login = [[LoginViewController alloc] init];
                login.loginType = 2;
                login.delegate = self;
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:login];
                [self presentViewController:na animated:YES completion:nil];
            }
            
            break;
        }
        case 3:{//师徒联盟
            if (self.isLogin) {
                InviteCodeViewController *invite = [storyboard instantiateViewControllerWithIdentifier:@"InviteCodeViewController"];
                [self.navigationController pushViewController:invite animated:YES];
            }else {
                LoginViewController * login = [[LoginViewController alloc] init];
                login.loginType = 3;
                login.delegate = self;
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:login];
                [self presentViewController:na animated:YES completion:nil];
            }
            
            break;
        }
        case 4:{//更多设置
            
//            UIStoryboard * aasb = [UIStoryboard storyboardWithName:@"FeedBack" bundle:nil];
//            FeedBackViewController * vc = aasb.instantiateInitialViewController;
            settingViewController * setVc = [[settingViewController alloc] init];
            [self.navigationController pushViewController:setVc animated:YES];
            break;
        }
        case 5:{//签到中心
            if (self.isLogin) {
                asignViewController * asignVc = [storyboard instantiateViewControllerWithIdentifier:@"sign"];
                [self.navigationController pushViewController:asignVc animated:YES];
            }else{
                LoginViewController * login = [[LoginViewController alloc] init];
                login.loginType = 2;
                login.delegate = self;
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:login];
                [self presentViewController:na animated:YES completion:nil];
            }
            
            break;
        }
        case 6:{//送流量
            if (self.isLogin) {
                SendController *beg = [storyboard instantiateViewControllerWithIdentifier:@"SendController"];
                [self.navigationController pushViewController:beg animated:YES];
            }else{
                LoginViewController * login = [[LoginViewController alloc] init];
                login.loginType = 2;
                login.delegate = self;
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:login];
                [self presentViewController:na animated:YES completion:nil];
            }
            
        }
            
        default:
            break;
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ScreenHeight * 0.08;
}




- (IBAction)backAction:(UIButton *)sender {
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData *  user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TrafficShowController *traffic = [storyboard instantiateViewControllerWithIdentifier:@"TrafficShowController"];
    traffic.userInfo = user;
    [self.navigationController pushViewController:traffic animated:YES];
}

- (IBAction)userProfileBtn:(id)sender {
    
    LoginViewController * login = [[LoginViewController alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:login];
    [self presentViewController:na animated:YES completion:nil];
}



/**
 *  登入的代理方法
 */

- (void)LoginViewDelegate:(int)PushType{
    
//    NSLog(@"dsadasdasd");
//    if (PushType == 1) {
//        
//        AccountSettingViewController* Account = [[AccountSettingViewController alloc] init];
//        [self.navigationController pushViewController:Account animated:YES];
//    }else if (PushType == 2) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        TodayForesController *today = [storyboard instantiateViewControllerWithIdentifier:@"TodayForesController"];
//        [self.navigationController pushViewController:today animated:YES];
//    }
}
@end
