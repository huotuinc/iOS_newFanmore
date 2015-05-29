//
//  UIAlertView+CJ.m
//  minipartner
//
//  Created by Cai Jiang on 4/23/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "UIAlertView+CJ.h"

@implementation UIAlertView (CJ)

//+(instancetype)cj_showSimpleAlertView:(NSString *)title message:(NSString *)message style:(UIAlertViewStyle)style init:(void (^)(UIAlertView *))init doner:(void (^)(UIAlertView *))doner{
//    UIAlertView* obj = [[self alloc] bk_initWithTitle:title message:message];
//    __weak UIAlertView* wobj = obj;
//    obj.alertViewStyle = UIAlertViewStylePlainTextInput;
//    if (init) {
//        init(obj);
//    }
//    [obj bk_setCancelButtonWithTitle:@"取消" handler:NULL];
//    [obj bk_addButtonWithTitle:@"确定" handler:^{
//        if (doner) {
//            doner(wobj);
//        }
//    }];
//    [obj show];
//    return obj;
//}

@end
