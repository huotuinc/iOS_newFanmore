//
//  TrafficShowController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/2.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "TrafficShowController.h"
#import "BuyFlowViewController.h"
#import "BPViewController.h"
#import "ConversionController.h"
#import "FriendMessageController.h"
#import "ExchangeController.h"


#define FLAYSMESSAGE @"flaymess"
@interface TrafficShowController ()<ExchangeControllerdelegate>

@property (assign, nonatomic) int num;
/**已赚取的流量*/
@property (weak, nonatomic) IBOutlet UILabel *flowNumber;
/**兑换流量选项*/
@property(nonatomic,strong) NSArray * flays;

@property (nonatomic, strong) UIView *redIcon;


@end

@implementation TrafficShowController
static NSString *collectionViewidentifier = @"collectionCell";


- (void)flaysFromeWeb {
    _flays = [NSArray array];
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:FLAYSMESSAGE];
    _flays = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    if (!_flays.count) {
        [MBProgressHUD showMessage:nil];
    }
    
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"prepareCheckout"];
    [UserLoginTool loginRequestGet:urlStr parame:nil success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
            [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
            UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [aaa show];
            return ;
        }
        if ([json[@"systemResultCode"] intValue]==1&&[json[@"resultCode"] intValue]==1) {
            
            _flays = [NSArray arrayWithArray:json[@"resultData"][@"targets"]];
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:FLAYSMESSAGE];
            [NSKeyedArchiver archiveRootObject:_flays toFile:fileName];
            [self setWaringLabel];
        }
        
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];

}

