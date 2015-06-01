//
//  BoundPhoneViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  绑定手机

#import "BoundPhoneViewController.h"

@interface BoundPhoneViewController ()
/**绑定文字说明*/
@property (weak, nonatomic) IBOutlet UILabel *stateLable;
/**验证码*/
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

/**绑定手机号*/
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;


/**获取验证码*/
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
/**下一步*/
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

/**验证码按钮点击*/
- (IBAction)codeButton:(id)sender;
- (IBAction)nextButton:(id)sender;


@end

@implementation BoundPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"手机号绑定";
    //设置
    [self setupProperty];
    
}


- (void)setupProperty{
    
    self.stateLable.text = @"为了您在活动中成功领取流量,\n请添写验证码，完成手机绑定";
    self.nextStepButton.backgroundColor = LWColor(0, 150, 255);
}


/**
 *  获取验证码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)codeButton:(id)sender {
   
    //绑定手机号
    if ([NSString checkTel:self.phoneNumber.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
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
                [self.codeButton setTitle:@"验证码" forState:UIControlStateNormal];
                //                [captchaBtn setTitle:@"" forState:UIControlStateNormal];
                //                [captchaBtn setBackgroundImage:[UIImage imageNamed:@"resent_icon"] forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [self.codeButton setTitle:[NSString stringWithFormat:@"%@秒重新发送",strTime] forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
/**
 *  点击退下键盘
 *
 *  @param touches <#touches description#>
 *  @param event   <#event description#>
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)nextButton:(id)sender {
    NSLog(@"下部");
    if (self.phoneNumber.text == nil) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    if (self.codeTextField.text == nil) {
        
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = self.phoneNumber.text;
    params[@"authcode"] = self.codeTextField.text;
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"bandingmobile"];
    
    [UserLoginTool loginRequestPost:urlStr parame:params success:^(id json) {
       //绑定手机成功
        RootViewController * roots = [[RootViewController alloc] init];
        UIWindow * mainWindow = [UIApplication sharedApplication].keyWindow;
        mainWindow.rootViewController = roots;
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"绑定手机失败"];
    }];
    
}
@end
