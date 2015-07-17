//
//  AnswerController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/1.
//  Copyright (c) 2015年 HT. All rights reserved.
//  答题

#import "AnswerController.h"
#import "FinishController.h"
#import "taskDetail.h"  //详细题目
#import "answer.h"
#import <UIImageView+WebCache.h>
#import "UserLoginTool.h"
#import "detailViewController.h"
#include "WebController.h"
#import <AVFoundation/AVFoundation.h>

@interface AnswerController ()

/**答案*/
@property(nonatomic,strong)NSMutableString * ans;

//成功
@property(nonatomic,assign)SystemSoundID successSound;
//失败
@property(nonatomic,assign)SystemSoundID failureSound;

@end


@implementation AnswerController

static int _qindex = 0;
int _rightQuest = 0;  //纪录正确的答题数


- (SystemSoundID)successSound{
    
    if (!_successSound) {
        
        NSURL *url=[[NSBundle mainBundle] URLForResource:@"right.wav" withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_successSound);
    }
    
    return _successSound;
}

- (SystemSoundID)failureSound{
    
    if (_failureSound == 0) {
        
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"wrong.wav" withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_failureSound);
    }
    
    return _failureSound;
}



- (NSMutableString *)ans
{
    if (_ans == nil) {
        _ans = [[NSMutableString alloc] init];
        
    }
    return _ans;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.title = @"答题";
    _qindex = 0;
    _rightQuest = 0;
    self.qusImageView.contentMode = UIViewContentModeScaleAspectFit;  //图片自动适配
    
    if ([self.type intValue] == 3) { //画册类
        self.qusImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *aaa = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureClickToFindAnswer:)];
        [self.qusImageView addGestureRecognizer:aaa];
    }
    
    [self showQuestion];//设置题目第一次的题目
    
    
    [self _initBgViewAndImage];
    
    
}

- (void)_initBgViewAndImage
{
    if ([self.type intValue] == 3) {
        if (ScreenWidth == 375) {
            self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wailian7501334"]];
        }
        if (ScreenWidth == 414) {
            self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wailian12422208"]];
        }
        if (ScreenWidth == 320) {
            if (ScreenHeight <= 480) {
                self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wailian640960"]];
            }else {
                self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wailian6401136"]];
            }
        }
    }else{
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
    
    
}

- (void)_setBgImageWrong
{
    if (ScreenWidth == 375) {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dacuo7501334"]];
    }
    if (ScreenWidth == 414) {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dacuo12422208"]];
    }
    if (ScreenWidth == 320) {
        if (ScreenHeight <= 480) {
            self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dacuo640960"]];
        }else {
            self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dacuo6401136"]];
        }
    }
}

- (void)pictureClickToFindAnswer:(UITapGestureRecognizer *)tap{
    
   
    taskDetail * taskdetail = self.questions[_qindex];
    NSURL * picUrl = [NSURL URLWithString:taskdetail.relexUrl];
    [[UIApplication sharedApplication] openURL:picUrl];
}
/**
 *  题目展示
 */
- (void) showQuestion{
        //判断答题是否完成
    
        if (self.questions.count && _qindex==self.questions.count) {
            
            NSString * urlStr = [MainURL stringByAppendingPathComponent:@"answer"];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"taskId"] = @(self.taskId);
            params[@"answers"] = [self.ans substringToIndex:self.ans.length-1];
            [UserLoginTool loginRequestGet:urlStr parame:params success:^(id json) {
                if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
                    [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
                    UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                    [aaa show];
                    return ;
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
                    show.ritghtAnswer = _rightQuest;
                    show.answerType = answerResultType;
                    show.reward = [json[@"resultData"][@"reward"] floatValue];
                    show.chance = [json[@"resultData"][@"chance"] intValue];
                    show.illgel = [json[@"resultData"][@"illgel"] intValue];
                    show.flay = self.flay;
                    show.taskId = self.taskId;
                    CGFloat aabb = [json[@"resultData"][@"reward"] floatValue];
                    if (aabb > 0) {
                        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        
                        //1、保存全局信息
                        NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
                        userData *userinfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
                        userinfo.balance = [NSString stringWithFormat:@"%f",[userinfo.balance floatValue] + aabb];
                        [NSKeyedArchiver archiveRootObject:userinfo toFile:fileName];
                        
                    }
                    [self.navigationController pushViewController:show animated:YES];
                }else{
                    [self.navigationController  popToRootViewControllerAnimated:YES];
                }
                
                [MBProgressHUD hideHUD];
            } failure:^(NSError *error) {
               
                [MBProgressHUD hideHUD];
            }];
            
            
            return;
        }else {
            
            taskDetail * taskdetail = self.questions[_qindex];
            //拼接答案
            [self.ans appendString:[NSString stringWithFormat:@"%d:",taskdetail.qid]];
            self.tureAnswer = taskdetail.correntAid;
            //#warning 缺展位图片
            //1、答题图片
            
            //2、答案
            [self _initButton:taskdetail];
            //3、问题
            self.queLable.text = taskdetail.context;  //设置答题题目
            //4、设置题目编号
            self.queNumber.text = [NSString stringWithFormat:@"%d/%lu",_qindex+1,(unsigned long)self.questions.count];
            [self buttonOpenTouche];
        }
    
}

