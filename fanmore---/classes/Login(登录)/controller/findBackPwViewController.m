//
//  findBackPwViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/22.
//  Copyright (c) 2015年 HT. All rights reserved.
//  找回密码

#import "findBackPwViewController.h"

@interface findBackPwViewController ()<UITextFieldDelegate>
/**手机号*/
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
/**验证码*/
@property (weak, nonatomic) IBOutlet UITextField *verificationTextfiled;
/**获取验证码按钮*/
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
/**新密码*/
@property (weak, nonatomic) IBOutlet UITextField *passwork1Textfield;
/**新密码*/
@property (weak, nonatomic) IBOutlet UITextField *password2Textfield;
@property (weak, nonatomic) IBOutlet UIButton *saveBtu;


/**获取验证码*/
- (IBAction)verificationBtnClick:(id)sender;
/**保存按钮点击*/
- (IBAction)saveBtnClick:(id)sender;

@end

@implementation findBackPwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    //2、设置文本框代理
    [self setupWidget];
    //3、键盘通知
    [self registerForKeyboardNotifications];
    
    [self.phoneNumber becomeFirstResponder];
}

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
    CGFloat sizesss = CGRectGetMaxY(self.saveBtu.frame) - (ScreenHeight - kbSize.height);
    
    if (sizesss > 0) {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(0,-(sizesss));
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
        
        self.view.transform = CGAffineTransformIdentity;
    }];
}


/**
 * 设置界面控件属性
 */
- (void)setupWidget{
    
    self.phoneNumber.delegate = self;
    self.verificationTextfiled.delegate = self;
    self.passwork1Textfield.delegate = self;
    self.password2Textfield.delegate = self;
    
}

- (IBAction)verificationBtnClick:(id)sender {
    
    //判断手机号是否输入正确
    NSString * phoneNumber= self.phoneNumber.text;
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
    //发送验证码请求
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"phone"] = phoneNumber;
    params[@"type"] = @(2);
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"sendSMS"];
    //发送网络请求
//    NSLog(@"sssssss====%@",urlStr);
    [UserLoginTool loginRequestGet:urlStr parame:params success:^(id json) {
        
//        NSLog(@"忘记密码请求成功%@",json);
        //验证码的倒计时
        [self settime];
    } failure:^(NSError *error) {
        
//        NSLog(@"注册失败%@",[error localizedDescription]);
    }];
    
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
                [self.verificationBtn setTitle:@"验证码" forState:UIControlStateNormal];
                //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                self.verificationBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
                [self.verificationBtn setTitle:[NSString stringWithFormat:@"%@秒重新发送",strTime] forState:UIControlStateNormal];
                self.verificationBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//点击view推出键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



- (IBAction)saveBtnClick:(id)sender {
    
    if (![self.password2Textfield.text isEqualToString:self.passwork1Textfield.text]) {
        [MBProgressHUD showError:@"两次输入的密码不相同"];
        return;
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"phone"] = self.phoneNumber.text;
    params[@"password"] = [MD5Encryption md5by32:self.passwork1Textfield.text];
    params[@"authcode"] = self.verificationTextfiled.text;
    
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"forgetPassword"];
    //发送网络请求
//    NSLog(@"sssssss====%@",urlStr);
    __weak findBackPwViewController *wself = self;
    
    [UserLoginTool loginRequestGet:urlStr parame:params success:^(id json) {
        
//        NSLog(@"找回密码成功%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [MBProgressHUD showError:@"账号被登入"];
            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {
            
            [MBProgressHUD showSuccess:@"修改密码成功"];
            
            if ([wself.delegate respondsToSelector:@selector(findBackPassWordScuess)]) {
                [wself.delegate findBackPassWordScuess];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
        
    } failure:^(NSError *error) {
//         NSLog(@"找回密码失败%@",[error localizedDescription]);
    }];

    
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


#pragma mark uitextfieldDelegate
/**
 * 文本框结束编辑
 */
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.password2Textfield == textField) {//第二个密码文本框
        if (![self.password2Textfield.text isEqualToString:self.passwork1Textfield.text]) {
            
            [MBProgressHUD showError:@"两次输入的密码不相同"];
            
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}


/**
 * 限制输入文本框的长度
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.phoneNumber == textField)  //手机号
    {
        if ([toBeString length] > PHONENUMBERLENGTH) { //如果输入框内容大于11则弹出警告
            self.phoneNumber.text = [toBeString substringToIndex:PHONENUMBERLENGTH];
            
            return NO;
        }
        
    }else if(self.verificationTextfiled == textField)  //车架号判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > VERIFICATIONCODELENGTH) { //如果输入框内容大于20则弹出警告
            self.verificationTextfiled.text = [toBeString substringToIndex:VERIFICATIONCODELENGTH];
            return NO;
        }
    }
    
    return YES;
}
@end
