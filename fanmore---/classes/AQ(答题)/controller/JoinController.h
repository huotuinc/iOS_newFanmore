//
//  JoinController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/1.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UITextField *field1;
@property (weak, nonatomic) IBOutlet UITextField *field2;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;



/**答题类型*/
@property(strong,nonatomic) NSNumber * type;
/**题目类型编号*/
@property(nonatomic,assign) int taskId;
/**题目列表*/
@property(nonatomic,strong) NSArray * questions;


- (IBAction)nextButtonAction:(UIButton *)sender;

@end
