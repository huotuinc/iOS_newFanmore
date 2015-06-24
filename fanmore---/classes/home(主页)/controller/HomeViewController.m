//
//  HomeViewController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HomeViewController.h"
#import "TrafficShowController.h"
#import "RootViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "HomeCell.h"
#import "detailViewController.h"
#import "BuyFlowViewController.h"
#import "taskData.h"
#import <AddressBook/AddressBook.h>
#import "userData.h"
#import "LoginViewController.h"
#import "JoinController.h"
#import "MBProgressHUD+MJ.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
/**任务列表*/
@property(nonatomic,strong)NSMutableArray * taskDatas;
/**当前是否登入*/
@property(nonatomic,assign) BOOL isLogin;
@end

@implementation HomeViewController

static NSString *homeCellidentify = @"homeCellId";

- (BOOL)isLogin{
    
    //1、判断是否要登录
    NSString * flag = [[NSUserDefaults standardUserDefaults] stringForKey:loginFlag];
    _isLogin = [flag isEqualToString:@"right"];
    return _isLogin;
}

/**
 *  网络数据数组懒加载
 *
 *  @return 一个数组
 */
- (NSMutableArray *)taskDatas{
    if (_taskDatas == nil) {
        
        _taskDatas = [NSMutableArray array];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"pagingTag"] = @"";
        params[@"pagingSize"] = @(10);
        [self getNewMoreData:params];
    }
    return _taskDatas;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)loadView
{
    [super loadView];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    [self _initView];
    
    [self _initNav];
    
    //集成刷新控件
    [self setupRefresh];
    
    [self.tableView removeSpaces];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)_initView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:homeCellidentify];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
//    [self.tableView headerBeginRefreshing];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在刷新最新数据,请稍等";

}

#pragma mark 开始进入刷新状态
//头部刷新
- (void)headerRereshing  //加载最新数据
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (self.taskDatas.count) {
        taskData * aaa = [self.taskDatas firstObject];
        params[@"pagingTag"] = @(aaa.taskOrder);
    }else{
        params[@"pagingTag"] = @"";
    }
    params[@"pagingSize"] = @(4);
    [self getNewMoreData:params];
    // 2.(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView headerEndRefreshing];
}

/**
 *  下拉加载更新数据
 */
-(void)getNewMoreData:(NSMutableDictionary *)params{
    
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"taskList"];
    
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        NSLog(@"xxxxxx手术室大大大师%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * taskArray = [taskData objectArrayWithKeyValuesArray:json[@"resultData"][@"task"]];
            NSMutableArray * taskaa = [NSMutableArray arrayWithArray:taskArray];
            [taskaa addObjectsFromArray:self.taskDatas];
            self.taskDatas = taskaa;
            [self showHomeRefershCount:taskArray.count];
            [self.tableView reloadData];    //刷新数据
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
    
}

- (void)_initNav
{
    //根视图控制器转跳
    __weak RootViewController *rootVC = (RootViewController *)self.mm_drawerController;
//    UIImage *image = [UIImage imageNamed:@"menu"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain
                                                                              handler:^(id sender) {
                                                                                  [rootVC toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
                                                                              }];
    
    
    
    if (self.tableView.hidden) {
    }else {

        
        UIBarButtonItem *signInBarButton = [[UIBarButtonItem alloc] initWithTitle:@"签到" style:UIBarButtonItemStylePlain target:self  action:@selector(signInAction:)];
        NSArray *array = [NSArray arrayWithObjects:signInBarButton, nil];
        self.navigationItem.rightBarButtonItems = array;
    }
}






