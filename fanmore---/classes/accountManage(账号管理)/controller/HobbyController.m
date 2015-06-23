//
//  HobbyController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/9.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HobbyController.h"
#import "GlobalData.h"
#import "twoOption.h"


@interface HobbyController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *favs;

@property (nonatomic, strong) NSMutableArray *userSelected;

@property(nonatomic,strong)NSMutableString * pickLove;
@end

@implementation HobbyController

static NSString *hobbyIdentify = @"hobbyCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_favs == nil) {
        _favs = [NSArray array];
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString * fileName = [path stringByAppendingPathComponent:InitGlobalDate];
        GlobalData * global =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        
        _favs = global.favs;
    }
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(back)];
    
    self.title = @"爱好";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:hobbyIdentify];
    [self.tableView removeSpaces];
    
    self.userSelected = [NSMutableArray array];
    
    
}


//- (void)back{
//    

//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tabelView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.favs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hobbyIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    twoOption *str  = self.favs[indexPath.row];
    cell.textLabel.text = str.name;
    
    if ([self.userHobby rangeOfString:cell.textLabel.text].location != NSNotFound) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.userSelected addObject:@(indexPath.row)];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.userSelected removeObject:@(indexPath.row)];
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.userSelected addObject:@(indexPath.row)];
    }
}



- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSMutableString *str = [NSMutableString string];
    NSMutableString *strss = [NSMutableString string];
    for (NSString *temp in self.userSelected) {
        [str appendFormat:@"%@,",temp];
        twoOption * option = [self.favs objectAtIndex:[temp intValue]];
        [strss appendFormat:@"%@,",option.name];
    }
    if (str.length != 0) {
        NSString *str1 = [str substringToIndex:[str length] - 1];
        NSString *str2 = [strss substringToIndex:[strss length] - 1];
        if ([self.delegate respondsToSelector:@selector(pickOVerhobby:andOption:)]) {
            [self.delegate pickOVerhobby:str1 andOption:str2];
        }
    }
}


@end
