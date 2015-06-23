//
//  HobbyController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/9.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol HobbyControllerDelegate <NSObject>

@optional
/**
 *  选择爱好
 *
 *  @param parame <#parame description#>
 *  @param option <#option description#>
 */
- (void)pickOVerhobby:(NSString *)parame andOption:(NSString *)option;
@end

@interface HobbyController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//用户的爱好勾选
@property (strong, nonatomic) NSString *userHobby;

@property(nonatomic,strong)id <HobbyControllerDelegate> delegate;
@end
