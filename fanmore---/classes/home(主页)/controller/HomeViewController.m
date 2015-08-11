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
#import "UIViewController+MMDrawerController.h"
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
#import <AVFoundation/AVFoundation.h>
#import "TaskGrouoModel.h"
#import "BPViewController.h"
#import "FriendMessageController.h"

#define pageSize 10

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,WebControllerDelegate,LoginViewDelegate,UIAlertViewDelegate,detailViewDelegate>
/**任s务列表*/
@property(nonatomic,strong)NSMutableArray * taskDatas;
/**当前是否登入*/
@property(nonatomic,assign) BOOL isLogin;
//失败
@property(nonatomic,assign)SystemSoundID failureSound;

/**分组模型*/
@property(nonatomic,strong) NSMutableArray *taskGroup;



/**纪录下点击的组和行树*/
@property(nonatomic,strong) NSIndexPath *myindexPath;
@end


@implementation HomeViewController

static NSString * homeCellidentify = @"homeCellId";
static int refreshCount = 0;

- (NSMutableArray *)taskGroup
{
    if (_taskDatas == nil) {
        
        _taskDatas = [NSMutableArray array];
    }
    return _taskDatas;
}


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
    }
    return _taskDatas;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (app.goDetail) {

        app.goDetail = NO;
        UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        detailViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
        detail.taskId = [app.taskId intValue];
        detail.delegate = self;
        detail.ishaveget = NO;
        [self.navigationController pushViewController:detail animated:YES];
    }
    if (app.getMessage) {
        app.getMessage = NO;

        if (![self isLogin]) {
            LoginViewController * aa = [[LoginViewController alloc] init];
            UINavigationController * bb = [[UINavigationController alloc] initWithRootViewController:aa];
            [self presentViewController:bb animated:YES completion:^{
            }];
        }else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MCController *mcc = [storyboard instantiateViewControllerWithIdentifier:@"MCController"];
            [self.navigationController pushViewController:mcc animated:YES];
        }
    }
    
    if (app.getSendMes) {
        app.getSendMes = NO;

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BPViewController *bp = [storyboard instantiateViewControllerWithIdentifier:@"BPViewController"];
        [self.navigationController pushViewController:bp animated:YES];
    }
    
    if (app.firstFriendBeg) {

        app.firstFriendBeg = NO;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FriendMessageController *friend = [storyboard instantiateViewControllerWithIdentifier:@"FriendMessageController"];
        [self.navigationController pushViewController:friend animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    [self saveControllerToAppDelegate:self];
    
    
    
}






- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"粉猫流量宝";

    [self _initNav];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homerefresh:) name:RefreshHomeDate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeBeginrefresh:) name:RefreshHomeDateLeft object:nil];
    //集成刷新控件
    [self setupRefresh];
    [self.tableView removeSpaces];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData * user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    if (user.welcomeTip.length) {
        UILabel * welable = [[UILabel alloc] init];
        welable.layer.cornerRadius = 5;
        welable.layer.masksToBounds = YES;
        welable.alpha = 0.8;
        welable.textAlignment  = NSTextAlignmentCenter;
        welable.backgroundColor = [UIColor grayColor];
        [welable setTextColor:[UIColor blackColor]];
        welable.font = [UIFont systemFontOfSize:18];
        welable.text = user.welcomeTip;
        welable.center = self.view.center;
        welable.bounds = CGRectMake(0, 0, ScreenWidth * 2 /3, 100);
        
        [self.view addSubview:welable];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [welable removeFromSuperview];
        });
    }
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:homeCellidentify];
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeViewControllerGetNot) name:@"homeViewControllerShow" object:nil];
    

}

/**
 *  接受通知方法
 *
 *  @return
 */
- (void)homeViewControllerGetNot
{
    [self saveControllerToAppDelegate:self];
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


/*
 * 通知结果通知
 */
-(void)homerefresh:(NSNotification *)note{
    
    int task  = [note.userInfo[@"hTaskId"] intValue];
    [self detailViewBackToHome:task];
}

- (void)homeBeginrefresh:(NSNotification *)note{

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
   
    TaskGrouoModel * bbbs = [self.taskGroup lastObject];
    taskData * task = [bbbs.tasks lastObject];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"pagingTag"] =[NSString stringWithFormat:@"%lld",task.taskOrder];
//    NSLog(@"尾部刷新%ld",task.taskOrder);
    params[@"pagingSize"] = @(pageSize);
    [self getMoreData:params];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView footerEndRefreshing];
}