/**
 *  账号被顶掉
 *
 *  @param alertView   <#alertView description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        LoginViewController * aa = [[LoginViewController alloc] init];
        UINavigationController * bb = [[UINavigationController alloc] initWithRootViewController:aa];
        [self presentViewController:bb animated:YES completion:^{
            [self flaysFromeWeb];
            
        }];
    }else{
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"流量兑换";
    
    
    self.redCircle.layer.cornerRadius = self.redCircle.frame.size.width /2.0;
    self.redCircle.layer.masksToBounds = YES;
    self.promptLabel.adjustsFontSizeToFitWidth = YES;
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //1、保存全局信息
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    CGFloat userFlow = [self.userInfo.balance doubleValue];
    if (userFlow - (int)userFlow > 0) {
        self.flowNumber.text = [NSString stringWithFormat:@"%.1fM",[self.userInfo.balance doubleValue]];
    }else {
        self.flowNumber.text = [NSString stringWithFormat:@"%.0fM",[self.userInfo.balance doubleValue]];
    }
    if (userFlow > 1024) {
        self.flowNumber.text = [NSString stringWithFormat:@"%.3fG",[self.userInfo.balance doubleValue] / 1024];
    }
    self.flowNumber.adjustsFontSizeToFitWidth = YES;

    self.PICView.progress = [self.userInfo.balance floatValue] / 500.0;
    self.PICView.thicknessRatio = 0.15;
    self.PICView.showText = NO;
    self.PICView.roundedHead = NO;
    self.PICView.showShadow = NO;
    
    self.PICView.outerBackgroundColor = [UIColor colorWithWhite:0.826 alpha:1.000];
    self.PICView.innerBackgroundColor = [UIColor whiteColor];
    self.PICView.progressTopGradientColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000];
    self.PICView.progressBottomGradientColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000];
    
    
    
    //初始化圆点
    self.redIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.redIcon.center = CGPointMake(self.friendButton.frame.origin.x + self.friendButton.frame.size.width, self.friendButton.frame.origin.y);
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"明细" style:UIBarButtonItemStylePlain handler:^(id sender) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BPViewController *bpView = [storyboard instantiateViewControllerWithIdentifier:@"BPViewController"];
        bpView.title = @"流量详细";
        [self.navigationController pushViewController:bpView animated:YES];
    }];
    
    [self.buyButton.layer setMasksToBounds:YES];
    self.buyButton.layer.borderWidth = 0.5;
    self.buyButton.layer.borderColor = [UIColor colorWithRed:0.000 green:0.588 blue:1.000 alpha:1.000].CGColor;
    self.buyButton.layer.cornerRadius = 6;
    
    [self.friendButton.layer setMasksToBounds:YES];
    self.friendButton.layer.borderWidth = 0.5;
    self.friendButton.layer.borderColor = [UIColor colorWithRed:0.000 green:0.588 blue:1.000 alpha:1.000].CGColor;
    self.friendButton.layer.cornerRadius = 6;
}


- (void)setWaringLabel {
    
    int bigflay = [[self.flays lastObject] intValue];
    
    int smallflay = [self.flays[0] intValue];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //1、保存全局信息
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    CGFloat current = [self.userInfo.balance doubleValue];
    
    if (current > bigflay) {
        
        self.promptLabel.text = [NSString stringWithFormat:@"你可以兑换所有流量包"];
        
    }else if(current > smallflay){
        
        
        [self.flays enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
           
            int aaa = [obj intValue];
            if (current < aaa) {
            
                self.promptLabel.text = [NSString stringWithFormat:@"你可以兑换%dM流量包,对换后还剩%.1fM流量",[self.flays[idx-1] intValue],(current - [self.flays[idx-1] intValue])];
                                         
                *stop = YES;
            }
        }];
        
    }else{
        
        self.promptLabel.text = [NSString stringWithFormat:@"你还差%.1fM，可以兑换%dM流量包", [self.flays[0] floatValue] - [self.userInfo.balance floatValue], smallflay];
    }
    

}





 - (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self flaysFromeWeb];
    
    [self saveControllerToAppDelegate:self];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (app.getFriendBeg == YES) {
        self.redCircle.hidden = NO;
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)exchangeAction:(id)sender { //流量交换
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExchangeController *con = [storyboard instantiateViewControllerWithIdentifier:@"ExchangeController"];
//    con.itemNum = self.flays.count;
    con.flays = self.flays;
//    con.delegate = self;
    con.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (IBAction)buyAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BuyFlowViewController *buy = [storyboard instantiateViewControllerWithIdentifier:@"BuyFlowViewController"];
    [self.navigationController pushViewController:buy animated:YES];
}

- (IBAction)friendAction:(id)sender {
    self.redCircle.hidden = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FriendMessageController *fm = [storyboard instantiateViewControllerWithIdentifier:@"FriendMessageController"];
    [self.navigationController pushViewController:fm animated:YES];
}

- (void)successExchange:(NSString *)userBalance{
    
//    NSLog(@"asdasdasdas%@",userBalance);
    CGFloat userFlow = [userBalance doubleValue];
    if (userFlow - (int)userFlow > 0) {
        self.flowNumber.text = [NSString stringWithFormat:@"%.1fM",[userBalance doubleValue]];
    }else {
        self.flowNumber.text = [NSString stringWithFormat:@"%.0fM",[userBalance doubleValue]];
    }
    if (userFlow > 1024) {
        self.flowNumber.text = [NSString stringWithFormat:@"%.3fG",[userBalance doubleValue] / 1024];
    }
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"明细" style:UIBarButtonItemStylePlain handler:^(id sender) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BPViewController *bpView = [storyboard instantiateViewControllerWithIdentifier:@"BPViewController"];
        bpView.title = @"流量详细";
        [self.navigationController pushViewController:bpView animated:YES];
    }];
    
    [self.buyButton.layer setMasksToBounds:YES];
    self.buyButton.layer.borderWidth = 0.5;
    self.buyButton.layer.borderColor = [UIColor colorWithRed:0.000 green:0.588 blue:1.000 alpha:1.000].CGColor;
    self.buyButton.layer.cornerRadius = 6;
    
    [self.friendButton.layer setMasksToBounds:YES];
    self.friendButton.layer.borderWidth = 0.5;
    self.friendButton.layer.borderColor = [UIColor colorWithRed:0.000 green:0.588 blue:1.000 alpha:1.000].CGColor;
    self.friendButton.layer.cornerRadius = 6;
    
    [self setWaringLabel];
}

@end
