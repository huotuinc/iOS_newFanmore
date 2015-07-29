//
//  FriendMessageController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/17.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "FriendMessageController.h"
#import "FriendCell.h"
#import "FriendMessageModel.h"
#import <SDWebImageManager.h>


#define PageSize 10

@interface FriendMessageController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

/**
 *  消息列表数据
 */
@property (nonatomic, strong) NSMutableArray *array;

/**
 *  选中的的cell
 */
@property (nonatomic, strong) NSIndexPath *seIndexpath;

@end

@implementation FriendMessageController

static NSString *friendMIdentify = @"FMCellId";

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%@",self.array);
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:friendMIdentify forIndexPath:indexPath];
    
    FriendMessageModel *model = self.array[indexPath.row];
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    
    NSString *str = [NSString string];
    if (model.fromName.length) {
        str = [NSString stringWithFormat:@"%@(%@)",model.fromName, model.from];
    }else {
        str = model.from;
    }
    
    [cell setUserPhone:str AndUserName:model.message AndSex:model.fromSex AndFlow:[NSString stringWithFormat:@"求%@M", model.fee] AndOperator:nil];
    
    cell.flowLabel.textColor = [UIColor colorWithRed:0.000 green:0.670 blue:0.000 alpha:1.000];
    
    NSURL * url = [NSURL URLWithString:model.fromPicUrl];
    [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        if (error == nil) {
            [cell.headImage setBackgroundImage:image forState:UIControlStateNormal];
            [cell.headImage setBackgroundImage:image forState:UIControlStateHighlighted];
        }
        
    }];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.seIndexpath = indexPath;
    
    FriendMessageModel *model = self.array[indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"送'ta'%@M流量", model.fee] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 102;
    
    [alert show];
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString * usrStr = [MainURL stringByAppendingPathComponent:@"deleteRequestFC"];
        FriendMessageModel *model = self.array[indexPath.row];
        
        NSMutableDictionary *parame = [NSMutableDictionary dictionaryWithObject:model.infoId forKey:@"infoId"];
        
        [MBProgressHUD showMessage:nil];
        [UserLoginTool loginRequestGet:usrStr parame:parame success:^(id json) {
            [self.array removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [MBProgressHUD hideHUD];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUD];
        }];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = [NSMutableArray array];
    
    self.seIndexpath = [[NSIndexPath alloc] init];
    
    self.title = @"好友请求";
    
    [self setupRefresh];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:friendMIdentify];
    [self.tableView removeSpaces];
    
    self.tableView.tableHeaderView = [[UIView alloc] init];
    
    [self.navigationItem.rightBarButtonItem = [UIBarButtonItem alloc] bk_initWithTitle:@"拒绝全部" style:UIBarButtonItemStylePlain handler:^(id sender) {
        if (self.array.count) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"要拒绝全部好友请求么？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag = 101;
            [alert show];
        }else {
        }
        
    }];
    
    
    
    
    
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
    
    FriendMessageModel * fladetail = [self.array lastObject];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    params[@"pagingTag"] = fladetail.infoId;
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
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"requestFCList"];
    
    //    [MBProgressHUD showMessage:nil];
    __weak FriendMessageController *wself = self;
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        //        [MBProgressHUD hideHUD];
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            aaa.tag = 1;
            [aaa show];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * taskArray = [FriendMessageModel objectArrayWithKeyValuesArray:json[@"resultData"][@"requests"]];
            if (taskArray.count > 0) {
                [wself.array addObjectsFromArray:taskArray];
                [wself.tableView reloadData];    //刷新数据
            }
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"粉猫服务器连接异常"];
        //        NSLog(@"%@",[error description]);
    }];
    
}

/**
 *  下拉加载更新数据
 */
-(void)getNewMoreData:(NSMutableDictionary *)params{
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"requestFCList"];
    __weak FriendMessageController *wself = self;
    //    [MBProgressHUD showMessage:nil];
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        //        [MBProgressHUD hideHUD];
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [aaa show];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56000){
        
            [MBProgressHUD showSuccess:json[@"resultDescription"]];
            [self.array removeAllObjects];
            
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            [MBProgressHUD hideHUD];
            NSLog(@"%@",json);
            NSArray * taskArray = [FriendMessageModel objectArrayWithKeyValuesArray:json[@"resultData"][@"requests"]];
            [wself.array removeAllObjects];
            wself.array = [NSMutableArray arrayWithArray:taskArray];
            //            [wself showHomeRefershCount];
            [wself.tableView reloadData];    //刷新数据
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"粉猫服务器连接异常"];
        
    }];
}


/*
- (void)deleteFriendMessage:(NSIndexPath*) indexPath  {
    [self.array removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    FriendMessageModel *model = self.array[indexPath.row];
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionaryWithObject:model.infoId forKey:@"infoId"];
    
    [MBProgressHUD showMessage:nil];
    [UserLoginTool loginRequestGet:@"deleteRequestFC" parame:parame success:^(id json) {
        [self.tableView deleteRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationLeft];
        [self.array removeObjectAtIndex:indexPath.row];
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}
*/

/**
 *  接受好友的求流量
 *
 *  @return <#return value description#>
 */
- (void)sendFriendFlow {
    
    FriendMessageModel *model = self.array[self.seIndexpath.row];
    
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"makeProvide"];
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"originMobile"] = model.from;
    parame[@"fc"] = [NSString stringWithFormat:@"%d",[model.fee intValue]];
    parame[@"infoId"] = model.infoId;
    
    NSLog(@"%@", parame);
    [MBProgressHUD showMessage:nil];
    [UserLoginTool loginRequestGet:usrStr parame:parame success:^(id json) {
        NSLog(@"%@",json);
        [self.array removeObjectAtIndex:self.seIndexpath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.seIndexpath] withRowAnimation:UITableViewRowAnimationLeft];
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"粉猫服务器连接异常"];
    }];
}


//清空好友列表
- (void)cleanFriendMessage {
    
    
        NSString * usrStr = [MainURL stringByAppendingPathComponent:@"cleanRequestFC"];
        
        [MBProgressHUD showMessage:nil];
        [UserLoginTool loginRequestGet:usrStr parame:nil success:^(id json) {
            NSLog(@"%@",json);
            [self.array removeAllObjects];
            [self.tableView reloadData];
            [MBProgressHUD hideHUD];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"粉猫服务器连接异常"];
        }];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            [self cleanFriendMessage];
        }
    }else if(alertView.tag == 102) {
        if (buttonIndex == 0) {
            [self sendFriendFlow];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
