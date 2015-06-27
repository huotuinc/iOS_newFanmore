//
//  detailViewController.h
//  fanmore---
//
//  Created by lhb on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewController : UIViewController

/**网页webView*/
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@property (weak, nonatomic) IBOutlet UIButton *goQusetion;

/**问题编号*/
@property(assign,nonatomic)  int taskId;

/**答题类型*/
@property(assign,nonatomic) int type;

/**首页详情*/
@property(strong,nonatomic) NSString * detailUrl;

/**答题倒计时时间*/
@property(nonatomic,assign) int backTime;

/**答题获取多少流量*/
@property(nonatomic,assign) CGFloat flay;

/**分享的url*/
@property(nonatomic,strong)NSString *shareUrl;

/**分享标题*/
@property(nonatomic,strong)NSString *titless;

/**判断是否已答过题*/
@property(nonatomic,assign)BOOL ishaveget;

/**任务的图标*/
/**分享标题*/
@property(nonatomic,strong)NSString *pictureUrl;

- (IBAction)goQusetionAction:(id)sender;

@end
