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
        NSMutableDictionary * params= [NSMutableDictionary dictionary];
        params[@"orderBy"] = @(self.segment.selectedSegmentIndex);
        params[@"pagingSize"] = @(10);
        params[@"pagingTag"] = @"";
        [self getNewMoreData:params];

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
    
    params[@"pagingSize"] = @(10);
    params[@"pagingTag"] = @"";
    params[@"orderBy"] = @(self.segment.selectedSegmentIndex);
    
    [self getNewMoreData:params];
    // 2.(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView headerEndRefreshing];
}

/**
 *  下拉加载更新数据
 */
-(void)getNewMoreData:(NSMutableDictionary *)params{
    
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"appsList"];
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [MBProgressHUD showError:@"账号被登入"];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            NSArray * plist =  [prenticeList objectArrayWithKeyValuesArray:json[@"resultData"][@"apps"]];
            
            self.prentices  = [NSMutableArray arrayWithArray:plist];
            [self.tableView reloadData];
        }
    
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
    
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
    NSLog(@"%@",aa);
    [cell setHeadImage:aa.picUrl AndUserPhone:aa.showName AndeTime:aa.date AndFlow:[NSString stringWithFormat:@"%d",aa.m] AndDiscople:[NSString stringWithFormat:@"%d",aa.countOfApp]];
    
    return cell;
}


- (void)chanege:(UISegmentedControl *)sender
{
    NSMutableDictionary * params= [NSMutableDictionary dictionary];
    params[@"orderBy"] = @(self.segment.selectedSegmentIndex);
    params[@"pagingSize"] = @(10);
    params[@"pagingTag"] = @"";
    //清楚远有数据
    [self.prentices removeAllObjects];
    [self getNewMoreData:params];
}



@end
