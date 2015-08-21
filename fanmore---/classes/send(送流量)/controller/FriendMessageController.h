//
//  FriendMessageController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/17.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol FriendMessageControllerDelegate <NSObject>
@optional
/**兑换流量成功*/
- (void)successExchange:(NSString* ) userBalance;
@end


@interface FriendMessageController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property(nonatomic,weak) id<FriendMessageControllerDelegate> delegate;
-(void)getNewMoreData;
@end
