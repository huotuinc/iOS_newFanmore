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
- (IBAction)codeButton:(id)sender {
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)nextButton:(id)sender {
    NSLog(@"下部");
    
    RootViewController * roots = [[RootViewController alloc] init];
    UIWindow * mainWindow = [UIApplication sharedApplication].keyWindow;
    mainWindow.rootViewController = roots;
}
@end
