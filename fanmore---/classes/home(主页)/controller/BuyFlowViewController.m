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
#import "buyflay.h"
#import "flayModel.h"

//#define WeiXinPayId @"wxd8c58460d0199dd5"
#define WeiXinPayId @"wxaeda2d5603b12302"
#define WeiXinPayMerchantId @"1251040401"
#define wxpayNotifyUri @"http://newtask.fanmore.cn/callbackWxpay"
//#define wxpayKey @"8c3b660de36a3b3fb678ca865e31f0f3"
//#define wxpayKey @"10101010101010101010101010101010"
//#define wxpayKey @"0db0d6908d6ae6a09b0a3727888f0da6"
#define wxpayKey @"0db0d4908a6ae6a09b0a7727878f0ca6"

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


@property(nonatomic,strong)buyflay * buyflay;
/**购买按钮*/
- (IBAction)buyButtonClick:(UIButton *)sender;


/***/
@property(nonatomic,strong) NSMutableString * debugInfo;

@end

static NSString * _company = nil;

@implementation BuyFlowViewController


- (buyflay *)buyflay{
    if (_buyflay == nil) {
        
        NSString *urlStr = [MainURL stringByAppendingPathComponent:@"prepareBuy"];
        [UserLoginTool loginRequestGet:urlStr parame:nil success:^(id json) {
            
            NSLog(@"购买流量明细%@",json);
            if ([json[@"systemResultCode"] intValue] == 1) {
                if ([json[@"resultCode"] intValue] == 56001) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
                    [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
                    UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                    [aaa show];
                    return ;
                }else if([json[@"resultCode"] intValue] == 1){
                    _buyflay = [buyflay objectWithKeyValues:json[@"resultData"]];
                    [_collection reloadData];
                }
            }
            NSArray * aaM = self.buyflay.purchases;
            flayModel * flay = aaM[0];
            self.oldPriceLable.text = [NSString stringWithFormat:@"%@", flay.msg];
            self.currentPriceLable.text = [NSString stringWithFormat:@"现价:￥%.1f",flay.price];
            
        } failure:^(NSError *error) {
//            NSLog(@"err");
        }];
    }
    return _buyflay;
}


/**
 *  账号被顶掉
 *
 *  @param alertView   <#alertView description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    __weak BuyFlowViewController * wself = self;
    if (buttonIndex == 0) {
        
        LoginViewController * aa = [[LoginViewController alloc] init];
        UINavigationController * bb = [[UINavigationController alloc] initWithRootViewController:aa];
        [self presentViewController:bb animated:YES completion:^{
            [wself buyflay];
            
        }];
    }else{
        
    }
}

- (UICollectionView *)collection{
    
    if (_collection == nil) {
//        CGFloat collectionHeight = 0;
//        if (self.goods.count / self.num) {
//            collectionHeight = (self.goods.count / self.num + 1) * 65 + 5;
//        }else {
//            collectionHeight = self.goods.count / self.num * (60 + 5) + 5;
//        }
        
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
        
        _goods = _buyflay.purchases;
    }
    return _goods;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.title = @"购买流量";
    
    BOOL wxRegistered = [WXApi registerApp:WeiXinPayId]; //像微信支付注册
    NSLog(@"wxRegistered:%d",wxRegistered);
    
    _company = self.buyflay.mobileMsg;
    
    [self.currentPriceLable setTintColor:[UIColor redColor]];
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
    userData *  user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    self.phoneNumber.text = user.name;
    
    self.oldPriceLable.adjustsFontSizeToFitWidth = YES;;
    
    
    self.currentPriceLable.adjustsFontSizeToFitWidth = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
//    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [root setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
    
//    self.phoneCompany.text = self.buyflay.mobileMsg;
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


/**
 *  购买按钮点击
 *
 *  @param sender <#sender description#>
 */