#pragma mark 协议方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:nil options:nil] lastObject];
    }
    //设置cell样式
    taskData * task = self.taskDatas[indexPath.row];
    NSDate * ptime = [NSDate dateWithTimeIntervalSince1970:[(task.publishDate) doubleValue]/1000.0];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString * publishtime = [formatter stringFromDate:ptime];
    int a = 0;  //首页右下角标志
    if([task.last intValue]==0){
        a = 2;
    }else{
        a = (task.reward?0:1);
    }
    //设置cell样式
    [cell setImage:task.pictureURL andNameLabel:task.title andTimeLabel:publishtime andReceiveLabel:[NSString stringWithFormat:@"%@M",task.maxBonus] andJoinLabel:[NSString stringWithFormat:@"%@人",task.luckies] andIntroduceLabel:[NSString stringWithFormat:@"由【%@】提供",task.desc] andGetImage:a];
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //传递参数
    taskData * task = self.taskDatas[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    detailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    detailVc.taskId = task.taskId; //获取问题编号
    detailVc.type = task.type;  //答题类型
    detailVc.detailUrl = task.contextURL;//网页详情的url
    detailVc.backTime = task.backTime;
    detailVc.flay = [task.maxBonus intValue];
    detailVc.shareUrl = task.shareURL;
    task.reward>0?(detailVc.ishaveget=YES):(detailVc.ishaveget=NO);

    [self.navigationController pushViewController:detailVc animated:YES];
}
/**
 *  买流量
 */

- (void)rightBarButtonAction:(UIButton *) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BuyFlowViewController *buyFlowVc = [storyboard instantiateViewControllerWithIdentifier:@"BuyFlowViewController"];
    [self.navigationController pushViewController:buyFlowVc animated:YES];
}

/**
 *  签到
 *
 *  @param sender
 */
- (void)signInAction:(UIButton *)sender
{
    
#warning 测试
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    JoinController *join = [storyboard instantiateViewControllerWithIdentifier:@"JoinController"];
//    [self.navigationController pushViewController:join animated:YES];
    
    if (!self.isLogin) { //判断
        
        [MBProgressHUD showError:@"当前还未登录,请先登入"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LoginViewController * login = [[LoginViewController alloc] init];
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:login];
            [self presentViewController:na animated:YES completion:nil];
        });
    }else {
        
        NSString * url = [MainURL stringByAppendingPathComponent:@"signin"];
        [UserLoginTool loginRequestPost:url parame:nil success:^(id json) {
            NSLog(@"%@",json);
            if ([json[@"systemResultCode"] intValue]==1 && [json[@"resultCode"] intValue]==54006) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"今日已签到，请明天来签到"];
                return ;
            }
            if ([json[@"systemResultCode"] intValue]==1 && [json[@"resultCode"] intValue]==1) {
                [MBProgressHUD hideHUD];
                userData * user = [userData objectWithKeyValues:json[@"resultData"][@"user"]];
                NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                //1、保存个人信息
                NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
                [NSKeyedArchiver archiveRootObject:user toFile:fileName];
                [MBProgressHUD showSuccess:[NSString stringWithFormat:@"签到成功 +%@M",user.signtoday]];
            }
            [MBProgressHUD hideHUD];
        } failure:^(NSError *error) {
            NSLog(@"%@",[error description]);
            [MBProgressHUD hideHUD];
        }];
    }
}

/**
 *  获取今天是周几
 *
 *  @return  返回今天是周几
 */
- (NSInteger) getWeek{
    
    //获取日期
    NSDate *date = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger week = [comps weekday]-1;
    
    return week;
}



/**
 *  刷新数目条幅栏
 *
 */
- (void) showHomeRefershCount:(NSUInteger)count{
    
    
    UIButton * showBtn = [[UIButton alloc] init];
    [self.navigationController.view insertSubview:showBtn belowSubview:self.navigationController.navigationBar];
    showBtn.userInteractionEnabled = NO;
    showBtn.alpha = 0.9;
    showBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [showBtn setTitleColor:[UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    [showBtn setBackgroundColor:[UIColor colorWithWhite:0.878 alpha:1.000]];
    NSString * title = nil;
    if (count>0) {
        title = [NSString stringWithFormat:@"刷新了%lu条任务",(unsigned long)count];
        [showBtn setTitle:title forState:UIControlStateNormal];
        
    }else{
        [showBtn setTitle:@"没有新发布的任务" forState:UIControlStateNormal];
    }
    
    CGFloat btnX = 0;
    CGFloat btnH = 44;
    CGFloat btnY = 64 - btnH - 2;
    CGFloat btnW = self.view.frame.size.width - 2 * btnX;
    showBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    [UIView animateWithDuration:0.7 animations:^{
        
        showBtn.transform = CGAffineTransformMakeTranslation(0, btnH+2);
    } completion:^(BOOL finished) {
        
        [UIView animateKeyframesWithDuration:0.7 delay:1.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            showBtn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            [showBtn removeFromSuperview];
        }];
    }];
    
    
}
@end
