//
//  BuyFlowViewController.m
//  fanmore---
//
//  Created by lhb on 15/6/3.
//  Copyright (c) 2015年 HT. All rights reserved.
//  购买流量

#import "BuyFlowViewController.h"

#define cellID @"collviewCell"

@interface BuyFlowViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
/**手机运行商*/
@property (weak, nonatomic) IBOutlet UILabel *phoneCompany;
/**手机号*/
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
/**原价*/
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLable;
/**现价*/
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLable;

/**产品view*/
@property (weak, nonatomic) IBOutlet UIView *goodsCollectionView;

@property (nonatomic,strong) UICollectionView  * collection;

@property (strong, nonatomic) NSIndexPath *selected;

@property (assign, nonatomic) int num;

/**商品*/
@property(nonatomic,strong) NSArray * goods;
/**购买按钮*/
- (IBAction)buyButtonClick:(UIButton *)sender;



@end
@implementation BuyFlowViewController



- (UICollectionView *)collection{
    
    if (_collection == nil) {
        CGFloat collectionHeight = 0;
        if (self.goods.count / self.num) {
            collectionHeight = (self.goods.count / self.num + 1) * 65 + 5;
        }else {
            collectionHeight = self.goods.count / self.num * (60 + 5) + 5;
        }
        
        UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc] init];
        [flowL setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowL.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowL.footerReferenceSize = CGSizeMake(260 , 10);
        flowL.minimumInteritemSpacing = 10;

        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 40 - 20, ScreenHeight  / 2.5) collectionViewLayout:flowL];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.scrollEnabled = YES;
    }
    
    return _collection;
}

- (NSArray *)goods{
    if (_goods == nil) {
        
        _goods = [NSArray array];
        _goods = @[@"10M",@"20M",@"30M",@"50M",@"70M",@"150M",@"210M",@"250M",@"500M",@"50M",@"70M",@"50M",@"70M",@"50M",@"70M",@"50M",@"70M",@"50M",@"70M",@"50M",@"70M",@"50M",@"70M",@"50M",@"70M"];
    }
    return _goods;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.title = @"购买流量";
    
    if (ScreenWidth - 40 - 20 > 25 + 4 * 80 ) {
        self.num = 4;
    }else {
        self.num = 3;
    }
    
    [self.goodsCollectionView addSubview:self.collection];
    self.collection.dataSource = self;
    self.collection.delegate = self;
    [self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    
    
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
//    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}


- (IBAction)buyButtonClick:(id)sender {
    
    NSLog(@"xxxxxxxxxxxxxxxxxxx");
}

#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.goods.count;
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    if (self.goods.count % self.num) {
//        return self.goods.count / self.num + 1;
//    }else {
//        return self.goods.count / self.num;
//    }
//}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 60);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
    UICollectionViewCell * cell = [self.collection dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
//    cell.backgroundColor = LWColor(110, 110, 110);
    for (id aa in cell.contentView.subviews) {
        
        [aa removeFromSuperview];
    }
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button－G"]];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
    
    label.text = self.goods[indexPath.row + indexPath.section * self.num];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = indexPath.row + indexPath.section * self.num + 100;
    [cell.contentView addSubview:label];
    
    return cell;
}


- (void)optionsButtonClick:(UIButton *)btn{
    
    NSLog(@"%ld",(long)btn.tag);
}
#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *scell = [self.collection cellForItemAtIndexPath:self.selected];
    scell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button－G"]];
    UILabel *slabel = (UILabel *)[self.view viewWithTag:self.selected.row + self.selected.section * self.num + 100];
    slabel.textColor = [UIColor blackColor];
    
    
    UICollectionViewCell *cell = [self.collection cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    UILabel *label = (UILabel *)[self.view viewWithTag:indexPath.row + indexPath.section * self.num + 100];
    label.textColor = [UIColor whiteColor];
    
    self.selected = indexPath;
    
}
@end
