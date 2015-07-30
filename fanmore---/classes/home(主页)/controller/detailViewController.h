//
//  detailViewController.h
//  fanmore---
//
//  Created by lhb on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol detailViewDelegate <NSObject>

@optional

/**详情返回首页*/
- (void)detailViewBackToHome:(int) taskId;

@end



@interface detailViewController : UIViewController

/**网页webView*/
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@property (weak, nonatomic) IBOutlet UIButton *goQusetion;

/**问题编号*/
@property(assign,nonatomic)  int taskId;

/**判断是否已答过题*/
@property(nonatomic,assign)BOOL ishaveget;

/**任务的图标*/
/**分享标题*/
@property(nonatomic,strong)NSString *pictureUrl;

/**详情代理方法*/
@property(nonatomic,weak)id <detailViewDelegate>delegate;

- (IBAction)goQusetionAction:(id)sender;

@end