/**
 *   上拉加载更多
 *
 *  
 */
- (void)getMoreData:(NSMutableDictionary *) params{
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"taskList"];
    
//    [MBProgressHUD showMessage:nil];
    __weak HomeViewController *wself = self;
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
//        [MBProgressHUD hideHUD];
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            aaa.tag = 1;
            [aaa show];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * taskArray = [taskData objectArrayWithKeyValuesArray:json[@"resultData"][@"task"]];
            if (taskArray.count > 0) {
                [wself toGroupsByTime:taskArray];  //分组
                [wself.tableView reloadData];    //刷新数据
            }
            
        }
        
    } failure:^(NSError *error) {
       [MBProgressHUD showError:@"粉猫服务器连接异常"];
    }];
    
}
/**
 *  下拉加载更新数据
 */
-(void)getNewMoreData:(NSMutableDictionary *)params{
    
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"taskList"];
    __weak HomeViewController *wself = self;
    if (IsIos8) {
      [MBProgressHUD showMessage:nil];
    }
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [aaa show];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56000){
            [MBProgressHUD showSuccess:json[@"resultDescription"]];
            [self.taskDatas removeAllObjects];
            
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            [MBProgressHUD hideHUD];
            NSArray * taskArray = [taskData objectArrayWithKeyValuesArray:json[@"resultData"][@"task"]];
            [wself.taskGroup removeAllObjects];
            
            [wself toGroupWithTopTask:taskArray];
            refreshCount = (int)[taskArray count];
            //            [wself showHomeRefershCount];
            if (taskArray.count > 0) {
                [self setWiteBackground];
            }else {
                [self setWiteBackground];
            }
            [MBProgressHUD hideHUD];
            [wself.tableView reloadData];    //刷新数据
        }
        
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"粉猫服务器连接异常"];
        
    }];
    
}

/**
 *  加入置顶任务
 *
 *  @param tasks <#tasks description#>
 */
- (void)toGroupWithTopTask:(NSArray *)tasks{
    
    NSMutableArray * aaa  = [NSMutableArray arrayWithArray:tasks];
    NSMutableArray *topArray = [NSMutableArray array];
    
    
    for (taskData * task in tasks) {
        if (task.top  == 1) {
            [topArray addObject:task];
            [aaa removeObject:task];
        }else{
            break;
        }
    }
    TaskGrouoModel * group = [[TaskGrouoModel alloc] init];
    group.tasks = topArray;
    [self.taskGroup addObject:group];
    [self toGroupsByTime:aaa];

}


/**
 *  把首页数据进行分组
 */
- (void)toGroupsByTime:(NSArray *)tasks{
    taskData * aaas = nil;
    TaskGrouoModel * bbbs = [self.taskGroup lastObject];
    for (taskData * task in tasks) {
       
       if ([bbbs.timeSectionTitle isEqualToString:task.turnTime]) {//一样
           aaas = task;
           [bbbs.tasks addObject:task];
       }else{//不一样
           aaas = task;
           TaskGrouoModel * group = [[TaskGrouoModel alloc] init];
           group.timeSectionTitle = task.turnTime;
           [group.tasks addObject:task];
           bbbs = group;
           [self.taskGroup addObject:group];
       }
    }
    
}

