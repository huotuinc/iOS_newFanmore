//
//  BPViewController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/5.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "BPViewController.h"
#import "Details.h"
#import "BPCell.h"


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
    
    //集成刷新控件
    [self setupRefresh];
    
    [self headerRereshing];

    
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
    //    [self.tableView headerBeginRefreshing];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在刷新最新数据,请稍等";
    
}

#pragma mark 开始进入刷新状态
////头部刷新
- (void)headerRereshing  //加载最新数据
{

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (self.details.count) {
        Details * aaa = [self.details firstObject];
        params[@"pagingTag"] = @(aaa.detailId);
    }else{
        params[@"pagingTag"] = @"";
    }
    params[@"pagingSize"] = @(10);
    [self getNewMoreData:params];
    // 2.(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView headerEndRefreshing];
}
//
///**
// *  下拉加载更新数据
// */
-(void)getNewMoreData:(NSMutableDictionary *)params{
    
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"details"];
    
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        
        
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * taskArray = [Details objectArrayWithKeyValuesArray:json[@"resultData"][@"details"]];
            NSMutableArray * taskaa = [NSMutableArray arrayWithArray:taskArray];
            [taskaa addObjectsFromArray:self.details];
            self.details = taskaa;
//            [self showHomeRefershCount:taskArray.count];
            NSLog(@"%@",self.details[1]);
            [self.tableView reloadData];    //刷新数据
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
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
    BPCell *cell = [tableView dequeueReusableCellWithIdentifier:BPCellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BPCell" owner:nil options:nil] lastObject];
    }
    Details *detail = self.details[indexPath.row];
    
    NSDate * ptime = [NSDate dateWithTimeIntervalSince1970:(detail.date/1000.0)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString * publishtime = [formatter stringFromDate:ptime];
    
    NSString *str;
    if (detail.vary > 0) {
        str = [NSString stringWithFormat:@"+%@M", detail.vary];
        cell.flow.tintColor = [UIColor greenColor];
    }else {
        str = [NSString stringWithFormat:@"-%@M", detail.vary];
        cell.flow.tintColor = [UIColor redColor];
    }
    
    [cell setTitleName:detail.title AndTime:publishtime AndFlow:str];
    return cell;
}









@end
