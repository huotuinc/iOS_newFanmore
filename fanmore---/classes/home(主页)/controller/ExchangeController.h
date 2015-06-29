//
//  ExchangeController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/23.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ExchangeControllerdelegate <NSObject>

@optional
/**兑换流量成功*/
- (void)successExchange:(NSString* ) userBalance;

@end


@interface ExchangeController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSArray * flays;


@property(nonatomic,weak) id<ExchangeControllerdelegate> delegate;

@end