- (IBAction)buyButtonClick:(id)sender {
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝", @"微信",nil];
    [actionSheet showInView:self.view];
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
        [self WeiChatPay]; // 微信支付
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
//    NSString *pubKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB";
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
    order.tradeNO = [self caluTransactionCode]; //订单ID（由商家自行制定）
    order.productName = @"粉猫流量包"; //商品标题
    order.productDescription = @"通过粉猫购买手机流量"; //商品描述
    NSArray * aa = self.buyflay.purchases;
    
    //商品价格
    flayModel * bb = aa[self.selected.row];
    order.amount = [NSString stringWithFormat:@"%.2f",bb.price]; //商品价格
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
 *  微信支付预zhifu
 */
- (NSMutableDictionary *)PayByWeiXinParame{
    
    payRequsestHandler * payManager = [[payRequsestHandler alloc] init];
    [payManager setKey:wxpayKey];
    BOOL isOk = [payManager init:WeiXinPayId mch_id:WeiXinPayMerchantId];
    if (isOk) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
        params[@"appid"] = WeiXinPayId;
        params[@"mch_id"] = WeiXinPayMerchantId;     //微信支付分配的商户号
//        params[@"device_info"] = @"APP-001"; //支付设备号或门店号
//        time_t now;
//        time(&now);
//        NSString * time_stamp  = [NSString stringWithFormat:@"%ld", now];
//        NSString * nonce_str	= [WXUtil md5:time_stamp];
        params[@"nonce_str"] = noncestr; //随机字符串，不长于32位。推荐随机数生成算法
        params[@"trade_type"] = @"APP";   //取值如下：JSAPI，NATIVE，APP，WAP,详细说明见参数规定
        params[@"body"] = @"大三大四的"; //商品或支付单简要描述
        params[@"notify_url"] = wxpayNotifyUri;  //接收微信支付异步通知回调地址
        params[@"out_trade_no"] = [self caluTransactionCode]; //订单号
        params[@"spbill_create_ip"] = @"192.168.1.1"; //APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP。
        NSArray * aa = self.buyflay.purchases;
        //商品价格
        flayModel * bb = aa[self.selected.row];
        NSString * a  = [NSString stringWithFormat:@"%.f",bb.price * 100];
        
        
        params[@"total_fee"] = a;  //订单总金额，只能为整数，详见支付金额
        params[@"device_info"] = DeviceNo;
        
    
        
//        params[@"sign"] = [payManager createMd5Sign:params];
        
        //获取prepayId（预支付交易会话标识）
        NSString * prePayid = nil;
        prePayid  = [payManager sendPrepay:params];
    
       
        if ( prePayid != nil) {
            //获取到prepayid后进行第二次签名
            
            NSString    *package, *time_stamp, *nonce_str;
            //设置支付参数
            time_t now;
            time(&now);
            time_stamp  = [NSString stringWithFormat:@"%ld", now];
            nonce_str	= [WXUtil md5:time_stamp];
            //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
            //package       = [NSString stringWithFormat:@"Sign=%@",package];
            package         = @"Sign=WXPay";
            //第二次签名参数列表
            NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
            [signParams setObject: WeiXinPayId  forKey:@"appid"];
            [signParams setObject: nonce_str    forKey:@"noncestr"];
            [signParams setObject: package      forKey:@"package"];
            [signParams setObject: WeiXinPayMerchantId   forKey:@"partnerid"];
            [signParams setObject: time_stamp   forKey:@"timestamp"];
            [signParams setObject: prePayid     forKey:@"prepayid"];
            //[signParams setObject: @"MD5"       forKey:@"signType"];
            //生成签名
            NSString *sign  = [payManager createMd5Sign:signParams];
            
            //添加签名
            [signParams setObject: sign         forKey:@"sign"];
            
            [_debugInfo appendFormat:@"第二步签名成功，sign＝%@\n",sign];
            
            //返回参数列表
            return signParams;
            
        }else{
            [_debugInfo appendFormat:@"获取prepayid失败！\n"];
        }
        
    }
    return nil;
}


/**
 *  微信pay
 */
- (void)WeiChatPay{
    
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [self PayByWeiXinParame];
    if(dict != nil){
        NSMutableString *retcode = [dict objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
        }else{
            NSLog(@"提示信息%@",[dict objectForKey:@"retmsg"]);
        }
        
    }else{
        NSLog(@"提示信息返回错误");

    }

    
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
//                NSLog(@"支付成功");
                break;
            default:
//                NSLog(@"支付失败， retcode=%d",resp.errCode);
                break;
        }
    }
}


/**
 *  随即生成订单号
 *
 *  @return <#return value description#>
 */
- (NSString *)caluTransactionCode{
    
    NSDate * date = [[NSDate alloc] init];
    NSDateFormatter * form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyyMMddHHmmss"];
    NSString *cal =  [NSString stringWithFormat:@"%@000iOS%d",[form stringFromDate:date],arc4random()%10000+10000];
    return cal;
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
    
    NSArray * flayModes = self.buyflay.purchases;
    return flayModes.count;
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
    
    if (indexPath.row == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
        NSArray * aa = self.buyflay.purchases;
        flayModel * good = aa[indexPath.row + indexPath.section * self.num];
        label.text = [NSString stringWithFormat:@"%dM",good.m];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = indexPath.row + indexPath.section * self.num + 100;
        [cell.contentView addSubview:label];
        
        cell.backgroundColor = [UIColor orangeColor];
        label.textColor = [UIColor whiteColor];
        self.selected = indexPath;
        
        
    }else {
    
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
        NSArray * aa = self.buyflay.purchases;
        flayModel * good = aa[indexPath.row + indexPath.section * self.num];
        label.text = [NSString stringWithFormat:@"%dM",good.m];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = indexPath.row + indexPath.section * self.num + 100;
        [cell.contentView addSubview:label];
    }
    
//    if (indexPath == self.selected) {
//        UICollectionViewCell *scell = [self.collection cellForItemAtIndexPath:self.selected];
//        scell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button－G"]];
//        UILabel *slabel = (UILabel *)[self.view viewWithTag:self.selected.row + self.selected.section * self.num + 100];
//        slabel.textColor = [UIColor blackColor];
//    }
    
    return cell;
}


- (void)optionsButtonClick:(UIButton *)btn{
    
//    NSLog(@"%ld",(long)btn.tag);
}
#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray * aaM = self.buyflay.purchases;
    flayModel * flay = aaM[indexPath.row];
    self.oldPriceLable.text = [NSString stringWithFormat:@"%@", flay.msg];
    self.currentPriceLable.text = [NSString stringWithFormat:@"现价:￥%.1f",flay.price];
    
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
