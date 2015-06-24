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
