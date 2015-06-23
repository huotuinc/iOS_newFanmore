//
//  JoinController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/1.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "JoinController.h"
#import "JoinNextController.h"

@implementation JoinController



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    
    
}

- (void)_initFeildAndButton {
    self.field1.layer.borderColor = [UIColor redColor].CGColor;
    self.field1.layer.borderWidth = 5;
    self.field1.layer.cornerRadius = 5;
    
    self.field2.layer.borderColor = [UIColor redColor].CGColor;
    self.field2.layer.borderWidth = 5;
    self.field2.layer.cornerRadius = 5;
    
    self.nextButton.layer.borderColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000].CGColor;
    self.nextButton.layer.borderWidth = 5;
    self.nextButton.layer.cornerRadius = 5;
    
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self _initFeildAndButton];
    
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

- (IBAction)nextButtonAction:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JoinNextController *joinNext = [storyboard instantiateViewControllerWithIdentifier:@"JoinNextController"];
    [self.navigationController pushViewController:joinNext animated:YES];
    
}
@end
