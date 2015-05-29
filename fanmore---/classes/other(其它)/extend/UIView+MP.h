//
//  UIView+MP.h
//  minipartner
//
//  Created by Cai Jiang on 1/30/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (MP)

/**
 *  修改AutoLayout约束 成为最大宽度
 */
-(void)makeMaxWidth;

/**
 *  用标准色作为背景色
 */
-(void)backgroundAsMainColor;


/**
 *  摇一摇
 */
-(void)shake;

-(void)shake:(CGFloat)range duration:(CFTimeInterval)duration count:(float)count;

/**
 *  显示警告
 *
 *  @param msg <#msg description#>
 *
 *  @return <#return value description#>
 */
-(MBProgressHUD*)alertMessage:(NSString*)msg;


/**
 *  显示警告
 *
 *  @param msg   <#msg description#>
 *  @param block 警告完成后调用
 *
 *  @return <#return value description#>
 */
-(MBProgressHUD*)alertMessage:(NSString*)msg block:(void (^)())block;

/**
 *  在Reciver中 返回 view下方所有空间
 *
 *  @param view <#view description#>
 *
 *  @return <#return value description#>
 */
-(CGRect)underView:(UIView*)view;


/**
 *  获取特定对象特定属性的约束 可能是first也可能是second
 *
 *  @param item      <#item description#>
 *  @param attribute <#attribute description#>
 *
 *  @return <#return value description#>
 */
-(NSLayoutConstraint*)constraintFor:(id)item attribute:(NSLayoutAttribute)attribute;

/**
 *  获取特定属性的约束 可能是first也可能是second
 *
 *  @param attribute <#attribute description#>
 *
 *  @return <#return value description#>
 */
-(NSLayoutConstraint*)constraintFor:(NSLayoutAttribute)attribute;

/**
 *  使之成为遮罩
 *  接收者并不是真的在被点击以后移除 只是隐藏在幕后
 *
 *  @param block 遮罩被移除后 将执行的代码;如果为空 将直接移除遮罩
 */
-(void)beMask:(void(^)())block;

/**
 *  移除本view建立的遮罩
 */
-(void)stopMask;

@end
