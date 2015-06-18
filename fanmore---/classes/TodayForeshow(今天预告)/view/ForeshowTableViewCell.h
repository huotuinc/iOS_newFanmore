//
//  ForeshowTableViewCell.h
//  fanmore---
//
//  Created by lhb on 15/5/28.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>


@class taskData;

@class ForeshowTableViewCell;

@protocol ForeshowTableViewCellDelegate <NSObject>

@optional

- (void)ForeshowTableViewCellSetTimeAlert:(ForeshowTableViewCell *) cell andTask:(taskData*)task;

@end

@interface ForeshowTableViewCell : UITableViewCell

@property (assign, nonatomic) BOOL isWarning;
@property(nonatomic,strong) id <ForeshowTableViewCellDelegate> delegate;

//+ (instancetype)ForeshowTableViewCell;

@property(nonatomic ,strong)taskData * task;

- (void)setImage:(NSString *)imageStr andNameLabel:(NSString *)name andTimeLabel:(NSString *) times andFlayLabel:(NSString *) FlayLabel andContentLabel:(NSString *) Content andOnlineImage:(BOOL) isOnline;

@end
