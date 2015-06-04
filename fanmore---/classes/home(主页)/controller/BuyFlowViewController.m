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
        
        flowL.itemSize = CGSizeMake((ScreenWidth -20 - 40) / 3, 50);
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
    
    return 11;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
//    cell.backgroundColor = LWColor(110, 110, 110);
    for (id aa in cell.contentView.subviews) {
        
        [aa removeFromSuperview];
    }
    
    UIButton * btn = [[UIButton alloc] init];
    btn.tag = indexPath.row;
    [btn addTarget:self action:@selector(optionsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, cell.frame.size.width , cell.frame.size.height);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[[UIImage imageNamed:@"tonday"] stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"tonday"] forState:UIControlStateSelected];
    [btn setTitle:self.goods[indexPath.row] forState:UIControlStateNormal];
   
    [cell.contentView addSubview:btn];
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
