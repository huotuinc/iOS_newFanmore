//
//  LWNewFeatureController.m
//  LuoHBWeiBo
//
//  Created by 罗海波 on 15-3-3.
//  Copyright (c) 2015年 LHB. All rights reserved.
//

#import "LWNewFeatureController.h"


#define LWNewFeatureImageCount 3
@interface LWNewFeatureController ()<UIScrollViewDelegate>


@property(nonatomic,weak)UIPageControl * padgeControl;
@end

@implementation LWNewFeatureController



- (void)viewDidLoad
{
    [super viewDidLoad];

    //1、创建scrollView
    [self setupScrollView];
    //2、添加  pageControll
    [self setupPageControll];
    
}


/**
 *添加  pageControll
 */
- (void)setupPageControll
{
    //添加
    UIPageControl *pageControll = [[UIPageControl alloc] init];
    pageControll.numberOfPages = LWNewFeatureImageCount;
    CGFloat padgeX = self.view.frame.size.width * 0.5;
    CGFloat padgeY = self.view.frame.size.height - 35;
    pageControll.center = CGPointMake(padgeX, padgeY);
    pageControll.userInteractionEnabled = NO;
    pageControll.bounds = CGRectMake(0, 0, 60, 40);
    [self.view addSubview:pageControll];
    
    //设置圆点颜色
    pageControll.currentPageIndicatorTintColor = LWColor(253, 98, 42);
    pageControll.pageIndicatorTintColor = LWColor(189, 189, 189);
    
    //page
    self.padgeControl= pageControll;
    
}
/**
 *  scrollView image
 */
- (void)setupScrollView
{
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    
    scrollView.delegate = self;
    //2、添加图片
    
    CGFloat scrollW = scrollView.frame.size.width;
    CGFloat scrollH = scrollView.frame.size.height;
    
    for (int index = 0; index < LWNewFeatureImageCount; index++) {
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //设置图片
        NSString *imageName = nil;
//        if (fourInch) {//4inch
//            
//            imageName= [NSString stringWithFormat:@"new_feature_%d-568h@2x",index+1];
//        }else{
//            
//           imageName = [NSString stringWithFormat:@"new_feature_%d",index+1];
//        }
//        
//        imageView.image = [UIImage imageWithName:imageName];
        
        //设置scorllview的frame
        CGFloat imageX = index * scrollW;
        CGFloat imageY = 0;
        CGFloat imageW = scrollW;
        CGFloat imageH = scrollH;
        imageView.frame =CGRectMake(imageX, imageY, imageW, imageH);
        
        
        
        [scrollView addSubview:imageView];
        
        //在最后一个图片上面添加按钮
        if (index==LWNewFeatureImageCount-1) {
            [self setupLastImageView:imageView];
        }
    }
    //设置滚动内容范围尺寸
    scrollView.contentSize = CGSizeMake(scrollW*LWNewFeatureImageCount, 0);
    
    //隐藏滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces =NO;
}

/**
 *  处理追后一个view的按钮
 */
-(void)setupLastImageView:(UIImageView *)imageView
{
    
    imageView.userInteractionEnabled = YES;
    //添加按钮
    UIButton * startButton = [[UIButton alloc] init];
//    [startButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button"] forState:UIControlStateNormal];
//    [startButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    //设置尺寸
    CGFloat centerX = imageView.frame.size.width*0.5;
    CGFloat centerY = imageView.frame.size.height*0.6;
    startButton.center = CGPointMake(centerX,centerY);
    startButton.bounds = (CGRect){CGPointZero,startButton.currentBackgroundImage.size};
    [startButton addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //设置文字
    [startButton setTitle:@"开始微博" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imageView addSubview:startButton];
    
    
    //设置checkbox
    UIButton * checkBox = [[UIButton alloc] init];
    checkBox.selected = YES;
//    [checkBox setImage:[UIImage imageWithName:@"new_feature_share_false"] forState:UIControlStateNormal];
//    [checkBox setImage:[UIImage imageWithName:@"new_feature_share_true"] forState:UIControlStateSelected];
    
    [checkBox setTitle:@"分享给大家" forState:UIControlStateNormal];
    [checkBox addTarget:self action:@selector(checkBoxClick:) forControlEvents:UIControlEventTouchUpInside];
    //设置尺寸
    checkBox.bounds = startButton.bounds;
    CGFloat checkBoxcenterX = centerX;
    CGFloat checkBoxcenterY = imageView.frame.size.height*0.5;
    checkBox.center = CGPointMake(checkBoxcenterX,checkBoxcenterY);
    
    
    checkBox.imageEdgeInsets= UIEdgeInsetsMake(0, 0, 0, 5);
    [checkBox setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    checkBox.titleLabel.font = [UIFont systemFontOfSize:15];
    [imageView addSubview:checkBox];
}


/**
 *  开始微博
 */
-(void)startButtonClick
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    RootViewController * roots = [[RootViewController alloc] init];
    //切换到 tabarcontrollor
    self.view.window.rootViewController = roots;
}

/**
 *  checkbox 点击
 */
-(void)checkBoxClick:(UIButton *)button
{
    button.selected = !button.isSelected;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma scorllView 代理方法

/**
 *  只要滚地就掉用这个方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x =  scrollView.contentOffset.x;
    double padgeDouble = x / scrollView.frame.size.width;
    int padgeInt = (int)(padgeDouble + 0.5);
    self.padgeControl.currentPage = padgeInt;
}
@end
