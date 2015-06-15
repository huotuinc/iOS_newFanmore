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


@interface AnswerController ()
/**定时器*/
@property(nonatomic,strong)NSTimer * timer;
@end


@implementation AnswerController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.title = @"答题";

    NSTimer * dstime = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(showQuestion) userInfo:nil repeats:YES];
    self.timer = dstime;
    [dstime fire];
}


- (void) showQuestion{
    
    static int qindex = 0;
    if (qindex<self.questions.count) {
        
       taskDetail * taskdetail = self.questions[qindex];
        [self.qusImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:taskdetail.imageUrl] andPlaceholderImage:nil options:SDWebImageRetryFailed|SDWebImageDelayPlaceholder progress:nil completed:nil];
        [self _initButton:taskdetail];
        
        qindex++;
    }else{
        
      [self.timer invalidate];
        self.timer = nil;
    }
    NSLog(@"题目开始展示");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)_initButton:(taskDetail *)taskDetail {
    
    
    NSArray *anArray = [taskDetail.answers sortedArrayUsingComparator:^NSComparisonResult(answer* obj1, answer* obj2) {
        
        int a = arc4random_uniform(2);
        if (a) {
            return [obj1.name compare:obj2.name];
           
        }else{
           return [obj2.name compare:obj1.name];
            
        }
    }];
    
    [anArray enumerateObjectsUsingBlock:^(answer* obj, NSUInteger idx, BOOL *stop) {
       
        NSLog(@"-----%@",obj.name);
    }];
    for (int index = 0;index<anArray.count;index++) {
        answer * aaaa = anArray[index];
        if (index == 0) {
            [self.AButton setTitle:aaaa.name forState:UIControlStateNormal];  //答案选项
        }else if(index == 1){
            [self.BButton setTitle:aaaa.name forState:UIControlStateNormal];  //答案选项
        }else if(index == 2){
            [self.CButton setTitle:aaaa.name forState:UIControlStateNormal];  //答案选项
        }else if(index == 3){
            [self.DButton setTitle:aaaa.name forState:UIControlStateNormal];  //答案选项
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
    if (self.tureAnswer == self.DButton.tag) {
        [self.DButton setBackgroundImage:[UIImage imageNamed:@"D_d"] forState:UIControlStateNormal];
    }
}



- (IBAction)AAction:(id)sender {
    
    
    if (self.AButton.tag == self.tureAnswer) {
        [self showTureAnswer];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FinishController *finish = [storyboard instantiateViewControllerWithIdentifier:@"FinishController"];
            [self.navigationController pushViewController:finish animated:YES];
        });
    }else {
        [self showTureAnswer];
        [self.AButton setBackgroundImage:[UIImage imageNamed:@"A_c"] forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FinishController *finish = [storyboard instantiateViewControllerWithIdentifier:@"FinishController"];
            [self.navigationController pushViewController:finish animated:YES];
        });
    }
    
    
    
    
}
- (IBAction)BAction:(id)sender {
    
    if (self.BButton.tag == self.tureAnswer) {
        [self showTureAnswer];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];   
            JoinController *joinVc = [storyboard instantiateViewControllerWithIdentifier:@"JoinController"];
            [self.navigationController pushViewController:joinVc animated:YES];
        });
    }else {
        [self showTureAnswer];
        [self.BButton setBackgroundImage:[UIImage imageNamed:@"B_c"] forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            JoinController *joinVc = [storyboard instantiateViewControllerWithIdentifier:@"JoinController"];
            [self.navigationController pushViewController:joinVc animated:YES];
        });
    }
    
    
  
}
- (IBAction)CAction:(id)sender {
    
    
    
}
- (IBAction)DAction:(id)sender {
    
    [UIView animateWithDuration:2 animations:^{
        [self.DButton setBackgroundImage:[UIImage imageNamed:@"D_c"] forState:UIControlStateNormal];
        [self.AButton setBackgroundImage:[UIImage imageNamed:@"A_d"] forState:UIControlStateNormal];
    }];
    
}

@end