/**
 *  账号被顶掉
 *
 *  @param alertView   <#alertView description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    __weak AnswerController * wself = self;
    if (buttonIndex == 0) {
        
        LoginViewController * aa = [[LoginViewController alloc] init];
        UINavigationController * bb = [[UINavigationController alloc] initWithRootViewController:aa];
        [self presentViewController:bb animated:YES completion:^{
            
            [wself showQuestion];
        }];
    }else{
        
    }
}

/**
 *  答案展示按钮显示答案
 *
 *  @param taskDetail <#taskDetail description#>
 */
- (void)_initButton:(taskDetail *)taskDetail {
    
    NSArray *anArray = [taskDetail.answers sortedArrayUsingComparator:^NSComparisonResult(answer* obj1, answer* obj2) {
        int a = arc4random_uniform(2);
        if (a) {
            return [obj1.name compare:obj2.name];
        }else{
           return [obj2.name compare:obj1.name];
        }
    }];
    for (int index = 0;index<anArray.count;index++) {
        answer * aaaa = anArray[index];
        if (index == 0) {
            [self.AButton setTitle:aaaa.name forState:UIControlStateNormal];  //答案选项
            self.AButton.tag = aaaa.aid;  //设置答案编号
        }else if(index == 1){
            [self.BButton setTitle:aaaa.name forState:UIControlStateNormal];  //答案选项
            self.BButton.tag = aaaa.aid;
        }else if(index == 2){
            [self.CButton setTitle:aaaa.name forState:UIControlStateNormal];  //答案选项
            self.CButton.tag = aaaa.aid;
        }else if(index == 3){
            [self.DButton setTitle:aaaa.name forState:UIControlStateNormal];  //答案选项
            self.DButton.tag = aaaa.aid;
        }
    }
    [self.AButton setBackgroundImage:[UIImage imageNamed:@"A"] forState:UIControlStateNormal];
    [self.BButton setBackgroundImage:[UIImage imageNamed:@"B"] forState:UIControlStateNormal];
    [self.CButton setBackgroundImage:[UIImage imageNamed:@"C"] forState:UIControlStateNormal];
    [self.DButton setBackgroundImage:[UIImage imageNamed:@"D"] forState:UIControlStateNormal];
    
}

- (void)showTureAnswer {
    
    if (self.tureAnswer == self.AButton.tag) {
        [self.AButton setBackgroundImage:[UIImage imageNamed:@"A_d"] forState:UIControlStateNormal];
    }
    if (self.tureAnswer == self.BButton.tag) {
        [self.BButton setBackgroundImage:[UIImage imageNamed:@"B_d"] forState:UIControlStateNormal];
    }
    if (self.tureAnswer == self.CButton.tag) {
        [self.CButton setBackgroundImage:[UIImage imageNamed:@"C_d"] forState:UIControlStateNormal];
    }
    if (self.tureAnswer ==self.DButton.tag) {
        [self.DButton setBackgroundImage:[UIImage imageNamed:@"D_d"] forState:UIControlStateNormal];
    }
}
/**
 *  关闭按钮点击事件
 */
