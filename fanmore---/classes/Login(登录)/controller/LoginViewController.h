//
//  LoginViewController.h
//  fanmore---
//
//  Created by lhb on 15/5/22.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LoginViewDelegate <NSObject>

@optional
- (void) LoginViewDelegate:(int)PushType;

@end
@interface LoginViewController : UIViewController

/**跳转到登入界面的类型*/
@property(nonatomic,assign) int loginType;
@property(nonatomic,strong) id<LoginViewDelegate>delegate;

@end
