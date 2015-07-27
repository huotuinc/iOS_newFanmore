//
//  FriendMessageController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/17.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "FriendMessageController.h"
#import "FriendCell.h"

@interface FriendMessageController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

/**
 *  消息列表数据
 */
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation FriendMessageController

static NSString *friendMIdentify = @"FMCellId";

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:friendMIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendCell" owner:nil options:nil] lastObject];
    }
    return cell;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友请求";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:friendMIdentify];
    [self.tableView removeSpaces];
    
    self.tableView.tableHeaderView = [[UIView alloc] init];
    
    [self.navigationItem.rightBarButtonItem = [UIBarButtonItem alloc] bk_initWithTitle:@"拒绝全部" style:UIBarButtonItemStylePlain handler:^(id sender) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"要拒绝全部好友请求么？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = 101;
        [alert show];
    }];
    
    
}

- (void)cleanFriendMessage {
    [MBProgressHUD showMessage:nil];
    [UserLoginTool loginRequestGet:@"cleanRequestFC" parame:nil success:^(id json) {
        [self.array removeAllObjects];
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络"];
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            [self cleanFriendMessage];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self saveControllerToAppDelegate:self];
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
