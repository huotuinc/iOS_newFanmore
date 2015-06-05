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
    
    self.AButton.layer.cornerRadius = 2;
    self.AButton.layer.borderWidth = 1;
    self.AButton.layer.borderColor = [UIColor colorWithWhite:0.835 alpha:1.000].CGColor;
    
}

- (IBAction)AAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FinishController *finish = [storyboard instantiateViewControllerWithIdentifier:@"FinishController"];
    [self.navigationController pushViewController:finish animated:YES];
    
}
- (IBAction)BAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  
    JoinController *joinVc = [storyboard instantiateViewControllerWithIdentifier:@"JoinController"];
    [self.navigationController pushViewController:joinVc animated:YES];
  
}
- (IBAction)CAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FindController *findVc = [storyboard instantiateViewControllerWithIdentifier:@"FindController"];
    [self.navigationController pushViewController:findVc animated:YES];
}
- (IBAction)DAction:(id)sender {
}

@end
