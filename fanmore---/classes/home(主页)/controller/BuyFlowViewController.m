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

/**商品*/
@property(nonatomic,strong) NSArray * goods;
/**购买按钮*/
- (IBAction)buyButtonClick:(UIButton *)sender;

@end
@implementation BuyFlowViewController



- (UICollectionView *)collection{
    
    if (_collection == nil) {
        
        UICollectionViewFlowLayout *flowL = [UICollectionViewFlowLayout alloc];
        flowL.minimumLineSpacing = 15;
        flowL.minimumInteritemSpacing = 15;
        flowL.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0);
        
//        flowL.itemSize = CGSizeMake((ScreenWidth -20 - 40) / 3, 50);
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.goodsCollectionView.frame.size.width, self.goodsCollectionView.frame.size.height) collectionViewLayout:flowL];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.showsVerticalScrollIndicator = NO;
    }
    
    return _collection;
}

- (NSArray *)goods{
    if (_goods == nil) {
        
        _goods = [NSArray array];
        _goods = @[@"10M",@"20M",@"30M",@"50M",@"70M",@"150M",@"210M",@"210M",@"500M",@"1000M",@"1500M",@"3000M"];
    }
    return _goods;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
     self.title = @"购买流量";
    [self.goodsCollectionView addSubview:self.collection];
    self.collection.dataSource = self;
    self.collection.delegate = self;
    [self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    
    
    
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.oldPriceLable.text];
//    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(2, 10)];
//    [attri addAttribute:NSStrikethroughColorAttributeName value:self.oldPriceLable.textColor range:NSMakeRange(0, 10)];
//    [self.oldPriceLable setAttributedText:attri];
}


- (IBAction)buyButtonClick:(id)sender {
    
    NSLog(@"xxxxxxxxxxxxxxxxxxx");
}

#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.goods.count;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 60);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
//    cell.backgroundColor = LWColor(110, 110, 110);
    for (id aa in cell.contentView.subviews) {
        
        [aa removeFromSuperview];
    }
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button-W"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    cell.backgroundView = image;

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
    label.text = @"100M";
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
    
    return cell;
}


- (void)optionsButtonClick:(UIButton *)btn{
    
    NSLog(@"%ld",(long)btn.tag);
}
#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"xxxxxxxx");
}
@end
