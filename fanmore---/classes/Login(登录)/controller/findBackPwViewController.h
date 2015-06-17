//
//  findBackPwViewController.h
//  fanmore---
//
//  Created by lhb on 15/5/22.
//  Copyright (c) 2015年 HT. All rights reserved.
//  找回密码

#import <UIKit/UIKit.h>


@protocol findBackPwViewDelegate <NSObject>

/**忘记*/
- (void) findBackPassWordScuess;   //找回密码成功
@optional

@end

@interface findBackPwViewController : UIViewController

@property(nonatomic,weak) id delegate;

@end
