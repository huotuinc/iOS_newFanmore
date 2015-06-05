//
//  BoundPhoneViewController.h
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  绑定手机

#import <UIKit/UIKit.h>

@protocol BoundPhoneViewControllerDelegate <NSObject>

@optional

- (void)BoundPhoneViewControllerToBoundPhoneNumber;
@end


@interface BoundPhoneViewController : UIViewController


@property(nonatomic,weak) id<BoundPhoneViewControllerDelegate> delegate;
@end
