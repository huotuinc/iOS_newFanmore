//
//  JoinController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/1.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "JoinController.h"
#import "JoinNextController.h"
#import "userData.h"
#import "taskDetail.h"
#import "WebController.h"


@implementation JoinController

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
    CGFloat sizesss = CGRectGetMaxY(self.nextButton.frame) - (ScreenHeight - kbSize.height-44);
    
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


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}

- (void)_initFeildAndButton {
    self.field1.textAlignment = NSTextAlignmentCenter;
    self.field1.layer.borderColor = [UIColor redColor].CGColor;
    self.field1.layer.borderWidth = 5;
    self.field1.layer.cornerRadius = 5;
    
    self.field2.textAlignment = NSTextAlignmentCenter;
    self.field2.layer.borderColor = [UIColor redColor].CGColor;
    self.field2.layer.borderWidth = 5;
    self.field2.layer.cornerRadius = 5;
    
    self.nextButton.layer.borderColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000].CGColor;
    self.nextButton.layer.borderWidth = 5;
    self.nextButton.layer.cornerRadius = 5;
    
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.field1.placeholder =@"姓名";
    
    self.field2.placeholder = @"手机";
    [self _initFeildAndButton];
    
    //设置屏幕背景
    [self setviewBackimage];
    
    NSString *titleName = (self.questions.count>0&&self.questions.count==2)?@"提交":@"下一步";
    [self.nextButton setTitle:titleName forState:UIControlStateNormal];
    
    //报名选项设置
    [self setJoinName];
    
    //设置键盘
    [self registerForKeyboardNotifications];
//    [self.field1 becomeFirstResponder];
}

/**
 *  报名内容设置
 */
- (void)setJoinName{
    //初始化
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //1、保存个人信息
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData * userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    self.field2.text = userInfo.name;
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
/**
 *  设置屏幕的背景图片
 */
- (void)setviewBackimage{
    
    if (ScreenWidth == 375) {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dt7501334"]];
    }
    if (ScreenWidth == 414) {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dt12422208"]];
    }
    if (ScreenWidth == 320) {
        if (ScreenHeight <= 480) {
            self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dt640960"]];
        }else {
            self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dt6401136"]];
        }
    }
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    
    if (self.questions.count == 2 ) {
        
        if ([self.field1.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"用户名不能为空"];
            return;
        }
        /**正则表达式匹配*/
        taskDetail * task1 = self.questions[0];
        NSString *regex = task1.fieldPattern;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isValid = [predicate evaluateWithObject:self.field1.text];
        if (!isValid) {
            [MBProgressHUD showError:@"请输入正确的用户名"];
            return;
        }
        
        taskDetail * task2 =self.questions[1];
        NSString *regex2 = task2.fieldPattern;
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
        BOOL isValid2 = [predicate2 evaluateWithObject:self.field2.text];
        if (!isValid2) {
            [MBProgressHUD showError:@"请输入正确的联系方式"];
            return;
        }
        /**正则表达式匹配*/
        
        NSString * urlStr = [MainURL stringByAppendingPathComponent:@"answer"];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        
        params[@"taskId"] = @(self.taskId);
        params[@"answers"] = [NSString stringWithFormat:@"%d:%@|%d:%@",task1.qid,self.field1.text,task2.qid,self.field2.text];
        [UserLoginTool loginRequestGet:urlStr parame:params success:^(id json) {
            if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 56001)
            {
                [MBProgressHUD showError:@"账号在其它地方登入"];
                return;
            }
            if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1)
            {
                NSString * answerResultType = nil;
                if ([json[@"resultData"][@"illgel"] intValue] >0) {
                    answerResultType = @"rejected.html?";
                }else if ([json[@"resultData"][@"reward"] intValue] > 0){
                    answerResultType = @"success.html?";
                    
                }else {
                    answerResultType = @"failed.html?";
                }
                //adasdasdasd
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                WebController * show = [storyboard instantiateViewControllerWithIdentifier:@"WebController"];
                show.totleQuestion = self.questions.count;
                show.ritghtAnswer = 2;
                show.answerType = answerResultType;
                show.reward = [json[@"resultData"][@"chance"] intValue];
                show.chance = [json[@"resultData"][@"reward"] intValue];
                show.illgel = [json[@"resultData"][@"illgel"] intValue];
                [self.navigationController pushViewController:show animated:YES];
            }else{
                [self.navigationController  popToRootViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }else if(self.questions.count > 2){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JoinNextController *joinNext = [storyboard instantiateViewControllerWithIdentifier:@"JoinNextController"];
        [self.navigationController pushViewController:joinNext animated:YES];
    }
    
    
}
@end
