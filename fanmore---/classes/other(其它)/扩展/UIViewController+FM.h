//
//  UIViewController+FM.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/27.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FM)

- (void)initBackAndTitle:(NSString *)title;

- (void)saveControllerToAppDelegate:(UIViewController *)controller;

@end
