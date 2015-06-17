//
//  LoginViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/22.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "LoginViewController.h"
#import "RootViewController.h"
#import "Result.h"
#import "LoginResultData.h"

@interface LoginViewController ()<UserRegisterViewDelegate,BoundPhoneViewControllerDelegate>
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


/**显示导行栏*/
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1、设置控件属性
    [self setweigtAttribute];
    //2、设置键盘弹出的监听
    [self registerForKeyboardNotifications];
    //3、设置键盘弹出
//    [self.userNameTextFiled becomeFirstResponder];
    
    //4.导航栏返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
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
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
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
    self.title = @"粉猫登陆";
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
    
    //手机号
    if (!self.userNameTextFiled.text.length) {

        if (IsIos8) {
            
            UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"用户名或者手机号不能为空" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                }];
            [alertVc addAction:action];
            [self presentViewController:alertVc animated:YES completion:nil];
        }else{ //非ios8
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message: @"用户名或者手机号不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        return;
    }
    //密码
    if (!self.passwdTextField.text.length) {
        if (IsIos8) {
            
            UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            [alertVc addAction:action];
            [self presentViewController:alertVc animated:YES completion:nil];
        }else{ //非ios8
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message: @"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        return;
    }
    //设置参数
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"username"] = self.userNameTextFiled.text;
    params[@"password"] = [MD5Encryption md5by32:self.passwdTextField.text];
    NSString *urlStr = [MainURL stringByAppendingPathComponent:@"login"];
    //发送网络请求
    [MBProgressHUD showMessage:nil];
    [UserLoginTool loginRequestGet:urlStr parame:params success:^(NSDictionary * json) {
        NSLog(@"login========%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 53011) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"密码错误"];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            [MBProgressHUD hideHUD];
            NSLog(@"登录成功=========== %@",json);
            userData * userInfo = [userData objectWithKeyValues:(json[@"resultData"][@"user"])];
            //1、登入成功用户数据本地化
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
            [NSKeyedArchiver archiveRootObject:userInfo toFile:fileName];
            //2、保存手机号和密码
            [[NSUserDefaults standardUserDefaults] setObject:self.userNameTextFiled.text forKey:loginUserName];
            [[NSUserDefaults standardUserDefaults] setObject:[MD5Encryption md5by32:self.passwdTextField.text] forKey:loginPassword];
            //3、保存登录token
            NSString * apptoken = [[NSUserDefaults standardUserDefaults] stringForKey:AppToken];
            if (![apptoken isEqualToString:userInfo.token]) { //当前token和原先的token不同
                [[NSUserDefaults standardUserDefaults] setObject:userInfo.token forKey:AppToken];
            }

            //4、表示没有绑定的必要 1表示有绑定的必要
            if ([json[@"resultData"][@"requireMobile"] intValue] == 1) {
                [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
                BoundPhoneViewController * bdVc = [[BoundPhoneViewController alloc] init];
                [self.navigationController pushViewController:bdVc animated:YES];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"right" forKey:loginFlag];
                
                if ([self.delegate respondsToSelector:@selector(LoginViewDelegate:)]) {
                    
                    [self.delegate LoginViewDelegate:self.loginType];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
               
                
            }
            
        }
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        NSLog(@"登录失败%@",[error localizedDescription]);
//        [MBProgressHUD showError:@"无法连接到服务器"];
        
    }];
}


/**
 *  有动画
 */
- (void) loginSuccess{
    if ([self.delegate respondsToSelector:@selector(LoginViewDelegate:)]) {
        
        [self.delegate LoginViewDelegate:self.loginType];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  没动画
 */
- (void) loginSuccess1{
    
    if ([self.delegate respondsToSelector:@selector(LoginViewDelegate:)]) {
        
        [self.delegate LoginViewDelegate:self.loginType];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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


#pragma UserRegisterViewDelegate 注册成功
- (void)UserRegisterViewSuccess:(userData *)userInfo{
   
    [self loginSuccess1];
}


- (void)BoundPhoneViewControllerToBoundPhoneNumber{
    
    [self loginSuccess1];
}
@end
