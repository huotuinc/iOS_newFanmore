//
//  UIViewController+FM.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/27.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "UIViewController+FM.h"

@implementation UIViewController (FM)

- (void)initBackAndTitle:(NSString *)title
{
    [self.navigationController setNavigationBarHidden:NO];
    

    self.navigationItem.title = title;
}

@end
