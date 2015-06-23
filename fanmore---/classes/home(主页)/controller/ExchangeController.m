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

@interface ExchangeController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSIndexPath *selecet;
@property(nonatomic,strong) userData * userInfo;

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
    return self.flays.count + 5;
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
    cell.textLabel.text = @"70M";
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
    
    if (([self.userInfo.balance floatValue]< [_changeflah floatValue])) {
                [MBProgressHUD showError:@"当前可兑换流量不足"];
                return;
            }
        
            NSString *flaycount = [NSString stringWithFormat:@"是否兑换流量%@M",_changeflah];
            if (IsIos8) {
                UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:nil message:flaycount preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
                    //兑换流量
                    NSString *url = [MainURL stringByAppendingPathComponent:@"prepareCheckout"];
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    param[@"amount"] = _changeflah;
                    [UserLoginTool loginRequestPost:url parame:param success:^(id json) {
        
                        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
        
        
                            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
                            //1、保存个人信息
                            NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
                            [NSKeyedArchiver archiveRootObject:[userData objectWithKeyValues:json[@"resultDate"][@"user"]] toFile:fileName];
        
                        }
        
                    } failure:^(NSError *error) {
        
                    }];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
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
