//
//  TrafficShowController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/2.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "TrafficShowController.h"
#import "BuyFlowViewController.h"

@interface TrafficShowController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (assign, nonatomic) int num;

@end

@implementation TrafficShowController

static NSString *collectionViewidentifier = @"collectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.PICView.progress = 0.8;
    self.PICView.thicknessRatio = 0.15;
    self.PICView.showText = NO;
    self.PICView.innerBackgroundColor = [UIColor colorWithRed:245 green:245 blue:245 alpha:1];
    self.PICView.outerBackgroundColor = [UIColor colorWithRed:1 green:141 blue:255 alpha:1];
    
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
    
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, ScreenWidth, ScreenHeight)];
    self.bgView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    [self.view addSubview:self.bgView];
    self.bgView.hidden = YES;
    UITapGestureRecognizer *reg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regAction:)];
    
    [self.bgView addGestureRecognizer:reg];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:5];
    [flowLayout setFooterReferenceSize:CGSizeMake(0, 10)];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, ScreenHeight / 2 - self.collectionHeight / 2, ScreenWidth - 40, self.collectionHeight) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionViewidentifier];
    [self.bgView addSubview:self.collectionView];
    
    
//    [self.buyButton setBackgroundImage:[[UIImage imageNamed:@"button-W"] stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
//    [self.buyButton setBackgroundImage:[[UIImage imageNamed:@"button-W"] stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateHighlighted];
//    
//    [self.exchageButton setBackgroundImage:[[UIImage imageNamed:@"button-BS"] stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
//    [self.exchageButton setBackgroundImage:[[UIImage imageNamed:@"button-BS"] stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateHighlighted];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.num;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.itemNum % self.num) {
        return self.itemNum / self.num + 1;
    }else {
        return self.itemNum / self.num;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 60);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:collectionViewidentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button－G"]];
    image.frame = CGRectMake(0, 0, 80, 60);
    cell.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:image];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
    label.text = @"100M";
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.35 animations:^{

        self.bgView.hidden = YES;

    }];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)exchangeAction:(id)sender {
    
    [UIView animateWithDuration:0.35 animations:^{
        self.bgView.hidden = NO;
        
//        [UIView commitAnimations];
    }];
//
    
}

- (IBAction)buyAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BuyFlowViewController *buy = [storyboard instantiateViewControllerWithIdentifier:@"BuyFlowViewController"];
    [self.navigationController pushViewController:buy animated:YES];
}

- (void)regAction:(UIGestureRecognizer *)sender
{
    [UIView animateWithDuration:0.35 animations:^{
        self.bgView.hidden = YES;
        
//        [UIView commitAnimations];
    }];
}

@end
