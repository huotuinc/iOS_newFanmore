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

@end

@implementation SexController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64 + 88) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"男";
        if (self.sex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selected = indexPath;
        }
    }else {
        cell.textLabel.text = @"女";
        if (!self.sex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selected = indexPath;
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中的cell打勾
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:self.selected];
    cell1.accessoryType = UITableViewCellAccessoryNone;
    
    #warning 网络访问 cell的数据上传
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
