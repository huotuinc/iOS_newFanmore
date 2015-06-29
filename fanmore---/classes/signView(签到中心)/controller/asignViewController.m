//
//  asignViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//  签到中心


#import "asignViewController.h"
#import "RootViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "userData.h"

@interface asignViewController ()
/**周一*/
@property (weak, nonatomic) IBOutlet UIButton *monday;
/**周二*/
@property (weak, nonatomic) IBOutlet UIButton *Tuesday;
/**周三*/
@property (weak, nonatomic) IBOutlet UIButton *Wednesday;
/**周四*/
@property (weak, nonatomic) IBOutlet UIButton *Thursday;
/**周五*/
@property (weak, nonatomic) IBOutlet UIButton *Friday;
/**周六*/
@property (weak, nonatomic) IBOutlet UIButton *Saturday;
/**周日*/
@property (weak, nonatomic) IBOutlet UIButton *SunDay;

/**安妞的试图*/
@property (weak, nonatomic) IBOutlet UIView *btnView;

/**周一到周日的按钮*/
@property(nonatomic,strong)NSArray * buttons;

/**签到的按钮*/
@property (weak, nonatomic) IBOutlet UIButton *asignBtn;

/**签到的按钮的点击*/
- (IBAction)asignBtnClick:(id)sender;

@end

@implementation asignViewController

- (NSArray *)buttons{
    if (_buttons == nil) {
        
        _buttons = [NSArray array];
        _buttons = @[self.monday,self.Tuesday,self.Wednesday,self.Thursday,self.Friday,self.Saturday,self.SunDay];
    }
    return _buttons;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏的属性
    [self initBackAndTitle:@"一周连续签到"];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //1、保存个人信息
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData * userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    
    
    if (((1<<(7-[self getWeek])) & (userInfo.signInfo)) == (1<<(7-(int)[self getWeek]))){//今日签到
        [self.asignBtn setTitle:[NSString stringWithFormat:@"今日已签到"] forState:UIControlStateNormal];
        self.asignBtn.backgroundColor = LWColor(163, 163, 163);
        self.asignBtn.layer.cornerRadius = 6;
        self.asignBtn.layer.borderColor = LWColor(163, 163, 163).CGColor;
        self.asignBtn.layer.borderWidth = 0.5;
        [self.asignBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.asignBtn.userInteractionEnabled = NO;
    }else{//未签到
        [self.asignBtn setTitle:[NSString stringWithFormat:@"今日未签到"] forState:UIControlStateNormal];
        self.asignBtn.userInteractionEnabled = YES;
        self.asignBtn.backgroundColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000];
        self.asignBtn.layer.cornerRadius = 6;
        self.asignBtn.layer.borderColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000].CGColor;
        self.asignBtn.layer.borderWidth = 0.5;
        [self.asignBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    //2、显示
    for (UIButton * btn in self.buttons) {
        if (((1<<(7-btn.tag)) & (userInfo.signInfo)) == (1<<(7-btn.tag))) {//签到
            [btn setBackgroundImage:[UIImage imageNamed:@"asignBlue"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
        }else{//未签到
            if (btn.tag < ((long)[self getWeek])) {//漏签的
                [btn setBackgroundImage:[UIImage imageNamed:@"asignRed"] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
            }else{//未签的
                [btn setBackgroundImage:[UIImage imageNamed:@"asignGray"] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
            }
        }
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    //注册通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qiandao:) name:TodaySignNot object:nil];
}


- (void)qiandao:(NSNotification *) not{
    
    NSLog(@"接受到签到通知");
    [self asignBtnClick:self.asignBtn];
}


- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  获取今天是周几
 *
 *  @return  返回今天是周几
 */
- (long) getWeek{
    //获取日期
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    long week = [comps weekday] - 1;
    if (week == 0) {
        return 7;
    }
    return week;
}

/**
 *   导航栏返回按钮
 *
 *  @param btn <#btn description#>
 */
- (void)backAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)btnclick:(UIButton *) btn{
    
    NSLog(@"xxxxxxx%ld",(long)btn.tag);
}
/**
 *  签到按钮点击
 *
 *  @param sender <#sender description#>
 */
- (IBAction)asignBtnClick:(UIButton *)sender {
    
    NSLog(@"dadadasdasdasdasdsa接受到签到通知");
    NSInteger week = [self getWeek];
    for (UIButton * btn in self.buttons) { //遍历今天是周几
        if (btn.tag == week) {
            [btn setBackgroundImage:[UIImage imageNamed:@"asignBlue"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
            break;
        }
    }
    [MBProgressHUD showMessage:nil];
    NSString * url = [MainURL stringByAppendingPathComponent:@"signin"];
    [UserLoginTool loginRequestPost:url parame:nil success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue]==1 && [json[@"resultCode"] intValue]==56001) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"账号在其它地方登入"];
            return ;
        }

        if ([json[@"systemResultCode"] intValue]==1 && [json[@"resultCode"] intValue]==54006) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"今日已签到，请明天来签到"];
            [self.asignBtn setTitle:[NSString stringWithFormat:@"今日已签到"] forState:UIControlStateNormal];
            self.asignBtn.backgroundColor = LWColor(163, 163, 163);
            self.asignBtn.layer.cornerRadius = 6;
            self.asignBtn.layer.borderColor = LWColor(163, 163, 163).CGColor;
            self.asignBtn.layer.borderWidth = 0.5;
            [self.asignBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.asignBtn.userInteractionEnabled = NO;
            return ;
        }
        if ([json[@"systemResultCode"] intValue]==1 && [json[@"resultCode"] intValue]==1) {
            [MBProgressHUD hideHUD];
            userData * user = [userData objectWithKeyValues:json[@"resultData"][@"user"]];
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            //1、保存个人信息
            NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
            [NSKeyedArchiver archiveRootObject:user toFile:fileName];
            if ([self getWeek] == 7 && user.signInfo == 127) {
                [MBProgressHUD showSuccess:[NSString stringWithFormat:@"签到成功 获得%@M流量", user.signtoday]];
            }else {
                [MBProgressHUD showSuccess:@"签到成功"];
            }
            [self.asignBtn setTitle:[NSString stringWithFormat:@"今日已签到"] forState:UIControlStateNormal];
            self.asignBtn.backgroundColor = LWColor(163, 163, 163);
            self.asignBtn.layer.cornerRadius = 6;
            self.asignBtn.layer.borderColor = LWColor(163, 163, 163).CGColor;
            self.asignBtn.layer.borderWidth = 0.5;
            [self.asignBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.asignBtn.userInteractionEnabled = NO;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
        [MBProgressHUD hideHUD];
    }];
   
}
@end
