//
//  TodayForesController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/28.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "TodayForesController.h"
#import "ForeshowTableViewCell.h"


@interface TodayForesController ()<ForeshowTableViewCellDelegate>

@end
@implementation TodayForesController

static NSString *homeCellidentify = @"ForeshowTableViewCell.h";

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
  
}

- (void)viewDidLoad
{
    [self initBackAndTitle:@"今日预告"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ForeshowTableViewCell.h" bundle:nil] forCellReuseIdentifier:homeCellidentify];
    
    self.tableView.tableHeaderView = [[UIView alloc] init];
    self.tableView.allowsSelection = NO;
    
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
    //    [self getMoreData];
    //    // 2.(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView headerEndRefreshing];
}

//尾部刷新
- (void)footerRereshing{  //加载更多数据数据
    //    startIndex = @(1 + _carMessagesF.count);
    //    // 1.添加数据
    //    [self getMoreData];
    //    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView footerEndRefreshing];
}


-(void)getMoreData{
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ForeshowTableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ForeshowTableViewCell" owner:nil options:nil] lastObject];
        cell.delegate = self;
    }
    
    return cell;
}

#pragma ForeshowTableViewCellDelegate

- (void)ForeshowTableViewCellSetTimeAlert:(ForeshowTableViewCell *)cell{
    
    for (id aa in cell.contentView.subviews) {
        NSLog(@"xxxxxxxxxxx");
        if ([aa isKindOfClass:[UIButton class]]) {
             NSLog(@"xxxxxxxxxxxaaa");
            
            UIImage * image = [UIImage imageNamed:@"button-W"];
            image = [image stretchableImageWithLeftCapWidth:image.size.width* 0.5 topCapHeight:image.size.height*0.5];
            [(UIButton *)aa setBackgroundImage:image forState:UIControlStateNormal];
            
        }
    }
}

@end
