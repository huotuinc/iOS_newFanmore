//
//  asignViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/26.
//  Copyright (c) 2015年 HT. All rights reserved.
//  签到中心


#import "asignViewController.h"
#import "RootViewController.h"
#import <UIViewController+MMDrawerController.h>
@interface asignViewController ()
/**周一*/
@property (weak, nonatomic) IBOutlet UIButton *monday;
/**周二*/
@property (weak, nonatomic) IBOutlet UIButton *Tuesday;
/**周三*/
@property (weak, nonatomic) IBOutlet UIButton *Wednesday;
/**周四*/
@property (weak, nonatomic) IBOutlet UIButton *Thursday;
/**周五*/
@property (weak, nonatomic) IBOutlet UIButton *Friday;
/**周六*/
@property (weak, nonatomic) IBOutlet UIButton *Saturday;
/**周六*/
@property (weak, nonatomic) IBOutlet UIButton *SunDay;

/**安妞的试图*/
@property (weak, nonatomic) IBOutlet UIView *btnView;

/**周一到周日的按钮*/
@property(nonatomic,strong)NSArray * buttons;

/**签到的按钮*/
@property (weak, nonatomic) IBOutlet UIButton *asignBtn;

/**签到的按钮的点击*/
- (IBAction)asignBtnClick:(id)sender;

@end

@implementation asignViewController

- (NSArray *)buttons{
    if (_buttons == nil) {
        
        _buttons = [NSArray array];
        _buttons = @[self.monday,self.Tuesday,self.Wednesday,self.Thursday,self.Friday,self.Saturday,self.SunDay];
    }
    return _buttons;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏的属性
    [self initBackAndTitle:@"一周连续签到"];
    
    for (UIButton * btn in self.buttons) {
        
//        [btn setBackgroundColor:LWColor(18.04, 17.57, 127)];
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //设置按钮属性
//    self.asignBtn.backgroundColor = LWColor(18.04, 16.56, 125);
    
}


/**
 *   导航栏返回按钮
 *
 *  @param btn <#btn description#>
 */
- (void)backAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)btnclick:(UIButton *) btn{
    
    NSLog(@"xxxxxxx%ld",btn.tag);
}
/**
 *  签到按钮点击
 *
 *  @param sender <#sender description#>
 */
- (IBAction)asignBtnClick:(id)sender {
    [MBProgressHUD showSuccess:@"签到成功 +1.5M"];
    [self.monday setBackgroundImage:[UIImage imageNamed:@"asignBlue"] forState:UIControlStateNormal];
    [self.monday setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.monday.userInteractionEnabled = NO;
}

@end
