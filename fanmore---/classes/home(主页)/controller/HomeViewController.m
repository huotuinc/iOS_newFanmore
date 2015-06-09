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

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>


/**任务列表*/
@property(nonatomic,strong)NSMutableArray * taskDatas;
@end

@implementation HomeViewController

static NSString *homeCellidentify = @"homeCellId";



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
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在刷新最新数据,请稍等";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在加载更多数据,请稍等";
}
#pragma mark 开始进入刷新状态
//头部刷新
- (void)headerRereshing  //加载最新数据
{
//    startIndex = @1;
    [self getNewMoreData];
//    // 2.(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView headerEndRefreshing];
}

//尾部刷新
- (void)footerRereshing{  //加载更多数据数据
//    startIndex = @(1 + _carMessagesF.count);
//    // 1.添加数据
    [self getMoreData];
//    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView footerEndRefreshing];
}

-(void)getNewMoreData{
    
    NSLog(@"加载最新的＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝");
    NSString * usrStr = @"http://192.168.0.25:8080/fanmore/app/taskList";//[MainURL stringByAppendingPathComponent:@"taskList"];
    [UserLoginTool loginRequestGet:usrStr parame:nil success:^(id json) {
        
        NSLog(@"xxxxxxxx任务列表%@",json);
        [taskData objectArrayWithJSONData:json[@"resultData"][@"task"]];
    } failure:^(NSError *error) {
        
    }];
}
-(void)getMoreData{
    
    NSLog(@"加载跟多的＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝");
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"taskList"];
    [UserLoginTool loginRequestGet:usrStr parame:nil success:^(NSDictionary * json) {
        
       
        
        
    } failure:^(NSError *error) {
        
    }];
    
//    [UserLoginTool loginRequestGet:<#(NSString *)#> parame:<#(NSMutableDictionary *)#> success:<#^(id json)success#> failure:<#^(NSError *error)failure#>]
//    //1、设置网络获取的参数
//    HA4SInfoRequestParame * parame = [HA4SInfoRequestParame InfoRequestParameWithpartnerCode:proCode andStartIndex:startIndex andPageSize:@(PageSize)];
//    //2、网络获取加载数据
//    [HA4SInfoTool store4SMessage:parame success:^(NSArray * responseObject) {
//        NSMutableArray * arrays = [NSMutableArray array];
//        for (HA4SRequestResult * obj in responseObject) {
//            HA4sFrame * frame = [HA4sFrame FrameWith4SRequestResult:obj];
//            [arrays addObject:frame];
//        }
//        if ([startIndex intValue] == 1) {
//            [_carMessagesF removeAllObjects];
//            [_carMessagesF setArray:arrays];
//        }else{
//            [_carMessagesF addObjectsFromArray:arrays];
//        }
//        [self.tableView reloadData];
//        
//    } failure:^(NSError * error) {
//        NSLog(@"error 4s店咨询:%@",error);
//        
//    }];
}


- (void)_initNav
{
    //根视图控制器转跳
    __weak RootViewController *rootVC = (RootViewController *)self.mm_drawerController;
    UIImage *image = [UIImage imageNamed:@"menu"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"菜单" style:UIBarButtonItemStylePlain
                                                                              handler:^(id sender) {
                                                                                  [rootVC toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
                                                                              }];
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"买流量" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
//    rightBarButton.tintColor = [UIColor blackColor];
    
    if (self.tableView.hidden) {
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }else {
        UIBarButtonItem *signInBarButton = [[UIBarButtonItem alloc] initWithTitle:@"签到" style:UIBarButtonItemStylePlain target:self  action:@selector(signInAction:)];
//        signInBarButton.tintColor = [UIColor blackColor];
        NSArray *array = [NSArray arrayWithObjects:signInBarButton, rightBarButton, nil];
        self.navigationItem.rightBarButtonItems = array;
    }
    /**
     *  设置签到和买流量
     */
}






#pragma mark 协议方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = nil;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:nil options:nil] lastObject];
    }
    if (indexPath.row == 2) {
        [cell setSelection:1];
    }else if (indexPath.row == 3) {
        [cell setSelection:2];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    detailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
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
    
}


@end
