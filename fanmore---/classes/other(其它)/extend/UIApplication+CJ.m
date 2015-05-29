//
//  UIApplication+CJ.m
//  minipartner
//
//  Created by Cai Jiang on 1/13/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "UIApplication+CJ.h"

@implementation UIApplication (CJ)

-(double)iosVersion{
    return [[UIDevice currentDevice].systemVersion doubleValue];
}

@end
