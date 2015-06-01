//
//  DiscipleViewController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/29.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "DiscipleViewController.h"
#import "DiscipleCell.h"


@implementation DiscipleViewController

static NSString *discipleCellidentify = @"DiscipleCellid";

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscipleCell" bundle:nil] forCellReuseIdentifier:discipleCellidentify];
}


#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscipleCell *cell = nil;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiscipleCell" owner:nil options:nil] lastObject];
    }
    return cell;
}



@end
