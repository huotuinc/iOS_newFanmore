//
//  ForeshowTableViewCell.h
//  fanmore---
//
//  Created by lhb on 15/5/28.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ForeshowTableViewCell;

@protocol ForeshowTableViewCellDelegate <NSObject>

@optional

- (void)ForeshowTableViewCellSetTimeAlert:(ForeshowTableViewCell *) cell;

@end

@interface ForeshowTableViewCell : UITableViewCell

@property (assign, nonatomic) BOOL isWarning;
@property(nonatomic,strong) id <ForeshowTableViewCellDelegate> delegate;

+ (instancetype)ForeshowTableViewCell;
@end