/**
 *  账号被顶掉
 *
 *  @param alertView
 *  @param buttonIndex
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        LoginViewController * aa = [[LoginViewController alloc] init];
        UINavigationController * bb = [[UINavigationController alloc] initWithRootViewController:aa];
        [self presentViewController:bb animated:YES completion:^{
            [self.tableView headerBeginRefreshing];
            
        }];
    }else{
        [self.tableView headerBeginRefreshing];
    }
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.taskGroup.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TaskGrouoModel * gmd =  self.taskGroup[section];
    return gmd.tasks.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TaskGrouoModel * aaaa = self.taskGroup[section];
    return aaaa.timeSectionTitle;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellidentify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:nil options:nil] lastObject];
    }
    
    TaskGrouoModel * gmd =  self.taskGroup[indexPath.section];
    //设置cell样式
    taskData * task =gmd.tasks[indexPath.row];
    
    NSDate * ptime = [NSDate dateWithTimeIntervalSince1970:[(task.publishDate) doubleValue]/1000.0];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString * publishtime = [formatter stringFromDate:ptime];
    
    NSString * ml = [NSString stringWithFormat:@"%.1fM",task.maxBonus];
    NSRange aa = [ml rangeOfString:@"."];
    NSString * bb = [ml substringWithRange:NSMakeRange(aa.location+1, 1)];
    if ([bb isEqualToString:@"0"]) {
        ml = [NSString stringWithFormat:@"%.fM",task.maxBonus];
    }
    int a = 0;
    if (task.reward > 0 || task.taskFailed > 0) {
        a = 1;
        [cell setImage:task.pictureURL andNameLabel:task.title andTimeLabel:publishtime andReceiveLabel:ml andJoinLabel:[NSString stringWithFormat:@"%@人",task.luckies] andIntroduceLabel:[NSString stringWithFormat:@"由【%@】提供",task.merchantTitle] andGetImage:a andTopImage:task.top];
    }else if(task.last<=0){
        a = 2;
        [cell setImage:task.pictureURL andNameLabel:task.title andTimeLabel:publishtime andReceiveLabel:ml andJoinLabel:[NSString stringWithFormat:@"%@人",task.luckies] andIntroduceLabel:[NSString stringWithFormat:@"由【%@】提供",task.merchantTitle] andGetImage:a andTopImage:task.top];
    }else {
        [cell setImage:task.pictureURL andNameLabel:task.title andTimeLabel:publishtime andReceiveLabel:ml andJoinLabel:[NSString stringWithFormat:@"%@人",task.luckies] andIntroduceLabel:[NSString stringWithFormat:@"由【%@】提供",task.merchantTitle] andGetImage:a andTopImage:task.top];
    }
    //设置cell样式
   
    
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.myindexPath = indexPath;  //纪录点击的条目
    TaskGrouoModel * gmd =  self.taskGroup[indexPath.section];
    //设置cell样式
    taskData * task =gmd.tasks[indexPath.row];
    
    //传递参数
//    taskData * task = self.taskDatas[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    detailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    detailVc.taskId = task.taskId; //获取问题编号
    detailVc.delegate = self;
    detailVc.ishaveget = (task.reward>0|task.taskFailed>0)?(YES):(NO);
    
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
                if ([self getWeek] == 7 && user.signInfo == 127) {
                    AudioServicesPlayAlertSound(self.failureSound);
                    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"签到成功 获得%@M流量", user.signtoday]];
                }else {
                    AudioServicesPlayAlertSound(self.failureSound);
                    [MBProgressHUD showSuccess:@"签到成功"];
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            
        } failure:^(NSError *error) {
//            NSLog(@"%@",[error description]);
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
    
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger week = [comps weekday] - 1;
    if (week == 0) {
        return 7;
    }
    
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
    [showBtn setTitle:[NSString stringWithFormat:@"刷新%d条数据",refreshCount] forState:UIControlStateNormal];
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
   [self.tableView headerBeginRefreshing];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (SystemSoundID)failureSound{
    
    if (_failureSound == 0) {
        
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"checkin.wav" withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_failureSound);
    }
    
    return _failureSound;
}



/*
 * 详情返回后的代理方法
 */
- (void)detailViewBackToHome:(int)taskId{
    
    NSString * url = [MainURL stringByAppendingPathComponent:@"taskDetail"];
    //    NSLog(@"%@",url);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"taskId"] = @(taskId);
    
    __weak HomeViewController * wself = self;
    [UserLoginTool loginRequestGet:url parame:params success:^(id json) {
//        NSLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [aaa show];
            return ;
            
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            
            __block taskData *task = [taskData objectWithKeyValues:json[@"resultData"][@"task"]];
            
            TaskGrouoModel * aa = self.taskGroup[self.myindexPath.section];
            aa.tasks[self.myindexPath.row] = task;
            [wself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.myindexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

            
        }
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma 设置背景图片
- (void)setClearBackground {
    if (ScreenWidth == 375) {
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg750x1334"]];
    }
    if (ScreenWidth == 414) {
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg1242x2208"]];
    }
    if (ScreenWidth == 320) {
        if (ScreenHeight <= 480) {
            self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg640x960"]];
        }else {
            self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg640x1136"]];
        }
    }
}

- (void)setWiteBackground {
    self.tableView.backgroundColor = [UIColor whiteColor];
}

@end
