//
//  BuyFlowViewController.h
//  fanmore---
//
//  Created by lhb on 15/6/3.
//  Copyright (c) 2015年 HT. All rights reserved.
//  购买流量

#import <UIKit/UIKit.h>


@protocol BuyFlowViewControllerDelegate <NSObject>

@optional
/**兑换流量成功*/
- (void)successExchange:(NSString* ) userBalance;
@end

@interface BuyFlowViewController : UIViewController

@property(nonatomic,weak) id<BuyFlowViewControllerDelegate> delegate;

@end
