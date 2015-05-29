//
//  UIAlertView+CJ.h
//  minipartner
//
//  Created by Cai Jiang on 4/23/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (CJ)

/**
 *  一个简单的Alert模型
 *
 *  @param title   <#title description#>
 *  @param message <#message description#>
 *  @param style   <#style description#>
 *  @param init    展示之前对view的操作block可NULL
 *  @param doner   确定之后对view的操作block可NULL
 *
 *  @return <#return value description#>
 */
+(instancetype)cj_showSimpleAlertView:(NSString*)title message:(NSString*)message style:(UIAlertViewStyle)style init:(void (^)(UIAlertView* view))init doner:(void (^)(UIAlertView* view))doner;

@end
