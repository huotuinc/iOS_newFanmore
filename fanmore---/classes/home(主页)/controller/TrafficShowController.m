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

@interface TrafficShowController ()

@property (assign, nonatomic) int num;
/**已赚取的流量*/
@property (weak, nonatomic) IBOutlet UILabel *flowNumber;
/**兑换流量选项*/
@property(nonatomic,strong) NSArray * flays;
@end

@implementation TrafficShowController
static NSString *collectionViewidentifier = @"collectionCell";
/**
 *  兑换流量选项
 *
 *  @return <#return value description#>
 */
- (NSArray *)flays{
    
    if (_flays == nil) {
        _flays = [NSArray array];
        NSString * urlStr = [MainURL stringByAppendingPathComponent:@"prepareCheckout"];
        [UserLoginTool loginRequestGet:urlStr parame:nil success:^(id json) {
            
            NSLog(@"xxxxxxxxx%@",json);
            if ([json[@"systemResultCode"] intValue]==1&&[json[@"resultCode"] intValue]==1) {
                
                _flays = [NSArray arrayWithArray:json[@"resultData"][@"targets"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    _flays = [_flays sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2];
    }];
    return _flays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"流量明细";
    self.flays;
    self.flowNumber.text = [NSString stringWithFormat:@"%@123M",self.userInfo.balance];
    self.PICView.progress = [self.userInfo.balance floatValue] / 500.0;
    self.PICView.thicknessRatio = 0.15;
    self.PICView.showText = NO;
    self.PICView.roundedHead = NO;
    self.PICView.showShadow = NO;
    
    self.PICView.outerBackgroundColor = [UIColor colorWithWhite:0.826 alpha:1.000];
    self.PICView.innerBackgroundColor = [UIColor whiteColor];
    self.PICView.progressTopGradientColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000];
    self.PICView.progressBottomGradientColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000];
    
    
    self.promptLabel.text = [NSString stringWithFormat:@"你还差%.1fM，可以兑换%dM流量", 500  - [self.userInfo.balance floatValue], 500];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"明细" style:UIBarButtonItemStylePlain handler:^(id sender) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BPViewController *bpView = [storyboard instantiateViewControllerWithIdentifier:@"BPViewController"];
        [self.navigationController pushViewController:bpView animated:YES];
    }];
    
    [self.buyButton.layer setMasksToBounds:YES];
    self.buyButton.layer.borderWidth = 0.5;
    self.buyButton.layer.borderColor = [UIColor colorWithRed:0.000 green:0.588 blue:1.000 alpha:1.000].CGColor;
    self.buyButton.layer.cornerRadius = 2;
    
    [self.friendButton.layer setMasksToBounds:YES];
    self.friendButton.layer.borderWidth = 0.5;
    self.friendButton.layer.borderColor = [UIColor colorWithRed:0.000 green:0.588 blue:1.000 alpha:1.000].CGColor;
    self.friendButton.layer.cornerRadius = 2;
}








 - (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    [self.navigationController setNavigationBarHidden:NO];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)exchangeAction:(id)sender { //流量交换
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConversionController *con = [storyboard instantiateViewControllerWithIdentifier:@"ExchangeController"];
//    con.itemNum = self.flays.count;
    con.flays = self.flays;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)buyAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BuyFlowViewController *buy = [storyboard instantiateViewControllerWithIdentifier:@"BuyFlowViewController"];
    [self.navigationController pushViewController:buy animated:YES];
}

- (IBAction)friendAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FriendMessageController *fm = [storyboard instantiateViewControllerWithIdentifier:@"FriendMessageController"];
    [self.navigationController pushViewController:fm animated:YES];
}



@end
