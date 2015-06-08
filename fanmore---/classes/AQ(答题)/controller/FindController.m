//
//  FindController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/1.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "FindController.h"


@interface FindController ()

@end


@implementation FindController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self _initButtons];
    
}

- (void)_initButtons{
    self.AButton.layer.cornerRadius = 2;
    self.AButton.layer.borderWidth = 1;
    self.AButton.layer.borderColor = [UIColor colorWithWhite:0.835 alpha:1.000].CGColor;
    
    self.BButton.layer.cornerRadius = 2;
    self.BButton.layer.borderWidth = 1;
    self.BButton.layer.borderColor = [UIColor colorWithWhite:0.835 alpha:1.000].CGColor;
    
    self.CButton.layer.cornerRadius = 2;
    self.CButton.layer.borderWidth = 1;
    self.CButton.layer.borderColor = [UIColor colorWithWhite:0.835 alpha:1.000].CGColor;
    
    self.DButton.layer.cornerRadius = 2;
    self.DButton.layer.borderWidth = 1;
    self.DButton.layer.borderColor = [UIColor colorWithWhite:0.835 alpha:1.000].CGColor;
}

@end
