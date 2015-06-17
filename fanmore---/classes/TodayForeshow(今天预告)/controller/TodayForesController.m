//
//  TodayForesController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/28.
//  Copyright (c) 2015年 HT. All rights reserved.
//  今日预告

#import "TodayForesController.h"
#import "ForeshowTableViewCell.h"
#import "UserLoginTool.h"
#import "taskData.h"  //任务

@interface TodayForesController ()<ForeshowTableViewCellDelegate>
/**今日预告列表*/
@property(nonatomic,strong)NSMutableArray * Notices;
@end
@implementation TodayForesController

static NSString *homeCellidentify = @"ForeshowTableViewCell.h";


- (NSMutableArray *)Notices{
    
    if (_Notices == nil) {
        _Notices = [NSMutableArray array];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"pagingTag"] = @"";
        params[@"pagingSize"] = @(8);
        [self getNewMoreData:params];
       
    }
    return _Notices;
}

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
    [self.tableView removeSpaces];
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
    if (self.Notices.count) {
        taskData * aaa = self.Notices[0];
        params[@"pagingTag"] = @(aaa.taskOrder);
    }else{
        params[@"pagingTag"] = @"";
    }
    
    params[@"pagingSize"] = @(2);
    [self getNewMoreData:params];
    
    // 2.(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView headerEndRefreshing];

   
}


/**
 *  获取更新数据
 *
 *  @param params <#params description#>
 */
-(void)getNewMoreData:(NSMutableDictionary *)params{
    
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"previewTaskList"];
    __weak TodayForesController * wself = self;
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==5000) {//访问成果
            [MBProgressHUD showError:@"没有新的预告"];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * taskArray = [taskData objectArrayWithKeyValuesArray:json[@"resultData"][@"task"]];
            NSMutableArray * taskaa = [NSMutableArray arrayWithArray:taskArray];
            [taskaa addObjectsFromArray:wself.Notices];
            wself.Notices = taskaa;
            [wself.tableView reloadData];    //刷新数据
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.Notices.count;
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
        cell.isWarning = NO;
    }
    
    taskData * task = self.Notices[indexPath.row];
    [cell setImage:task.pictureURL andNameLabel:task.title andTimeLabel:task.publishDate andFlayLabel:
    [NSString stringWithFormat:@"%@",task.maxBonus] andContentLabel:task.desc andOnlineImage:NO];
    NSLog(@"sdadsasd");
    return cell;
}

#pragma ForeshowTableViewCellDelegate

- (void)ForeshowTableViewCellSetTimeAlert:(ForeshowTableViewCell *)cell{
    
    for (id aa in cell.contentView.subviews) {
        NSLog(@"xxxxxxxxxxx");
        if ([aa isKindOfClass:[UIButton class]]) {
             NSLog(@"xxxxxxxxxxxaaa");
            if (cell.isWarning == NO) {
                UIImage * image = [UIImage imageNamed:@"bian"];
                image = [image stretchableImageWithLeftCapWidth:image.size.width* 0.5 topCapHeight:image.size.height*0.5];
                [(UIButton *)aa setBackgroundImage:image forState:UIControlStateNormal];
                [(UIButton *)aa setTitleColor:[UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
                [(UIButton *)aa setTitle:@"取消提醒" forState:UIControlStateNormal];
            }else {
                UIImage * image = [UIImage imageNamed:@"bian_b"];
                image = [image stretchableImageWithLeftCapWidth:image.size.width* 0.5 topCapHeight:image.size.height*0.5];
                [(UIButton *)aa setBackgroundImage:image forState:UIControlStateNormal];
                [(UIButton *)aa setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [(UIButton *)aa setTitle:@"设置提醒" forState:UIControlStateNormal];
            }
            
        }
    }
}

@end
