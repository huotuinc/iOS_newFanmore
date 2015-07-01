//
//  JoinNextController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/19.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinNextController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *bgView;

//输入框和🐱之间的文字
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UITextField *field;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;



/**最先2题答案*/
@property(nonatomic,strong) NSMutableString * answers;
/**题目列表*/
@property(nonatomic,strong) NSMutableArray * questions;

/**题目类型编号*/
@property(nonatomic,assign) int taskId;

/**答题获得流量*/
@property(nonatomic,assign) CGFloat flay;

- (IBAction)nextButtonAction:(UIButton *)sender;

@end
