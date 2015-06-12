//
//  ProfessionalController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/9.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ProfessionalControllerDelegate <NSObject>

@optional
/**选择职业*/
- (void) ProfessionalControllerBringBackCareer:(NSString *)career isFlag:(BOOL) flag;

@end

@interface ProfessionalController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;


/**
 *  数据列表
 */
@property (strong, nonatomic) NSArray *goods;

/**
 *  是否是职业
 */
@property (assign, nonatomic) BOOL isPrefessional;

/**
 *  保存选中的行方便操作
 */
@property (weak, nonatomic) NSIndexPath *selectIndexPath;

/**用户当前的职业*/
@property (nonatomic,strong) NSString * currentCareer;


@property(strong,nonatomic) id<ProfessionalControllerDelegate> delegate;

@end
