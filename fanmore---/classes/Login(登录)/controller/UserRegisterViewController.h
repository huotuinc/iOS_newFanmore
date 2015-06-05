//
//  UserRegisterViewController.h
//  fanmore---
//
//  Created by lhb on 15/5/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//  用户注册

#import <UIKit/UIKit.h>

@class userData;

@protocol UserRegisterViewDelegate <NSObject>

@optional
/**用户注册成功*/
- (void)UserRegisterViewSuccess:(userData *) userInfo;

@end

@interface UserRegisterViewController : UIViewController

@property(nonatomic,weak) id<UserRegisterViewDelegate> delegate;

@end
