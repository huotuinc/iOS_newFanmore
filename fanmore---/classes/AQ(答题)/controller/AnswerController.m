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
@interface AnswerController ()

/**答案*/
@property(nonatomic,strong)NSMutableString * ans;
@end


@implementation AnswerController

static int _qindex = 0;


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
    self.qusImageView.contentMode = UIViewContentModeScaleAspectFit;  //图片自动适配
    
    [self showQuestion];//设置题目第一次的题目

    
}


/**
 *  题目展示
 */
- (void) showQuestion{
    
    
        //判断答题是否完成
        if (_qindex==self.questions.count) {
            
            NSString * urlStr = [MainURL stringByAppendingPathComponent:@"answer"];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"taskId"] = @(self.taskId);
            NSLog(@"dadasdasdasdasdxxx0000000 %@",self.ans);
            params[@"answers"] = [self.ans substringToIndex:self.ans.length-1];
            [UserLoginTool loginRequestGet:urlStr parame:params success:^(id json) {
                
                [MBProgressHUD showMessage:json[@"resultDescription"]];
                NSLog(@"%@",json);
                [MBProgressHUD hideHUD];
            } failure:^(NSError *error) {
                NSLog(@"%@",[error description]);
                [MBProgressHUD hideHUD];
            }];
            
            [self.navigationController  popToRootViewControllerAnimated:YES];
            return;
        }
        taskDetail * taskdetail = self.questions[_qindex];
        //拼接答案
        [self.ans appendString:[NSString stringWithFormat:@"%d:",taskdetail.qid]];
        self.tureAnswer = taskdetail.correntAid;
#warning 缺展位图片
        //1、答题图片
        [self.qusImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:taskdetail.imageUrl] andPlaceholderImage:[UIImage imageNamed:@"mrtou_h"] options:SDWebImageRetryFailed|SDWebImageDelayPlaceholder progress:nil completed:nil];
        //2、答案
        [self _initButton:taskdetail];
        //3、问题
        self.queLable.text = taskdetail.context;  //设置答题题目
        //4、设置题目编号
        self.queNumber.text = [NSString stringWithFormat:@"%d/%lu",++_qindex,(unsigned long)self.questions.count];
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
 *  选答案
 *
 */
- (IBAction)AAction:(UIButton *)sender {
    [self.ans appendString:[NSString stringWithFormat:@"%ld|",(long)sender.tag]];
    
    if (sender.tag == self.tureAnswer) {
        [self showTureAnswer];

    }else {
        [self showTureAnswer];
        [sender setBackgroundImage:[UIImage imageNamed:@"A_c"] forState:UIControlStateNormal];
    }
    //显示下一题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showQuestion];
    });
}
- (IBAction)BAction:(UIButton *)sender {
    [self.ans appendString:[NSString stringWithFormat:@"%ld|",(long)sender.tag]];
    if (sender.tag == self.tureAnswer) {
        [self showTureAnswer];

    }else {
        [self showTureAnswer];
        [self.BButton setBackgroundImage:[UIImage imageNamed:@"B_c"] forState:UIControlStateNormal];
    }
    //显示下一题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showQuestion];
    });
  
}
- (IBAction)CAction:(UIButton *)sender {
   [self.ans appendString:[NSString stringWithFormat:@"%ld|",(long)sender.tag]];
    if (sender.tag == self.tureAnswer) {
        [self showTureAnswer];

    }else {
        [self showTureAnswer];
        [self.CButton setBackgroundImage:[UIImage imageNamed:@"C_c"] forState:UIControlStateNormal];

    }
    //显示下一题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showQuestion];
    });
}
- (IBAction)DAction:(UIButton *)sender {
    [self.ans appendString:[NSString stringWithFormat:@"%ld|",(long)sender.tag]];
    if (self.DButton.tag == self.tureAnswer) {
        [self showTureAnswer];
    }else {
        [self showTureAnswer];
        [self.DButton setBackgroundImage:[UIImage imageNamed:@"D_c"] forState:UIControlStateNormal];
    }
    //显示下一题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showQuestion];
    });
}

@end
