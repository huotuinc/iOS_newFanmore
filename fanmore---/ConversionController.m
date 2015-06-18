//
//  ConversionController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/11.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "ConversionController.h"
#import "UserLoginTool.h"
#import "userData.h"
@interface ConversionController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>


@property(nonatomic,strong) userData * userInfo;

@end

@implementation ConversionController

static NSString *collectionViewidentifier = @"collectionCell";

NSString * _changeflah = nil;


- (userData *)userInfo{
    
    if (_userInfo == nil) {
        
        //初始化
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //1、保存个人信息
        NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
        _userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName]; //保存用户信息
    }
    
    return _userInfo;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
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
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake( 0, 64, ScreenWidth, ScreenHeight - 64)];
    self.bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [self.view addSubview:self.bgView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:5];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, ScreenHeight / 2 - self.collectionHeight / 2 - 32, ScreenWidth - 40, self.collectionHeight) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionViewidentifier];
    [self.bgView addSubview:self.collectionView];
    
    self.collectionView.contentInset = UIEdgeInsetsMake( -64, 0, 0, 0);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y - 35, self.collectionView.frame.size.width, 25)];
    label.text = @"流量兑换当月有效";
    [self.bgView addSubview:label];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    return self.itemNum;
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
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button－G"]];
    
    NSString * flayMount = [NSString stringWithFormat:@"%@",self.flays[indexPath.row]];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
    label.text = flayMount;
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
    
//    cell.userInteractionEnabled = YES;
    NSLog(@"xcadasdasdasd");
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    for (id aa in cell.subviews) {
        
        if ([aa isKindOfClass:[UILabel class]]) {
            _changeflah = ((UILabel*)aa).text;
        }
    }
    UILabel *label = (UILabel *)[self.view viewWithTag:indexPath.row + indexPath.section * self.num + 100];
    label.textColor = [UIColor whiteColor];
    
    if (([self.userInfo.balance floatValue]< [_changeflah floatValue])) {
        [MBProgressHUD showError:@"当前可兑换流量不足"];
        return;
    }
    
    NSString *flaycount = [NSString stringWithFormat:@"是否兑换流量%@M",_changeflah];
    if (IsIos8) {
        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:nil message:flaycount preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //兑换流量
            NSString *url = [MainURL stringByAppendingPathComponent:@"prepareCheckout"];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"amount"] = _changeflah;
            [UserLoginTool loginRequestPost:url parame:param success:^(id json) {
                
                NSLog(@"%@",json);
                
            } failure:^(NSError *error) {
                
            }];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertVc addAction:action];
        [alertVc addAction:action1];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else{ //非ios8
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:flaycount delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
        [alert show];
    }

//    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        //兑换流量
        NSString *url = [MainURL stringByAppendingPathComponent:@"prepareCheckout"];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"amount"] = _changeflah;
        [UserLoginTool loginRequestPost:url parame:param success:^(id json) {
            
            NSLog(@"%@",json);
            
        } failure:^(NSError *error) {
            
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)regAction:(UIGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
