//
//  UserRegisterViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//  用户注册

#import "UserRegisterViewController.h"


@interface UserRegisterViewController () <UITextFieldDelegate>

/**用户注册邀请码*/
@property (weak, nonatomic) IBOutlet UITextField *InvitationCode;
/**用户注册手机号*/
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
/**用户注册手机号验证码*/
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
/**用户注册手机号密码1*/
@property (weak, nonatomic) IBOutlet UITextField *firstPassword;
/**用户注册手机号密码2*/
@property (weak, nonatomic) IBOutlet UITextField *secondPassword;
/**用户注册获取验证码*/
@property (weak, nonatomic) IBOutlet UIButton *verification;
/**用户注册分隔线*/
@property (weak, nonatomic) IBOutlet UIView *firstSeperatorLine;
/**用户注册分隔线*/
@property (weak, nonatomic) IBOutlet UIView *secondSeperatorLine;

/**用户注册按钮点击监听*/
- (IBAction)registerButtonClick:(id)sender;
/**用户注册获取验证码*/
- (IBAction)verification:(UIButton *)sender;

@end

@implementation UserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
   
    
    //1、设置导航栏样式
    [self setNavgationStytle];
    //2、设置文本框代理
    [self setupWidget];
    //3、监听键盘弹出
//    [self setupkeyboardShow];
}

/**
 * 监听键盘弹出
 */
- (void)setupkeyboardShow{
    
}

/**
 * 设置导航栏样式
 */
- (void)setNavgationStytle{
//    self.view.backgroundColor = [UIColor blueColor];
    self.title = @"用户注册";
   
}

/**
 * 设置界面控件属性
 */
- (void)setupWidget{
    
    // 设置代理
    self.InvitationCode.delegate = self;
    self.phoneNumber.delegate = self;
    self.verificationCode.delegate = self;
    self.firstPassword.delegate = self;
    self.secondPassword.delegate = self;
    // 设置分割线属性
    self.firstSeperatorLine.alpha = 0.5;
    self.secondSeperatorLine.alpha = 0.5;
}

/**
 * 点击注册按钮
 */
- (IBAction)registerButtonClick:(UIButton *)sender {
    
    NSLog(@"dasdasdasdasdasds注册");
    if (!self.phoneNumber.text.length) {//手机号不能为空
        
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    if (!self.verificationCode.text.length) {//验证码不能为空
        
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    if (!self.firstPassword.text.length||!self.secondPassword.text.length) {//手机号不能为空
        
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (![self.firstPassword.text isEqualToString:self.secondPassword.text]) {
        
        [MBProgressHUD showError:@"两次输入密码不同"];
        return;
    }
    //参数设置
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"phone"] = self.phoneNumber.text;
    //密码进行MD5加密
    NSString * passwd = self.secondPassword.text;
    parame[@"password"] = [MD5Encryption md5by32:passwd];
    parame[@"authcode"] = self.verificationCode.text;
    self.InvitationCode.text.length?(parame[@"invcode"] = self.InvitationCode.text):(parame[@"invcode"] = [NSString stringWithFormat:@""]);
    //发送网络请求
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"reg"];
    __weak UserRegisterViewController *wself = self;
    [UserLoginTool loginRequestGet:urlStr parame:parame success:^(id json) {
        NSLog(@"注册成功%@",json);
        if ([wself.delegate respondsToSelector:@selector(UserRegisterViewSuccess)]) {
            
            [wself.delegate UserRegisterViewSuccess];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
       
         NSLog(@"注册失败%@",[error localizedDescription]);
    }];
}

- (IBAction)verification:(UIButton *)sender {
    
    //判断手机号是否输入正确
    NSString * phoneNumber= self.phoneNumber.text;
    NSLog(@"%@",phoneNumber);
    if ([phoneNumber isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    //判断是否是手机号
    if (![self checkTel:phoneNumber]) {
        
        [MBProgressHUD showError:@"帐号必须是手机号"];
        self.phoneNumber.text = @"";
        return ;
    }
    
    //网络请求获取验证码
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"phone"] = phoneNumber;
    params[@"type"] = @(1);
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"sendSMS"];
    NSLog(@"=======%@",urlStr);
    [UserLoginTool loginRequestPost:urlStr parame:params success:^(id json) {
       NSLog(@"注册验证码获取成功");
    } failure:^(NSError *error) {
        NSLog(@"注册验证码获取失败%@",[error localizedDescription]);
    }];
    //验证码的倒计时
    [self settime];
}

/**
 * 设置验证码的倒计时
 */
- (void)settime{
    
    /*************倒计时************/
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.verification setTitle:@"验证码" forState:UIControlStateNormal];
                //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                self.verification.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [self.verification setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.verification.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
/**
 * 点击屏幕退下键盘
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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


#pragma mark TextFieldDelegate
/**
 * 文本框结束编辑
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.secondPassword == textField) {//第二个密码文本框
        if (![self.secondPassword.text isEqualToString:self.firstPassword.text]) {
            
            [MBProgressHUD showError:@"两次输入的密码不相同"];
           
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.phoneNumber == textField)  //车牌号判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 11) { //如果输入框内容大于20则弹出警告
            [MBProgressHUD showError:@"手机号不能超过11位"];
            self.phoneNumber.text = [toBeString substringToIndex:11];
            return NO;
        }
        
    }
    if (self.verificationCode == textField)  //车牌号判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 6) { //如果输入框内容大于20则弹出警告
            [MBProgressHUD showError:@"验证码不能超过6位"];
            self.verificationCode.text = [toBeString substringToIndex:6];
            return NO;
        }
        
    }
    return YES;
}

@end
