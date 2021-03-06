//
//  LoginViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/22.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "LoginViewController.h"
#import "RootViewController.h"

@interface LoginViewController ()
/**用户名*/
@property (weak, nonatomic) IBOutlet UITextField *userNameTextFiled;
/**密码*/
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
/**登录按钮*/
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

/**整个背景*/
@property (weak, nonatomic) IBOutlet UIView *backView;



/**登录按钮*/
- (IBAction)loginBtn:(id)sender;
/**忘记密码点击*/
- (IBAction)forgetPWBtn:(id)sender;
/**注册*/
- (IBAction)loginBtnClick:(id)sender;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1、设置控件属性
    [self setweigtAttribute];
    //2、设置键盘弹出的监听
    [self registerForKeyboardNotifications];
    //3、设置键盘弹出
    [self.userNameTextFiled becomeFirstResponder] ;
}

/**
 *  设置键盘弹出的监听
 */
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
/**
 *  键盘弹出
 *
 *  @param noto <#noto description#>
 */
-(void)keyboardWasShown:(NSNotification *) note{
    
    NSDictionary* info = [note userInfo];
    NSLog(@"%@",note);
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"%@",NSStringFromCGSize(kbSize));
    CGFloat sizesss = CGRectGetMaxY(self.loginBtn.frame) - (ScreenHeight - kbSize.height);
    
    if (sizesss > 0) {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            self.backView.transform = CGAffineTransformMakeTranslation(0,-(sizesss));
        }];
        
    }
}
/**
 *  键盘退下
 *
 *  @param noto <#noto description#>
 */
-(void)keyboardWillBeHidden:(NSNotification *) note{
    [UIView animateWithDuration:0.1 animations:^{
        
        self.backView.transform = CGAffineTransformIdentity;
    }];
}
/**
 *设置控件属性
 */
- (void) setweigtAttribute
{
    self.title = @"用户登录";
//    self.loginBtn.backgroundColor = LWColor(18, 18, 127);
}

/**退下下键盘*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/**
 * 登录
 */
- (IBAction)loginBtn:(id)sender {
    
    [self.view endEditing:YES];
//    if (!self.userNameTextFiled.text.length) {
//        [MBProgressHUD showError:@"用户名或者手机号不能为空"];
//        return;
//    }
//    if (!self.passwdTextField.text.length) {
//        [MBProgressHUD showError:@"密码不能为空"];
//        return;
//    }
    //设置参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"username"] = self.userNameTextFiled.text;
    params[@"password"] = [MD5Encryption md5by32:self.passwdTextField.text];
    NSString *urlStr = [MainURL stringByAppendingPathComponent:@"login"];
    //发送网络请求
    [UserLoginTool loginRequestGet:urlStr parame:params success:^(id json) {
        NSLog(@"登入成功%@",json);
        if(![self checkTel:self.userNameTextFiled.text]){
            NSLog(@"不是手机号");
            BoundPhoneViewController * bound = [[BoundPhoneViewController alloc] init];
            [self.navigationController pushViewController:bound animated:YES];
        }else{
            RootViewController * roots = [[RootViewController alloc] init];
            UIWindow * mainWindow = [UIApplication sharedApplication].keyWindow;
            mainWindow.rootViewController = roots;
        }
    } failure:^(NSError *error) {
        NSLog(@"登录失败%@",[error localizedDescription]);
    }];
}

- (void)dealloc{
    
//    [[NSNotification description] removeObserver:self forKeyPath:nil];
    NSLog(@"登录窗口销毁了");
}
/**
 * 忘记密码
 */
- (IBAction)forgetPWBtn:(id)sender {
    findBackPwViewController * vc = [[findBackPwViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 * 注册
 */
- (IBAction)loginBtnClick:(id)sender {
    UserRegisterViewController * UserRegist = [[UserRegisterViewController alloc] init];
    [self.navigationController pushViewController:UserRegist animated:YES];
}

/**
 *  验证手机号的正则表达式
 */
-(BOOL) checkTel:(NSString *) phoneNumber{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    
    if (!isMatch) {
        return NO;
    }
    return YES;
}

@end
