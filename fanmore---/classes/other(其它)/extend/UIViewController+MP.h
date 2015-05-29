//
//  UIViewController+MP.h
//  minipartner
//
//  Created by Cai Jiang on 1/30/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MP)

/**
 *  显示导航栏
 */
-(void)showNavigationBar;
/**
 *  隐藏导航栏
 */
-(void)hideNavigationBar;

/**
 *  无背影的导航条
 */
-(void)showNoshadowNavigationBar;
/**
 *  使用自定义的backImage
 *  增加手势返回
 */
-(void)greetingBack;

-(void)doBack;

/**
 *  在viewLoaded以后调用block
 *
 *  @param block <#block description#>
 */
-(void)invokeAfterViewLoaded:(void (^)(id obj))block;

/**
 *  导航至其他Controller
 *
 *  @param idid <#idid description#>
 *
 *  @return <#return value description#>
 */
-(UIViewController*)navigationTo:(NSString*)idid;

/**
 *  确定接收者是否由idid打开
 *
 *  @param idid <#idid description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)isNavigationBy:(NSString*)idid;



@end
