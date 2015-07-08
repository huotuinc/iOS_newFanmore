//
//  ExchangeController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/23.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "ExchangeController.h"
#import "ConversionCell.h"
#import "userData.h"
#import "userData.h"

@interface ExchangeController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSIndexPath *selecet;
@property(nonatomic,strong) userData * userInfo;
@property (nonatomic, strong) NSMutableArray *showArray;

@end

@implementation ExchangeController

static NSString *tableViewIdentifier = @"tableCell";

NSString * _changeflah = nil;

- (userData *)userInfo{
    
    if (_userInfo == nil) {
        
        //初始化
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //1、保存个人信息
        NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
        _userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName]; //保存用户信息
    }
    
    return _userInfo;
}



#pragma table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"兑换%@流量包", self.showArray[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UITableViewCell *scell = [tableView cellForRowAtIndexPath:self.selecet];
    scell.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor orangeColor];
    self.selecet = indexPath;
    
    if (([self.userInfo.balance floatValue]< [self.flays[indexPath.row] floatValue])) {
                [MBProgressHUD showError:@"当前可兑换流量不足"];
                return;
            }
        
            NSString *flaycount = [NSString stringWithFormat:@"是否兑换流量%@",self.showArray[indexPath.row]];
            if (IsIos8) {
                UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:nil message:flaycount preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
                    //兑换流量
                    NSString *url = [MainURL stringByAppendingPathComponent:@"checkout"];
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    param[@"amount"] = self.flays[indexPath.row];
                    [MBProgressHUD showMessage:nil];
                    __weak ExchangeController * wself = self;
                    [UserLoginTool loginRequestPost:url parame:param success:^(id json) {
                        [MBProgressHUD hideHUD];
//                        NSLog(@"%@",json);
                        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
                            [MBProgressHUD showError:@"账号被登入"];
                            LoginViewController * aa = [[LoginViewController alloc] init];
                            [wself presentViewController:aa animated:YES completion:nil];
                            return ;
                        }
                        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
                            
                            userData * user = [userData objectWithKeyValues:json[@"resultData"][@"user"]];
                            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                            
                            //1、保存个人信息
                            NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
                            [NSKeyedArchiver archiveRootObject:user toFile:fileName]; //保存用户信息
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                if ([self.delegate respondsToSelector:@selector(successExchange:)]) {
                                    [MBProgressHUD showSuccess:@"兑换流量成功"];
                                    [self.delegate successExchange:user.balance];
//                                    [self.delegate setWaringLabel];
                                }
                                
                            });
                            
                            [self dismissViewControllerAnimated:YES completion:nil];
        
                        }
                        
                        
                    } failure:^(NSError *error) {
                        [MBProgressHUD hideHUD];
                    }];
                    
                }];
                
                UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertVc addAction:action];
                [alertVc addAction:action1];
                [self presentViewController:alertVc animated:YES completion:nil];
            }else{ //非ios8
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:flaycount delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
                [alert show];
            }


}


- (void)_initNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回"
                                                                                style:UIBarButtonItemStylePlain
                                                                              handler:^(id sender) {
                                                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                                                              }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView removeSpaces];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewIdentifier];
    
//    //设置头视图
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 10, 20)];
//    label.text = @"兑换流量当月有效";
//    label.font = [UIFont systemFontOfSize:14];
//    [view addSubview:label];
//    
//    self.tableView.tableHeaderView = view;
    
    self.title = @"兑换流量当月有效";
    
    self.showArray = [NSMutableArray array];
    
//    NSLog(@"%@", self.flays);
    for (int i = 0; i < self.flays.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@M", self.flays[i]];
        CGFloat j = [str floatValue];
        if (j >= 1024) {
            if (((int)j % 1024) ) {
                NSString *newStr = [NSString stringWithFormat:@"%.1fG（1G=1024M）", j / 1024];
                [self.showArray addObject:newStr];
            }else {
                NSString *newStr = [NSString stringWithFormat:@"%.0fG（1G=1024M）", j / 1024];
                [self.showArray addObject:newStr];
            }
        }else {
            [self.showArray addObject:str];
        }
    }
//    NSLog(@"show!!!!%@", self.showArray);

    
    [self _initNav];
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
