//
//  BPViewController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/5.
//  Copyright (c) 2015年 HT. All rights reserved.
//  流量详细页面

#import "BPViewController.h"
#import "Details.h"
#import "BPCell.h"



#define PageSize 10

@interface BPViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  数据列表
 */
@property (nonatomic, strong) NSMutableArray *details;

/**
 
 */
@property (nonatomic, strong) NSString *str;


@end

@implementation BPViewController

static NSString *BPCellidentify = @"BPCellId";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BPCell" bundle:nil] forCellReuseIdentifier:BPCellidentify];
    [self.tableView removeSpaces];
    //集成刷新控件
    [self setupRefresh];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
////头部刷新
- (void)headerRereshing  //加载最新数据
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"pagingTag"] = @"";
    params[@"pagingSize"] = @(PageSize);
   
    [self getNewMoreData:params];
    // 2.(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView headerEndRefreshing];
}


//尾部刷新
- (void)footerRereshing{  //加载更多数据数据
    
    Details * fladetail = [self.details lastObject];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"pagingTag"] =[NSString stringWithFormat:@"%lld",fladetail.detailOrder];
    params[@"pagingSize"] = @(PageSize);
    
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
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"details"];
    
    
    __weak BPViewController * wself = self;
    [MBProgressHUD showMessage:@""];
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:json[@"resultDescription"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [aaa show];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * taskArray = [Details objectArrayWithKeyValuesArray:json[@"resultData"][@"details"]];
            if (taskArray.count > 0) {
                [wself.details addObjectsFromArray:taskArray];
                [wself.tableView reloadData];    //刷新数据
            }
            
        }
        
    } failure:^(NSError *error) {
//        NSLog(@"%@",[error description]);
        [MBProgressHUD hideHUD];
    }];
    
}

///**
// *  下拉加载更新数据
// */
-(void)getNewMoreData:(NSMutableDictionary *)params{
    
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"details"];
    
    __weak BPViewController * wself = self;
    [MBProgressHUD showMessage:@""];
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
//        NSLog(@"%@",json);
        [MBProgressHUD hideHUD];
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:json[@"resultDescription"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [aaa show];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * taskArray = [Details objectArrayWithKeyValuesArray:json[@"resultData"][@"details"]];
            if (taskArray.count > 0) {
                [wself.details removeAllObjects];
                wself.details = [NSMutableArray arrayWithArray:taskArray];
                [wself.tableView reloadData];    //刷新数据
            }
        }
        
        
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


#pragma mark tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.details.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BPCell *cell = [tableView dequeueReusableCellWithIdentifier:BPCellidentify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BPCell" owner:nil options:nil] lastObject];
    }
    Details *detail = self.details[indexPath.row];
//    NSLog(@"%f", detail.vary);
    
    NSDate * ptime = [NSDate dateWithTimeIntervalSince1970:(detail.date/1000.0)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString * publishtime = [formatter stringFromDate:ptime];
    
    NSString *str;
    if (detail.vary > 0) {
        str = [NSString stringWithFormat:@"+%@M",[NSString xiaoshudianweishudeal:detail.vary]];
        cell.flow.textColor = [UIColor greenColor];
        
    }else {
        str = [NSString stringWithFormat:@"%@M",[NSString xiaoshudianweishudeal:detail.vary]];
        cell.flow.textColor = [UIColor redColor];
    }
    
    [cell setTitleName:detail.title AndTime:publishtime AndFlow:str];
    return cell;
}









@end
