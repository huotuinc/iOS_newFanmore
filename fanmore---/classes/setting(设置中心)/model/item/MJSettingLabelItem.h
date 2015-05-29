//
//  MJSettingLabelItem.h
//  00-ItcastLottery
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJSettingItem.h"

@interface MJSettingLabelItem : MJSettingItem

@property (nonatomic, strong) NSString * rightLable;

+ (instancetype)itemWithTitle:(NSString *)title rightTitle:(NSString *) rightTitle;

@end
