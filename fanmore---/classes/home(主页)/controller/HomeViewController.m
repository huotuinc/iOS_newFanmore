//
//  HomeViewController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HomeViewController.h"
#import "TrafficShowController.h"
#import "RootViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "HomeCell.h"
#import "detailViewController.h"
#import "BuyFlowViewController.h"
#import "taskData.h"
#import <AddressBook/AddressBook.h>

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
/**任务列表*/
@property(nonatomic,strong)NSMutableArray * taskDatas;
@end

@implementation HomeViewController

static NSString *homeCellidentify = @"homeCellId";



/**
 *  网络数据数组懒加载
 *
 *  @return 一个数组
 */
- (NSMutableArray *)taskDatas{
    if (_taskDatas == nil) {
        
        _taskDatas = [NSMutableArray array];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"pagingTag"] = @"";
        params[@"pagingSize"] = @(4);
        [self getNewMoreData:params];
        [self.tableView reloadData];
    }
    
    return _taskDatas;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
}

- (void)loadView
{
    [super loadView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    [self _initView];
    
    [self _initNav];
    
    //集成刷新控件
    [self setupRefresh];
    
    [self.tableView removeSpaces];
    

}

- (void)_initView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:homeCellidentify];
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


#pragma mark 读取通讯录
- (void)getAdressBook
{
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    }
    else
    {
        addressBooks = ABAddressBookCreate();
        
    }
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    for (NSInteger i = 0; i < nPeople; i++) {
        //        TKAddressBook *addressBook = [[TKAddressBook alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        NSLog(@"%@",nameString);
    }
}



#pragma mark 开始进入刷新状态
//头部刷新
- (void)headerRereshing  //加载最新数据
{
//    startIndex = @1;
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (self.taskDatas.count) {
        taskData * aaa = self.taskDatas[0];
        params[@"pagingTag"] = @(aaa.taskOrder);
    }else{
        params[@"pagingTag"] = @"";
    }
    
    params[@"pagingSize"] = @(2);
    [self getNewMoreData:params];
    
//    // 2.(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView headerEndRefreshing];
}

/**
 *  下拉加载更新数据
 */
-(void)getNewMoreData:(NSMutableDictionary *)params{
    
    NSString * usrStr = [MainURL stringByAppendingPathComponent:@"taskList"];
    [UserLoginTool loginRequestGet:usrStr parame:params success:^(id json) {
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * taskArray = [taskData objectArrayWithKeyValuesArray:json[@"resultData"][@"task"]];
            NSMutableArray * taskaa = [NSMutableArray arrayWithArray:taskArray];
            [taskaa addObjectsFromArray:self.taskDatas];
            self.taskDatas = taskaa;
            [self.tableView reloadData];    //刷新数据
        }
            
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}

- (void)_initNav
{
    //根视图控制器转跳
    __weak RootViewController *rootVC = (RootViewController *)self.mm_drawerController;
    UIImage *image = [UIImage imageNamed:@"menu"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"菜单" style:UIBarButtonItemStylePlain
                                                                              handler:^(id sender) {
                                                                                  [rootVC toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
                                                                              }];
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"买流量" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
//    rightBarButton.tintColor = [UIColor blackColor];
    
    if (self.tableView.hidden) {
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }else {
        UIBarButtonItem *signInBarButton = [[UIBarButtonItem alloc] initWithTitle:@"签到" style:UIBarButtonItemStylePlain target:self  action:@selector(signInAction:)];
//        signInBarButton.tintColor = [UIColor blackColor];
        NSArray *array = [NSArray arrayWithObjects:signInBarButton, rightBarButton, nil];
        self.navigationItem.rightBarButtonItems = array;
    }
    /**
     *  设置签到和买流量
     */
}






#pragma mark 协议方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = nil;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:nil options:nil] lastObject];
    }
    //设置cell样式
    taskData * task = self.taskDatas[indexPath.row];
    NSDate * ptime = [NSDate dateWithTimeIntervalSince1970:[task.publishDate doubleValue]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * publishtime = [formatter stringFromDate:ptime];
    NSLog(@"xxxxxxxx====time  ===%@",publishtime);
    NSLog(@"pictureURL==%@   title==%@",task.pictureURL,task.title);
    
    int a = 0;  //首页右下角标志
    if([task.last intValue]==0){
        a = 2;
    }else{
        a = (task.reward?0:1);
    }
    
    //设置cell样式
    [cell setImage:task.pictureURL andNameLabel:task.title andTimeLabel:publishtime andReceiveLabel:[NSString stringWithFormat:@"免费领取%@M",task.maxBonus] andJoinLabel:[NSString stringWithFormat:@"已有%@人参与",task.luckies] andIntroduceLabel:task.desc andGetImage:a];
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //传递参数
    taskData * task = self.taskDatas[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    detailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    detailVc.taskId = task.taskId; //获取问题编号
    detailVc.type = task.type;  //答题类型
    detailVc.detailUrl = task.contextURL;//网页详情的url
    [self.navigationController pushViewController:detailVc animated:YES];
}
/**
 *  买流量
 */

- (void)rightBarButtonAction:(UIButton *) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BuyFlowViewController *buyFlowVc = [storyboard instantiateViewControllerWithIdentifier:@"BuyFlowViewController"];
    [self.navigationController pushViewController:buyFlowVc animated:YES];
}

/**
 *  签到
 *
 *  @param sender
 */
- (void)signInAction:(UIButton *)sender
{
    
}


@end
