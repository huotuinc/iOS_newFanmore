//
//  WebController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/17.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WebControllerDelegate <NSObject>

@optional
/**答题完成刷新*/
- (void)answerOverToreferch;

@end
@interface WebController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

/**正确的答案数量*/
@property(nonatomic,assign) int ritghtAnswer;

/**答题的总数量*/
@property(nonatomic,assign) NSUInteger totleQuestion;

/**答题的结果类型*/
@property(nonatomic,copy)NSString * answerType;

/**答题剩余机会*/
@property(nonatomic,assign)int chance;

/**答题剩余机会*/
@property(nonatomic,assign)float reward;

/**答题剩余机会*/
@property(nonatomic,assign)int illgel;

/**加载网页类型*/
@property(nonatomic,assign) int type;

/**答题获得流量*/
@property(nonatomic,assign) CGFloat flay;

/**问题编号*/
@property(assign,nonatomic)  int taskId;

/**游戏外链*/
@property(nonatomic,copy) NSString * relexUrl;

@property(nonatomic,strong) id <WebControllerDelegate> delegate;
@end
