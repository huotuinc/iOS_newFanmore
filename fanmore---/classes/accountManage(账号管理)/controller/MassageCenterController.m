//
//  MassageCenterController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/29.
//  Copyright (c) 2015年 HT. All rights reserved.
//  消息中心

#import "MassageCenterController.h"
#import "MessageTableViewCell.h"
#import "Message.h"
#import "MessageFrame.h"



@interface MassageCenterController ()

/**消息存放数组*/
@property(nonatomic,strong) NSMutableArray * messageF;


@end


@implementation MassageCenterController



- (NSMutableArray *)messageF{
    if (_messageF == nil) {
        _messageF = [NSMutableArray array];
    }
    return _messageF;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title =@"消息中心";
    //集成刷新控件
    [self setupRefresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView removeSpaces];
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
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"pagingSize"] = @(10);
    parame[@"pagingTag"] = @"";
    [UserLoginTool loginRequestGet:usrStr parame:parame success:^(id json) {
        NSLog(@"%@",json);
        NSMutableArray * aaframe = [NSMutableArray array];
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            NSArray *messageArrays = [Message objectArrayWithKeyValuesArray:json[@"resultData"][@"messages"]];
            for (Message *aa in messageArrays) {
                NSLog(@"%@  %lld",aa.context,aa.date);
                MessageFrame *aas = [[MessageFrame alloc] init];
                aas.message = aa;
                [aaframe addObject:aas];
            }
            [self.messageF addObjectsFromArray:aaframe];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma tableView


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageF.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageTableViewCell * cell = [MessageTableViewCell cellWithTableView:tableView];
    MessageFrame * meF = self.messageF[indexPath.row];
    cell.messageF = meF;
    cell.backgroundColor = [UIColor yellowColor];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MessageFrame * asb = self.messageF[indexPath.row];
    return asb.cellHeight+ 5;
}
@end
