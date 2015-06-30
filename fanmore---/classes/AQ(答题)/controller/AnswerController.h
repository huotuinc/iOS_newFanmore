//
//  AnswerController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/1.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerController : UIViewController

@property (assign, nonatomic) BOOL isAnswer;

@property (assign ,nonatomic) int tureAnswer;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *AButton;
@property (weak, nonatomic) IBOutlet UIButton *BButton;
@property (weak, nonatomic) IBOutlet UIButton *CButton;
@property (weak, nonatomic) IBOutlet UIButton *DButton;

/**题目的图片*/
@property (weak, nonatomic) IBOutlet UIView *qusImageView;
/**题目的内容*/
@property (weak, nonatomic) IBOutlet UILabel *queLable;
/**题目的编号*/
@property (weak, nonatomic) IBOutlet UILabel *queNumber;
/**答题类型*/
@property(strong,nonatomic) NSNumber * type;
/**题目类型编号*/
@property(nonatomic,assign) int taskId;
/**题目列表*/
@property(nonatomic,strong) NSArray * questions;

/**答题获得流量*/
@property(nonatomic,assign) CGFloat flay;

@end
