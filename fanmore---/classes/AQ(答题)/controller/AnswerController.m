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
    
    
}

- (IBAction)AAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FinishController *finish = [storyboard instantiateViewControllerWithIdentifier:@"FinishController"];
    [self.navigationController pushViewController:finish animated:YES];
    
}
- (IBAction)BAction:(id)sender {
}
- (IBAction)CAction:(id)sender {
}
- (IBAction)DAction:(id)sender {
}

@end
