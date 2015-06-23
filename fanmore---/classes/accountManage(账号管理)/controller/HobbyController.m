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
    
    self.title = @"爱好";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:hobbyIdentify];
    [self.tableView removeSpaces];
    
    self.userSelected = [NSMutableArray array];
    
    
}

//- (NSArray *)favsArray {
//    if (_favs == nil) {
//        _favs = [NSArray array];
//        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSString * fileName = [path stringByAppendingPathComponent:InitGlobalDate];
//        GlobalData * global =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
//        
//        _favs = global.favs;
//        NSLog(@"%@",global.favs);
//    }
//    return _favs;
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

- (void)viewWillDisappear:(BOOL)animated
{
    NSMutableString *str = [NSMutableString string];
    for (NSString *temp in self.userSelected) {
        [str appendFormat:@"%@,",temp];
    }
    if (str.length != 0) {
        NSString *str1 = [str substringToIndex:[str length] - 1];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"profileType"] = @"5";
        params[@"profileData"] = str1;
        
        NSString *urlStr = [MainURL stringByAppendingString:@"updateProfile"];
        [UserLoginTool loginRequestPost:urlStr parame:params success:^(id json) {
            [MBProgressHUD showSuccess:@"上传成功"];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD showError:@"上传失败"];
        }];
    }
    
}
//- (void)viewDisappear:(BOOL)animated
//{
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
