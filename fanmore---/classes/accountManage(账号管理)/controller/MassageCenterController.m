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

#define pageSize 10

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
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
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
#pragma mark 开始进入刷新状态
//头部刷新
- (void)headerRereshing  //加载最新数据
{
    //    startIndex = @1;
    [MBProgressHUD showMessage:nil];
    [self getNewMoreData];
    //    // 2.(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView headerEndRefreshing];
}


//尾部刷新
- (void)footerRereshing{  //加载更多数据数据
    
    MessageFrame * task = [self.messageF lastObject];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    params[@"pagingTag"] = @(task.message.messageOrder);
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
    
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"messages"];
    
    __weak MassageCenterController * wself = self;
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        
//        NSLog(@"上啦加载的数据%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            aaa.tag = 1;
            [aaa show];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * taskArray = [Message objectArrayWithKeyValuesArray:json[@"resultData"][@"messages"]];
            if (taskArray.count > 0) {
                for (Message * aa in taskArray) {
//                    NSLog(@"%@  %lld",aa.context,aa.date);
                    MessageFrame *aas = [[MessageFrame alloc] init];
                    aas.message = aa;
                    [wself.messageF addObject:aas];
                    
                }
                [wself.tableView reloadData];
            }
            
        }
    } failure:^(NSError *error) {
//        NSLog(@"%@",[error description]);
    }];
    
}


/**
 *  下拉加载更新数据
 */
-(void)getNewMoreData{
    
    
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"messages"];//消息列表
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"pagingSize"] = @(pageSize);
    parame[@"pagingTag"] = @"";
    
    __weak MassageCenterController * wself = self;
    [UserLoginTool loginRequestGet:usrStr parame:parame success:^(id json) {
//        NSLog(@"%@",json);
        [MBProgressHUD hideHUD];
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            aaa.tag = 1;
            [aaa show];
            return ;
        }
        NSMutableArray * aaframe = [NSMutableArray array];
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            NSArray *messageArrays = [Message objectArrayWithKeyValuesArray:json[@"resultData"][@"messages"]];
            if (messageArrays.count) {
                
                for (Message *aa in messageArrays) {
//                    NSLog(@"%@  %lld",aa.context,aa.date);
                    MessageFrame *aas = [[MessageFrame alloc] init];
                    aas.message = aa;
                    [aaframe addObject:aas];
                }
                [wself.messageF addObjectsFromArray:aaframe];
                [wself.tableView reloadData];
            }
            
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
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

#pragma tableView

//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 50;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageF.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageTableViewCell * cell = [MessageTableViewCell cellWithTableView:tableView];
    MessageFrame * meF = self.messageF[indexPath.row];
    cell.messageF = meF;
//    cell.backgroundColor = [UIColor yellowColor];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MessageFrame * asb = self.messageF[indexPath.row];
    return asb.cellHeight+ 5;
}
@end
