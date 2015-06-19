//
//  JoinNextController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/19.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "JoinNextController.h"

@interface JoinNextController ()

@end

@implementation JoinNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (ScreenWidth == 375) {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"7501334"]];
    }
    if (ScreenWidth == 414) {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"12422208"]];
    }
    if (ScreenWidth == 320) {
        if (ScreenHeight <= 480) {
            self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"640960"]];
        }else {
            self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"6401136"]];
        }
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextButtonAction:(UIButton *)sender {
}
@end
