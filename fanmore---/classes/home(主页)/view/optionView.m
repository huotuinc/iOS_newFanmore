//
//  optionView.m
//  fanmore---
//
//  Created by lhb on 15/8/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "optionView.h"


@interface optionView ()


/**签到*/
@property(nonatomic,strong)UILabel * asinLable;


/**签到*/
@property(nonatomic,strong)UILabel * dayLable;


/**签到*/
@property(nonatomic,strong)UILabel * sssLable;
@end

@implementation optionView

- (instancetype) initWithFloy:(CGFloat) aa{
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //1、保存个人信息
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData *userinfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    optionView * ac = [[optionView alloc] init];
    
    NSString * aass = [ac.sssLable.text stringByAppendingFormat:@"%@M",[NSString xiaoshudianweishudeal:userinfo.rewardForSign]];
    ac.sssLable.text = aass;
    return ac;
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.alpha = 0.8;
        //签到标签
        UILabel * asinLable = [[UILabel alloc] init];
        asinLable.textColor = [UIColor whiteColor];
        asinLable.text = @"签到成功";
        asinLable.font = [UIFont systemFontOfSize:20];
        asinLable.textAlignment = NSTextAlignmentCenter;
        self.asinLable = asinLable;
        [self addSubview:asinLable];
        
        
        UILabel * asinLable1 = [[UILabel alloc] init];
        asinLable1.textColor = [UIColor whiteColor];
        asinLable1.textAlignment = NSTextAlignmentCenter;
        self.dayLable = asinLable1;
        [self addSubview:asinLable1];
        
        
        UILabel * asinLable2 = [[UILabel alloc] init];
        asinLable2.textColor = [UIColor whiteColor];
        asinLable2.textAlignment = NSTextAlignmentCenter;
        asinLable2.text = @"就可以获得";
        self.sssLable = asinLable2;
        [self addSubview:asinLable2];
        
    }
    
    return self;
}

- (void)setdistanceDays:(NSInteger) dayNumber{
    
    self.dayLable.text = [NSString stringWithFormat:@"你还差连续签到%ld天,",(long)dayNumber];
}



- (void)layoutSubviews{
    
    self.asinLable.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.5);
    self.dayLable.frame = CGRectMake(0, CGRectGetMaxY(self.asinLable.frame), self.frame.size.width, self.frame.size.height*0.25);
    self.sssLable.frame = CGRectMake(0, CGRectGetMaxY(self.dayLable.frame), self.frame.size.width, self.frame.size.height*0.25);
}
@end