- (void)buttonCloseTouch {
    self.AButton.userInteractionEnabled = NO;
    self.BButton.userInteractionEnabled = NO;
    self.CButton.userInteractionEnabled = NO;
    self.DButton.userInteractionEnabled = NO;
}
/**
 *  开启按钮点击事件
 */
- (void)buttonOpenTouche {
    self.AButton.userInteractionEnabled = YES;
    self.BButton.userInteractionEnabled = YES;
    self.CButton.userInteractionEnabled = YES;
    self.DButton.userInteractionEnabled = YES;
}

/**
 *  选答案
 *
 */
- (IBAction)AAction:(UIButton *)sender {
    [self.ans appendString:[NSString stringWithFormat:@"%ld|",(long)sender.tag]];
    _qindex++;
    
    [self buttonCloseTouch];
    
    if (sender.tag == self.tureAnswer) {
        [self showTureAnswer];
         AudioServicesPlayAlertSound(self.successSound);
        _rightQuest++;
    }else {
        [self showTureAnswer];
        AudioServicesPlayAlertSound(self.failureSound);
        [self _setBgImageWrong];
        [sender setBackgroundImage:[UIImage imageNamed:@"A_c"] forState:UIControlStateNormal];
    }
    //显示下一题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showQuestion];
        [self _initBgViewAndImage];
    });
}
- (IBAction)BAction:(UIButton *)sender {
     _qindex++;
    [self.ans appendString:[NSString stringWithFormat:@"%ld|",(long)sender.tag]];
    
    [self buttonCloseTouch];
    
    if (sender.tag == self.tureAnswer) {
        [self showTureAnswer];
        AudioServicesPlayAlertSound(self.successSound);
        _rightQuest++;

    }else {
        [self showTureAnswer];
        AudioServicesPlayAlertSound(self.failureSound);
        [self _setBgImageWrong];
        [self.BButton setBackgroundImage:[UIImage imageNamed:@"B_c"] forState:UIControlStateNormal];
    }
    //显示下一题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showQuestion];
        [self _initBgViewAndImage];
    });
  
}
- (IBAction)CAction:(UIButton *)sender {
     _qindex++;
   [self.ans appendString:[NSString stringWithFormat:@"%ld|",(long)sender.tag]];
    
    [self buttonCloseTouch];
    
    if (sender.tag == self.tureAnswer) {
        [self showTureAnswer];
        AudioServicesPlayAlertSound(self.successSound);
        _rightQuest++;

    }else {
        [self showTureAnswer];
        AudioServicesPlayAlertSound(self.failureSound);
        [self _setBgImageWrong];
        [self.CButton setBackgroundImage:[UIImage imageNamed:@"C_c"] forState:UIControlStateNormal];

    }
    //显示下一题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showQuestion];
        [self _initBgViewAndImage];
    });
}
- (IBAction)DAction:(UIButton *)sender {
     _qindex++;
    [self.ans appendString:[NSString stringWithFormat:@"%ld|",(long)sender.tag]];
    
    [self buttonCloseTouch];
    
    if (self.DButton.tag == self.tureAnswer) {
        [self showTureAnswer];
        AudioServicesPlayAlertSound(self.successSound);
        _rightQuest++;
    }else {
        [self showTureAnswer];
        AudioServicesPlayAlertSound(self.failureSound);
        [self _setBgImageWrong];
        [self.DButton setBackgroundImage:[UIImage imageNamed:@"D_c"] forState:UIControlStateNormal];
    }
    //显示下一题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showQuestion];
        [self _initBgViewAndImage];
    });
}

@end
