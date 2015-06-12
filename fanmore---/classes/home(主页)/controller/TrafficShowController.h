//
//  TrafficShowController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/2.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PICircularProgressView.h"

@interface TrafficShowController : UIViewController

/**
 *  中间⭕️视图
 */
@property (weak, nonatomic) IBOutlet PICircularProgressView *PICView;

/**
 *  购买按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *exchageButton;
@property (weak, nonatomic) IBOutlet UIButton *friendButton;

/**
 *  选择视图
 */
@property (strong, nonatomic) UIView *bgView;
@property (assign, nonatomic) double *height;

/**
 *  视图中的选项
 */
@property (strong, nonatomic) UICollectionView *collectionView;

- (IBAction)exchangeAction:(id)sender;
- (IBAction)buyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *friendAction;

@property (assign, nonatomic) NSInteger itemNum;

@property (assign, nonatomic) CGFloat collectionHeight;


@end
