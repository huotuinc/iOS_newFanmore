//
//  FeedBackViewController.m
//  fanmore---
//
//  Created by lhb on 15/6/5.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "FeedBackViewController.h"
#import "userData.h"


@interface FeedBackViewController ()<UITextViewDelegate>

/**按钮*/
@property (weak, nonatomic) IBOutlet UIButton *feedBackButton;

@property (weak, nonatomic) IBOutlet UITextView *feedBackTextView;
- (IBAction)FeedBackButton:(id)sender;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置边框：
    [self setupstatus];
}

- (void) setupstatus{
    //设置边框：
    self.feedBackTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.feedBackTextView.layer.borderWidth =0.5;
    self.feedBackTextView.layer.cornerRadius =1.0;
    self.feedBackTextView.contentInset = UIEdgeInsetsZero;
    self.feedBackTextView.delegate = self;
    self.feedBackTextView.backgroundColor = [UIColor colorWithWhite:0.951 alpha:1.000];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    textView.text = @"";
}

- (IBAction)FeedBackButton:(id)sender {
    NSLog(@"xxxxxxxxxxxxxxxxx");
    if ([self.feedBackTextView.text isEqualToString:@"请输入你的宝贵意见"]) {
        
        [MBProgressHUD showError:@"请输入你的反馈意见"];
        return;
    }
    //初始化
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //1、保存个人信息
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData * userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    //1、接口
    NSString *urlStr = [MainURL stringByAppendingPathComponent:@"feedback"];
    
    //2、参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = userInfo.name;
    params[@"contact"] = userInfo.mobile;
    params[@"content"] = self.feedBackTextView.text;
    
    [UserLoginTool loginRequestPost:urlStr parame:params success:^(id json) {
        
        NSLog(@"sdasd%@",json);
//        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
//            
//            [MBProgressHUD sh]
//        }
        
    } failure:^(NSError *error) {
        NSLog(@"意见反馈出错");
    }];
}
@end
