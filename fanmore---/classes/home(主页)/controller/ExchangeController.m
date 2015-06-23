//
//  ExchangeController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/23.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "ExchangeController.h"
#import "ConversionCell.h"

@interface ExchangeController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ExchangeController

static NSString *tableViewIdentifier = @"tableCell";

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
//    cell.label.text = self.flays[indexPath.row];
    
    return cell;
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
