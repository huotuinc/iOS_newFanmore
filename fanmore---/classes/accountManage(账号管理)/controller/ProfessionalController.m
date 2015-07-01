//
//  ProfessionalController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/9.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "ProfessionalController.h"
#import "GlobalData.h"
#import "twoOption.h"

@interface ProfessionalController ()<UITableViewDelegate,UITableViewDataSource>


/**职业列表*/
@property (strong, nonatomic) NSArray *careers;
/**职业列表*/
@property (assign, nonatomic) int  isSelect;
@end

@implementation ProfessionalController

static NSString *professionalIdentify = @"pfCellId";




- (NSArray *)careers{
    
    if (_careers == nil) {
        
        _careers = [NSArray array];
        //初始化
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString * fileName = [path stringByAppendingPathComponent:InitGlobalDate];
        GlobalData * global =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        
        if (_isPrefessional) {
           _careers = global.career;
        }else{
           _careers = global.incomings;
        }
        
        
    }
    return _careers;
}

- (void)setCurrentCareer:(NSString *)currentCareer
{
    _currentCareer = currentCareer;
    
    for (int index = 0; index < self.careers.count; index++) {
        
        twoOption * two = self.careers[index];
        if ([two.name isEqualToString:currentCareer]) {
            
            _isSelect = index;
            break;
        }else{
            _isSelect = -1;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职业列表";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:professionalIdentify];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.tableView setTableHeaderView:[[UIView alloc] init]];
   
}


#pragma mark DateSouces tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return self.careers.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
//    NSLog(@"xxxxxx收入和职业%@",self.currentCareer);
    
//    NSLog(@"%lu",(unsigned long)[self.careers indexOfObject:self.currentCareer]);
    if (_isSelect == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    twoOption * ca = self.careers[indexPath.row];
    cell.textLabel.text = ca.name;
    return cell;
}

#pragma mark tableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    twoOption * op = self.careers[indexPath.row];
//    NSLog(@"%d-----%@",op.value,op.name);
    if ([self.delegate respondsToSelector:@selector(ProfessionalControllerBringBackCareer:isFlag:)]) {
       [self.delegate ProfessionalControllerBringBackCareer:op isFlag:_isPrefessional];
     }
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    if (self.isPrefessional) {
//        params[@"profileType"] = @"3";
//    }else {
//        params[@"profileType"] = @"4";
//    }
//    
//    params[@"profileData"] = @(indexPath.row);
    
//    NSString *urlStr = [MainURL stringByAppendingString:@"updateProfile"];
//    [UserLoginTool loginRequestPost:urlStr parame:params success:^(id json) {
//        [MBProgressHUD showSuccess:@"上传成功"];
//        NSLog(@"dadadasdasdasd%@",json);
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        [MBProgressHUD showError:@"上传失败"];
//    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}


    
    



@end
