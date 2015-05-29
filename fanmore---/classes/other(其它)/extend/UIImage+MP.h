//
//  UIImage+MP.h
//  minipartner
//
//  Created by Cai Jiang on 1/30/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MP)

/**
*  截取如果图片比size大 则截除 右侧 或者下方
*
*  @param size <#size description#>
*
*  @return <#return value description#>
*/
-(UIImage*)interceptTruncatingTail:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  截取正方形
 *
 *  @return <#return value description#>
 */
-(UIImage*)squareImage2;

-(NSString*)base64;

/**
 *  尝试缩放到大致范畴
 *
 *  @param width <#width description#>
 *
 *  @return <#return value description#>
 */
-(UIImage*)scale:(CGFloat)width;

/**
 *  显示一张缺失图片
 *
 *  @return <#return value description#>
 */
+(UIImage*)emptyImage;

/**
 *  开机图片
 *
 *  @return <#return value description#>
 */
+(UIImage*)launchImage;

@end
