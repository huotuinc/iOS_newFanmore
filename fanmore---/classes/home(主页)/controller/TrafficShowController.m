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

@interface TrafficShowController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (assign, nonatomic) int num;

/**已赚取的流量*/
@property (weak, nonatomic) IBOutlet UILabel *flowNumber;

@end

@implementation TrafficShowController

static NSString *collectionViewidentifier = @"collectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.flowNumber.text = [NSString stringWithFormat:@"%dM",self.userInfo.balance];
    self.PICView.progress = 0.8;
    self.PICView.thicknessRatio = 0.15;
    self.PICView.showText = NO;
    self.PICView.roundedHead = NO;
    self.PICView.showShadow = NO;
    
    self.PICView.outerBackgroundColor = [UIColor colorWithWhite:0.826 alpha:1.000];
    self.PICView.innerBackgroundColor = [UIColor whiteColor];
    self.PICView.progressTopGradientColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000];
    self.PICView.progressBottomGradientColor = [UIColor colorWithRed:0.004 green:0.553 blue:1.000 alpha:1.000];
    
    self.itemNum = 11;
    
    if (ScreenWidth - 40 > 25 + 4 * 80 ) {
        self.num = 4;
    }else {
        self.num = 3;
    }
#pragma view高度自适应
    //view高度
    if (self.itemNum % self.num) {
        self.collectionHeight = (self.itemNum / self.num + 1) * 70;
    }else {
        self.collectionHeight = self.itemNum / self.num * (60 + 10);
    }
    
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




//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return self.itemNum;
//}
//
////- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
////{
////    if (self.itemNum % self.num) {
////        return self.itemNum / self.num + 1;
////    }else {
////        return self.itemNum / self.num;
////    }
////}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(80, 60);
//}
//
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:collectionViewidentifier forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[UICollectionViewCell alloc] init];
//    }
//    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button－G"]];
//    image.frame = CGRectMake(0, 0, 80, 60);
//    cell.contentMode = UIViewContentModeScaleAspectFit;
//    [cell.contentView addSubview:image];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
//    label.text = @"100M";
//    label.textAlignment = NSTextAlignmentCenter;
//    [cell addSubview:label];
//    
//    return cell;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [UIView animateWithDuration:0.35 animations:^{
//
//        self.bgView.hidden = YES;
//        [self.navigationController setNavigationBarHidden:NO];
//    }];
//    
//}




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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)exchangeAction:(id)sender { //流量交换
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ConversionController *con = [storyboard instantiateViewControllerWithIdentifier:@"ConversionController"];
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
