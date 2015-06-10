//
//  MassageCenterController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/29.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "MassageCenterController.h"


@interface MassageCenterController ()

/**消息存放数组*/
@property(nonatomic,strong) NSMutableArray * messages;

@end


@implementation MassageCenterController




- (NSMutableArray *)messages{
    if (_messages == nil) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //集成刷新控件
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

/**
 *  下拉加载更新数据
 */
-(void)getNewMoreData{
    
    
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"messages"];//消息列表
    [UserLoginTool loginRequestGet:usrStr parame:nil success:^(id json) {
        
        NSLog(@"-------%@",json);
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

//- (CGFloat)tabelViewCellHeightAndText:(NSString *)str  {
//    
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        static NSString *ID = @"xxxxxxx";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = @"asdasdasdasdasd";
    return cell;

}
@end
