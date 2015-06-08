//
//  AnswerController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/1.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "AnswerController.h"
#import "FinishController.h"

@implementation AnswerController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
//    [self _initButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)_initButton {
    
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
        [self.AButton setBackgroundImage:[UIImage imageNamed:@"C_d"] forState:UIControlStateNormal];
    }
    if (self.tureAnswer == self.DButton.tag) {
        [self.AButton setBackgroundImage:[UIImage imageNamed:@"D_d"] forState:UIControlStateNormal];
    }
}



- (IBAction)AAction:(id)sender {
    
    
    if (self.AButton.tag == self.tureAnswer) {
        [self showTureAnswer];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FinishController *finish = [storyboard instantiateViewControllerWithIdentifier:@"FinishController"];
            [self.navigationController pushViewController:finish animated:YES];
        });
    }else {
        [self showTureAnswer];
        [self.AButton setBackgroundImage:[UIImage imageNamed:@"A_c"] forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FinishController *finish = [storyboard instantiateViewControllerWithIdentifier:@"FinishController"];
            [self.navigationController pushViewController:finish animated:YES];
        });
    }
    
    
    
    
}
- (IBAction)BAction:(id)sender {
    
    if (self.BButton.tag == self.tureAnswer) {
        [self showTureAnswer];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];   
            JoinController *joinVc = [storyboard instantiateViewControllerWithIdentifier:@"JoinController"];
            [self.navigationController pushViewController:joinVc animated:YES];
        });
    }else {
        [self showTureAnswer];
        [self.BButton setBackgroundImage:[UIImage imageNamed:@"B_c"] forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            JoinController *joinVc = [storyboard instantiateViewControllerWithIdentifier:@"JoinController"];
            [self.navigationController pushViewController:joinVc animated:YES];
        });
    }
    
    
  
}
- (IBAction)CAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FindController *findVc = [storyboard instantiateViewControllerWithIdentifier:@"FindController"];
    [self.navigationController pushViewController:findVc animated:YES];
}
- (IBAction)DAction:(id)sender {
    
    [UIView animateWithDuration:2 animations:^{
        [self.DButton setBackgroundImage:[UIImage imageNamed:@"D_c"] forState:UIControlStateNormal];
        [self.AButton setBackgroundImage:[UIImage imageNamed:@"A_d"] forState:UIControlStateNormal];
    }];
    
}

@end
