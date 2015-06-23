//
//  BuyFlowViewController.m
//  fanmore---
//
//  Created by lhb on 15/6/3.
//  Copyright (c) 2015年 HT. All rights reserved.
//  购买流量

#import "Order.h"
#import "DataSigner.h"
#import "BuyFlowViewController.h"
#import <AlipaySDK/AlipaySDK.h>  //支付宝接入头文件
#import "WXApi.h"
#define cellID @"collviewCell"
#import <AFNetworking.h>
#import "payRequsestHandler.h"

@interface BuyFlowViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate>
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
        
        NSString *urlStr = [MainURL stringByAppendingPathComponent:@"prepareBuy"];
        [UserLoginTool loginRequestGet:urlStr parame:nil success:^(id json) {
            
            NSLog(@"%@",json);
        } failure:^(NSError *error) {
            
        }];
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
    
    UICollectionViewCell *scell = [self.collection cellForItemAtIndexPath:self.selected];
    if (scell.selected == YES) {
        
        NSString * good = self.goods[self.selected.row];
        NSLog(@"%@",good);
    }
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝", @"微信",nil];
    [actionSheet showInView:self.view];
    
    
    NSLog(@"购买流量xxxxxxxxxxxxxxxxxxx");
}



/**
 *  action sheet
 *
 *  @param actionSheet <#actionSheet description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self PayByAlipay]; // 支付宝
    }
    if (buttonIndex == 1) {
//        [self PayByWeiXin]; // 微信支付
    }
}

/**
 *  支付宝
 */
- (void)PayByAlipay{
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088211251545121";
    NSString *seller = @"2088211251545121";
    //私营
    NSString *privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAMCul0XS9X/cVMkmrSeaZXnSvrs/bK5EiZf3d3/lTwHx165wAX/UIz4AcZHbKkYKKzmZKrRsu3tLRKFuflooKSVmWxk2hmeMqRETPZ/t8rKf8UONZIpOlOXEmJ/rYwxhnMeVhbJJxsko2so/jc+XAPLyv0tsfoI/TsJuhaGQ569ZAgMBAAECgYAK4lHdOdtwS4vmiO7DC++rgAISJbUH6wsysGHpsZRS8cxTKDSNefg7ql6/9Hdg2XYznLlS08mLX2cTD2DHyvj38KtxLEhLP7MtgjFFeTJ5Ta1UuBRERcmy0xSLh2zayiSwGTM8Bwu7UD6LUSTGwrgRR2Gg4EDpSG08J5OCThKF4QJBAPOO6WKI/sEuoRDtcIJqtv58mc4RSmit/WszkvPlZrjNFDU6TrOEnPU0zi3f8scxpPxVYROBceGj362m+02G2I0CQQDKhlq4pIM2FLNoDP4mzEUyoXIwqn6vIsAv8n49Tr9QnBjCrKt8RiibhjSEvcYqM/1eocW0j2vUkqR17rNuVVz9AkBq+Z02gzdpwEJMPg3Jqnd/pViksuF8wtbo6/kimOKaTrEOg/KnVJrf9HaOnatzpDF0B0ghGhzb329SRWJhddXNAkAkjrgVmGyu+HGiGKZP7pOXHhl0u3H+vzEd9pHfEzXpoSO/EFgsKKXv3Pvh8jexKo1T5bPAchsu1gGl4B63jeUpAkBbgUalUpZWZ4Aii+Mfts+S2E5RooZfVFqVBIsK47hjcoqLw4JJenyjFu+Skl2jOQ8+I5y1Ggeg6fpBMr2rbVkf";
    //公钥
    NSString *pubKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"粉毛流量"; //商品标题
    order.productDescription = @"通过粉猫购买手机流量"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"newfanmore2015";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:nil];
    }

}

/**
 *  微信支付
 */
- (void)PayByWeiXin{
    
    
//    NSMutableDictionary * parames = [NSMutableDictionary dictionary];
//    parames[@"appid"] = WeiXinAppID;
//    parames[@"mch_id"] =
//    parames[@"nonce_str"] =
//    parames[@"body"] = @"购买粉毛的流量产品";
//    parames[@"out_trade_no"] =
//    parames[@"total_fee"] =
//    parames[@"spbill_create_ip"] =
//    parames[@"notify_url"] =
//    parames[@"trade_type"] =
    
//    
//    [payRequsestHandler alloc] init:WeiXinAppID app_secret:WeiXinppSecrrt partner_key:WeiXinPARTNERKEY app_key:<#(NSString *)#>
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    NSString *url = @"https://api.mch.weixin.qq.com/pay/unifiedorder";
//    [mgr POST:url parameters:mgr success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"%@",responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",[error description]);
//    }];
    
//
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    PayReq *request = [[PayReq alloc] init];
//    
//    request.partnerId = @"10000100";  //商家向财付通申请的商家id
//    
//    request.prepayId= @"1101000000140415649af9fc314aa427"; //预支付订单
//    
//    request.package = @"Sign=WXPay";  // 商家根据财付通文档填写的数据和签名
//    
//    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c"; //随机串，防重发
//    
//    request.timeStamp= 1397527777; //时间戳，防重发
//    
//    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256"; //商家根据微信开放平台文档对数据做的签名
//    
//    [WXApi sendReq:request];//发送
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败， retcode=%d",resp.errCode);
                break;
        }
    }
}

/**
 *  随即生成订单号
 *
 *  @return <#return value description#>
 */
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((int)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == self.selected) {
        cell.backgroundColor = [UIColor orangeColor];
        UILabel *label = (UILabel *)[self.view viewWithTag:indexPath.row + indexPath.section * self.num + 100];
        label.textColor = [UIColor whiteColor];
    }
}

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
    
//    if (indexPath == self.selected) {
//        UICollectionViewCell *scell = [self.collection cellForItemAtIndexPath:self.selected];
//        scell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button－G"]];
//        UILabel *slabel = (UILabel *)[self.view viewWithTag:self.selected.row + self.selected.section * self.num + 100];
//        slabel.textColor = [UIColor blackColor];
//    }
    
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
