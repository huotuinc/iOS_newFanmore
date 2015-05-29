//
//  UIImage+MP.m
//  minipartner
//
//  Created by Cai Jiang on 1/30/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "UIImage+MP.h"

@implementation UIImage (MP)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(UIImage*)squareImage2{
    CGFloat min = fminf(self.size.width, self.size.height);
    
    return [self imageInRect:CGRectMake((self.size.width-min)/2, (self.size.height-min)/2, min, min)];
}

-(UIImage*)scale:(CGFloat)width{
    if (self.size.width<width || self.size.height<width) {
        return self;
    }else{
        //
        CGSize size;
        if (self.size.width>self.size.height) {
            // h as width
            // w/h
            
            // w as width
            // h/w
            size = CGSizeMake(self.size.width*width/self.size.height, width);
        }else{
            size = CGSizeMake(width, self.size.height*width/self.size.width);
        }
//        return [self imageInRect:CGRectMake(0, 0, size.width, size.height)];

        UIGraphicsBeginImageContext(size);
        // 绘制改变大小的图片
        [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
        // 从当前context中创建一个改变大小后的图片
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        return scaledImage;
    }
}

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
- (UIImage *)imageInRect:(CGRect)rect {
//    CGImageRef sourceImageRef = [self CGImage];
//    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//    CFRelease(newImageRef);
//    return newImage;
    double (^rad)(double) = ^(double deg) {
        return deg / 180.0 * M_PI;
    };
    
    CGAffineTransform rectTransform;
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -self.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -self.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -self.size.width, -self.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, self.scale, self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectApplyAffineTransform(rect, rectTransform));
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return result;
}

-(NSData*)imageData{
    NSData *data;
    if (UIImagePNGRepresentation(self) == nil) {
        
        data = UIImageJPEGRepresentation(self, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(self);
    }
    return data;
}

-(NSString*)base64{
    return [[self imageData] base64EncodedStringWithOptions:0];
}

static UIImage* __my__empty__Image;

+(UIImage*)emptyImage{
    if (!__my__empty__Image) {
        __my__empty__Image = [UIImage imageNamed:@"empty_photo"];
    }
    return __my__empty__Image;
}


+(UIImage*)launchImage{
    // 是否显示广告图？
    // 否的话
    UIScreen* screen = [UIScreen mainScreen];
    CGSize size = screen.bounds.size;
    // 480 3.5
    // 1024 pad?
    // other is 4
    LOG(@"screen height:%f",size.height);
    if(size.height==480){
        return [UIImage imageNamed:@"LaunchImage-35"];
    }else if(size.height==1024){
        return [UIImage imageNamed:@"LaunchImage-other"];
    }else{
        return [UIImage imageNamed:@"LaunchImage-4"];
    }
}

-(UIImage*)interceptTruncatingTail:(CGSize)size{
    // 被截取的必须是self 唯一需要考虑的是截取哪个方向
    // 首先确定哪个是长板 从这里入手
    CGSize newSize;
    if (self.size.width/self.size.height>size.width/size.height){
        // 截取多余的width
        CGFloat width = size.width*self.size.height/size.height;
        newSize = CGSizeMake(width, self.size.height);
    }else{
        CGFloat height = size.height*self.size.width/size.width;
        newSize = CGSizeMake(self.size.width, height);
    }
    
    return [self imageInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
}


@end
