//
//  ChangePasswordController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/29.
//  Copyright (c) 2015年 HT. All rights reserved.
//  修改密码

#import "ChangePasswordController.h"


@interface ChangePasswordController ()

/**手机号*/
@property (weak, nonatomic) IBOutlet UILabel *phoneTextLable;

/**输入密码*/
@property (weak, nonatomic) IBOutlet UITextField *oldPassWordTextField;


@property (weak, nonatomic) IBOutlet UITextField *firstPassWord;

@property (weak, nonatomic) IBOutlet UITextField *secondPassword;


/**保存修改密码*/
- (IBAction)changePasswordButton:(id)sender;

@end

@implementation ChangePasswordController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.title = @"修改密码";
    NSString * phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:loginUserName]; //取出手机号
    if (phoneNumber != nil) {
        
        self.phoneTextLable.text = phoneNumber;
    }
    
    [self.phoneTextLable becomeFirstResponder];
}


- (IBAction)changePasswordButton:(id)sender {
    NSString * old = [MD5Encryption md5by32:self.oldPassWordTextField.text];
    NSString * local =  [[NSUserDefaults standardUserDefaults] objectForKey:loginPassword];
    if (![old isEqualToString:local]) {
        [MBProgressHUD showError:@"请输入正确密码"];
        return;
    }
    if ([self.firstPassWord.text length] == 0 ) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if ([self.secondPassword.text length] == 0 ) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (![self.secondPassword.text isEqualToString:self.firstPassWord.text]) {
        [MBProgressHUD showError:@"请输入相同的密码"];
        return;
    }
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"password"] = old;
    parame[@"newPassword"] = [MD5Encryption md5by32:self.secondPassword.text];
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"modifyPassword"];
    [UserLoginTool loginRequestPost:urlStr parame:parame success:^(id json) {
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            [MBProgressHUD showSuccess:@"修改密码成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
//        NSLog(@"%@",error.localizedDescription);
    }];
}
@end
