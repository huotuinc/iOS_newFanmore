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
#import "WebController.h"

#define pageSize 6

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,WebControllerDelegate>
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
        params[@"pagingSize"] = @(pageSize);
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homerefresh) name:RefreshHomeDate object:nil];
    
    //集成刷新控件
    [self setupRefresh];
    [self.tableView removeSpaces];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData * user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    UILabel * welable = [[UILabel alloc] init];
    welable.layer.cornerRadius = 5;
    welable.layer.masksToBounds = YES;
    welable.alpha = 0.8;
    welable.textAlignment  = NSTextAlignmentCenter;
    welable.backgroundColor = [UIColor grayColor];
    [welable setTextColor:[UIColor blackColor]];
    welable.font = [UIFont systemFontOfSize:18];
    welable.text = user.welcomeTip?user.welcomeTip:@"欢迎使用粉猫";
    welable.center = self.view.center;
    welable.bounds = CGRectMake(0, 0, ScreenWidth * 2 /3, 100);
    [self.view addSubview:welable];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [welable removeFromSuperview];
    });
    
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
    [self.tableView headerBeginRefreshing];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在刷新最新数据,请稍等";
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在加载更多数据,请稍等";

}

- (void) homerefresh{
    
    [self.tableView headerBeginRefreshing];
}

#pragma mark 开始进入刷新状态
//头部刷新
- (void)headerRereshing  //加载最新数据
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"pagingTag"] = @"";
    params[@"pagingSize"] = @(pageSize);
    [self getNewMoreData:params];
    // 2.(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView headerEndRefreshing];
}

//尾部刷新
- (void)footerRereshing{  //加载更多数据数据
   
    taskData * task = [self.taskDatas firstObject];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"pagingTag"] = @(task.taskOrder);
    params[@"pagingSize"] = @(pageSize);
    [self getMoreData:params];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView footerEndRefreshing];
}



- (void)getMoreData:(NSMutableDictionary *) params{
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"taskList"];
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        
        NSLog(@"上啦加载的数据%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [MBProgressHUD showError:@"账号被登入"];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * taskArray = [taskData objectArrayWithKeyValuesArray:json[@"resultData"][@"task"]];
            [self.taskDatas addObjectsFromArray:taskArray];
            [self.tableView reloadData];    //刷新数据
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
    
}
/**
 *  下拉加载更新数据
 */
-(void)getNewMoreData:(NSMutableDictionary *)params{
    
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"taskList"];
    
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        NSLog(@"xxxxxx手术室大大大师%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [MBProgressHUD showError:@"账号被登入"];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56000){
            [MBProgressHUD showSuccess:@"没有数据"];
            [self.taskDatas removeAllObjects];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * taskArray = [taskData objectArrayWithKeyValuesArray:json[@"resultData"][@"task"]];
            [self.taskDatas removeAllObjects];
            self.taskDatas = [NSMutableArray arrayWithArray:taskArray];
            [self showHomeRefershCount];
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
//    int a = 0;  //首页右下角标志
    NSLog(@"=======%f",task.reward);
    NSLog(@"=======%d",task.taskFailed);
    NSLog(@"=======%d",[task.last intValue]);
    
    int a = 0;
    if (task.reward > 0) {
        a = 2;
    }else if(task.taskFailed > 0){
        
        a = 2;
    }else{
        a = 0;
    }
//    if([task.last intValue]==0){
//        a = 2; //已领完
//    }else{
//        
//        
//        if (task.reward > 0) {
//            a = 1;
//        }
//        if (task.taskFailed > 0) {
//            a= 1;
//        }
//    }
    //设置cell样式
    NSString * ml = [NSString stringWithFormat:@"%.1fM",task.maxBonus];
    NSRange aa = [ml rangeOfString:@"."];
    
    NSString * bb = [ml substringWithRange:NSMakeRange(aa.location+1, 1)];
    if ([bb isEqualToString:@"0"]) {
        
        ml = [NSString stringWithFormat:@"%.fM",task.maxBonus];

    }
    
    [cell setImage:task.pictureURL andNameLabel:task.title andTimeLabel:publishtime andReceiveLabel:ml andJoinLabel:[NSString stringWithFormat:@"%@人",task.luckies] andIntroduceLabel:[NSString stringWithFormat:@"由【%@】提供",task.merchantTitle] andGetImage:a];
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
    detailVc.flay = task.maxBonus;
    detailVc.shareUrl = task.shareURL;
    detailVc.titless = task.title;
    detailVc.pictureUrl = task.pictureURL;
    if (task.type == 1) {
        detailVc.title = @"答题任务";
    }else if(task.type == 2){
        detailVc.title = @"报名任务";
    }else if(task.type == 3){
        detailVc.title = @"画册类任务";
    }else{
        detailVc.title = @"游戏类任务";
    }
    (task.reward>0|task.taskFailed>0)?(detailVc.ishaveget=YES):(detailVc.ishaveget=NO);

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
- (void) showHomeRefershCount{
    
    
    UIButton * showBtn = [[UIButton alloc] init];
    [self.navigationController.view insertSubview:showBtn belowSubview:self.navigationController.navigationBar];
    showBtn.userInteractionEnabled = NO;
    showBtn.alpha = 0.9;
    showBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [showBtn setTitleColor:[UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    [showBtn setBackgroundColor:[UIColor colorWithWhite:0.878 alpha:1.000]];
    [showBtn setTitle:@"数据已刷新" forState:UIControlStateNormal];
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
- (void)answerOverToreferch{
    NSLog(@"12312313");
    [self.tableView headerBeginRefreshing];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
