//
//  HobbyController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/9.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HobbyController.h"
#import "GlobalData.h"


@interface HobbyController ()

@property (nonatomic, strong) NSArray *favs;

@property (nonatomic, strong) NSArray *userSelected;


@end

@implementation HobbyController

static NSString *hobbyIdentify = @"hobbyCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"爱好";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:hobbyIdentify];
    
}

- (NSArray *)favsArray {
    if (self.favs == nil) {
        self.favs = [NSArray array];
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString * fileName = [path stringByAppendingPathComponent:InitGlobalDate];
        GlobalData * global =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        
        self.favs = global.favs;
    }
    return self.favs;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tabelView




#warning table 协议


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
