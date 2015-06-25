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
@property(nonatomic,assign)int reward;


/**加载网页类型*/
@property(nonatomic,assign) int type;


/**问题编号*/
@property(assign,nonatomic)  int taskId;


@property(nonatomic,strong) id <WebControllerDelegate> delegate;
@end
