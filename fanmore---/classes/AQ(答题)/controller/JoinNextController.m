//
//  JoinNextController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/19.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "JoinNextController.h"
#import "taskDetail.h"
#import "WebController.h"

@interface JoinNextController ()


@property(nonatomic,strong)taskDetail * task;
@end

@implementation JoinNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [self registerForKeyboardNotifications];
    
    [self.field becomeFirstResponder];
    
    [self.nextButton setTitle:((self.questions.count>1)?@"下一步":@"提交") forState:UIControlStateNormal];
    
    
    self.task =self.questions[0];
    [self.questions removeObjectAtIndex:0];
    self.field.placeholder = self.task.fieldName;
    
    
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
//    NSLog(@"%@",info);
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat sizesss = CGRectGetMaxY(self.nextButton.frame) - (ScreenHeight - kbSize.height);
    
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

- (void)_initFeildAndButton {
    self.field.layer.borderColor = [UIColor redColor].CGColor;
    self.field.layer.borderWidth = 5;
    self.field.layer.cornerRadius = 5;
    
    self.nextButton.layer.borderColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000].CGColor;
    self.nextButton.layer.borderWidth = 5;
    self.nextButton.layer.cornerRadius = 5;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self _initFeildAndButton];
    
}


- (IBAction)nextButtonAction:(UIButton *)sender {
    
    if (!self.questions.count) {
        NSString *regex2 = self.task.fieldPattern;
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
        BOOL isValid2 = [predicate2 evaluateWithObject:self.field.text];
        if (!isValid2) {
            [MBProgressHUD showError:self.task.fieldName];
            return;
        }
        self.answers = [NSMutableString stringWithFormat:@"%@:%d:%@",self.answers,self.task.qid,self.field.text];
        
        [self toUpdateanswer:self.answers];
        
    }else{
        
        self.task =self.questions[0];
        [self.questions removeObjectAtIndex:0];
        self.field.placeholder = self.task.fieldName;
        self.answers = [NSMutableString stringWithFormat:@"%@:%d:%@",self.answers,self.task.qid,self.field.text];
    }
}

- (void)toUpdateanswer:(NSMutableString *) ans{
    
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"answer"];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"taskId"] = @(self.taskId);
    params[@"answers"] = ans;
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
            show.flay = self.flay;
            show.taskId = self.taskId;
            [self.navigationController pushViewController:show animated:YES];
        }else{
            [self.navigationController  popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
@end
