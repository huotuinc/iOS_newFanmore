//
//  MJSettingLabelItem.m
//  00-ItcastLottery
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJSettingLabelItem.h"

@implementation MJSettingLabelItem


+ (instancetype)itemWithTitle:(NSString *)title rightTitle:(NSString *) rightTitle{
    
    MJSettingLabelItem * lable = [self itemWithTitle:title];
    lable.rightLable = rightTitle;
    return lable;
}
@end
