//
//  SexController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/8.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "SexController.h"

@interface SexController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSIndexPath *selected;

@property(nonatomic,strong)NSArray * sexs;

@end

@implementation SexController



- (NSArray *)sexs
{
    if (_sexs == nil) {
        
        _sexs = [NSArray array];
        _sexs = @[@"男",@"女"];
    }
    return _sexs;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IsIos8) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 88 + 64) style:UITableViewStylePlain];
        
    }
    else {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 88) style:UITableViewStylePlain];
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    [self.tableView removeSpaces];
    
    self.selected = [[NSIndexPath alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sexs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSString * SEX = self.sexs[indexPath.row];
    cell.textLabel.text = SEX;
    
    if(self.sex == indexPath.row){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
        
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //选中的cell打勾
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    
//    UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:self.selected];
//    cell1.accessoryType = UITableViewCellAccessoryNone;
    
    NSString * aa = self.sexs[indexPath.row];
    
//    NSLog(@"xxxxxxxxxxxxxxxxxxx%@",cell.textLabel.text);
    int a = 1;
    if ([aa isEqualToString:@"男"]) {
        a= 0;
    }
    
    __weak SexController * wself = self;
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"updateProfile"]; //保存到服务器
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"profileType"] = @(6);
    parame[@"profileData"] = @(a);
    [UserLoginTool loginRequestPost:urlStr parame:parame success:^(id json) {
        
//        NSLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            userData * user = [userData objectWithKeyValues:json[@"resultData"][@"user"]];
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
            [NSKeyedArchiver archiveRootObject:user toFile:fileName];
            
            [MBProgressHUD showSuccess:@"性别上传成功"];
            if ([wself.delegate respondsToSelector:@selector(selectSexOver:)]) {
                
                [wself.delegate selectSexOver:a];
            }
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
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
