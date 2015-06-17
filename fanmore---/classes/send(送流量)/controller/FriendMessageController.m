//
//  FriendMessageController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/17.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "FriendMessageController.h"
#import "FriendCell.h"

@interface FriendMessageController ()<UITableViewDelegate, UITableViewDataSource>

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:friendMIdentify];
    [self.tableView removeSpaces];
    
    self.tableView.tableHeaderView = [[UIView alloc] init];
    
    
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
