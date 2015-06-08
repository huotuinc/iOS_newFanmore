//
//  FeedBackViewController.m
//  fanmore---
//
//  Created by lhb on 15/6/5.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "FeedBackViewController.h"


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
    
    
}
@end
