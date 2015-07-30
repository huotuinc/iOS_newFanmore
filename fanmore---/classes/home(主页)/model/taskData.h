//
//  taskData.h
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  任务数据(taskData)

#import <Foundation/Foundation.h>

@interface taskData : NSObject

/**任务倒记时时间读秒*/
@property(nonatomic,assign) int  backTime;
/**任务编号*/
@property(nonatomic,assign) int  taskId;
/**标题*/
@property(nonatomic,strong) NSString * title;
/**图片连接*/
@property(nonatomic,strong) NSString * pictureURL;
/**最高可获取奖励流量*/
@property(nonatomic,assign) CGFloat maxBonus;
/**已获取流量*/
@property(nonatomic,assign) CGFloat reward;
/**简述*/
@property(nonatomic,strong) NSString * desc;
/**任务类别*/
@property(nonatomic,assign) int type;
/**任务状态*/
@property(nonatomic,assign) int status;
/**发布时间*/
@property(nonatomic,strong) NSString * publishDate;
/**多少人获取了流量*/
@property(nonatomic,strong) NSNumber * luckies;
/**剩余流量*/
@property(nonatomic,assign) CGFloat last;

/**剩余流量*/
@property(nonatomic,assign) int taskFailed;

/**剩余流量*/
@property(nonatomic,strong) NSString * contextURL;

@property(nonatomic,assign) long long taskOrder;

/**分享出去时所用的URL，应当有所区别*/
@property(nonatomic,strong) NSString * shareURL;

/**对于一个用户而言 每次打开一个任务 展示的题库应该是一样的*/
@property(nonatomic,strong) NSString * questions;

/**商户标题*/
@property(nonatomic,strong) NSString * merchantTitle;

/**距离答题开始时间*/
@property(nonatomic,strong) NSString * timeToStart;

@property(nonatomic,copy) NSString * turnTime;

@end
