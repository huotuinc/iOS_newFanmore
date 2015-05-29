//
//  UserRegisterViewController.h
//  fanmore---
//
//  Created by lhb on 15/5/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//  用户注册

#import <UIKit/UIKit.h>


@protocol UserRegisterViewDelegate <NSObject>

@optional
- (void)UserRegisterViewSuccess;
@end
@interface UserRegisterViewController : UIViewController

@property(nonatomic,weak) id delegate;

@end
