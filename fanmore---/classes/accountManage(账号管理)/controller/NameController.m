//
//  NameController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/8.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "NameController.h"

@interface NameController ()

@end

@implementation NameController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    [self.nameLabel becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nameLabel.text = self.name;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"updateProfile"]; //保存到服务器
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    NSLog(@"%@",self.nameLabel.text);
    parame[@"profileType"] = @(1);
    parame[@"profileData"] = self.nameLabel.text;
    [UserLoginTool loginRequestPost:urlStr parame:parame success:^(id json) {
        
        NSLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            userData * user = [userData objectWithKeyValues:json[@"resultData"][@"user"]];
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
            [NSKeyedArchiver archiveRootObject:user toFile:fileName];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    if ([self.delegate respondsToSelector:@selector(NameControllerpickName:)]) {
        [self.delegate NameControllerpickName:self.nameLabel.text];
    }
}



@end
