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
- (IBAction)goQusetionAction:(id)sender;

@end
