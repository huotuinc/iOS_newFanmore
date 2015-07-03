//
//  DiscipleViewController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/29.
//  Copyright (c) 2015年 HT. All rights reserved.
//  徒弟列表

#import "DiscipleViewController.h"
#import "DiscipleCell.h"
#import "prenticeList.h"

#define pageSize 10
@interface DiscipleViewController()

/**时间  贡献度*/
@property(nonatomic,strong)UISegmentedControl * segment;

/**徒弟列表*/
@property(nonatomic,strong) NSMutableArray * prentices;

@end


@implementation DiscipleViewController

static NSString *discipleCellidentify = @"DiscipleCellid";


/**
 *  消息列表
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)prentices{
    if (_prentices == nil) {
        
        _prentices = [NSMutableArray array];
    }
    return _prentices;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscipleCell" bundle:nil] forCellReuseIdentifier:discipleCellidentify];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:nil];
    [segment insertSegmentWithTitle:@"时间" atIndex:0 animated:NO];
    [segment insertSegmentWithTitle:@"贡献度" atIndex:1 animated:NO];
    self.navigationItem.titleView = segment;
    self.segment = segment;
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(chanege:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView removeSpaces];
    /**集成刷新控件*/
    [self setupRefresh];
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

#pragma mark 开始进入刷新状态
//头部刷新
- (void)headerRereshing  //加载最新数据
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    params[@"pagingSize"] = @(pageSize);
    params[@"pagingTag"] = @"";
    params[@"orderBy"] = @(self.segment.selectedSegmentIndex);
    [MBProgressHUD showMessage:nil];
    [self getNewMoreData:params];
    // 2.(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView headerEndRefreshing];
}


//尾部刷新
- (void)footerRereshing{  //加载更多数据数据
    
    prenticeList * prentice = [self.prentices lastObject];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"pagingTag"] = [NSString stringWithFormat:@"%lld",prentice.appOrder];
    //    NSLog(@"尾部刷新%ld",task.taskOrder);
    params[@"pagingSize"] = @(pageSize);
    params[@"orderBy"] = @(self.segment.selectedSegmentIndex);
    [MBProgressHUD showMessage:nil];
    [self getMoreData:params];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView footerEndRefreshing];
}


/**
 *  下拉加载更新数据
 */
-(void)getNewMoreData:(NSMutableDictionary *)params{
    
    __weak DiscipleViewController * wself = self;
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"appsList"];
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [aaa show];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            NSArray * plist =  [prenticeList objectArrayWithKeyValuesArray:json[@"resultData"][@"apps"]];
            
            wself.prentices  = [NSMutableArray arrayWithArray:plist];
            [wself.tableView reloadData];
        }
        [MBProgressHUD hideHUD];
    
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUD];
    }];
    
}


/**
 *   上拉加载更多
 *
 *
 */
- (void)getMoreData:(NSMutableDictionary *) params{
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"appsList"];
    
    __weak DiscipleViewController *wself = self;
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        
        NSLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            aaa.tag = 1;
            [aaa show];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * taskArray = [prenticeList objectArrayWithKeyValuesArray:json[@"resultData"][@"apps"]];
            if (taskArray.count > 0) {
                [wself.prentices addObjectsFromArray:taskArray];
                [wself.tableView reloadData];    //刷新数据
            }
            
        }
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        //        NSLog(@"%@",[error description]);
    }];
    
}


/**
 *  账号被顶掉
 *
 *  @param alertView   <#alertView description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        LoginViewController * aa = [[LoginViewController alloc] init];
        UINavigationController * bb = [[UINavigationController alloc] initWithRootViewController:aa];
        [self presentViewController:bb animated:YES completion:^{
            [self.tableView headerBeginRefreshing];
            
        }];
    }else{
        
    }
}

#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.prentices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscipleCell *cell = [tableView dequeueReusableCellWithIdentifier:discipleCellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiscipleCell" owner:nil options:nil] lastObject];
    }
    
    prenticeList * aa = self.prentices[indexPath.row];
//    NSLog(@"%@",aa);
    
    [cell setHeadImage:aa.picUrl AndUserPhone:aa.showName AndeTime:aa.date AndFlow:[NSString xiaoshudianweishudeal:aa.m] AndDiscople:[NSString stringWithFormat:@"%d",aa.countOfApp]];
    
    return cell;
}


- (void)chanege:(UISegmentedControl *)sender
{
    NSMutableDictionary * params= [NSMutableDictionary dictionary];
    params[@"orderBy"] = @(self.segment.selectedSegmentIndex);
    params[@"pagingSize"] = @(pageSize);
    params[@"pagingTag"] = @"";
    //清楚远有数据
    [self.prentices removeAllObjects];
    [self getNewMoreData:params];
}



@end
