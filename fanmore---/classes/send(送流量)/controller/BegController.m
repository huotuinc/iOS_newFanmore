//
//  BegController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/12.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <SDWebImageManager.h>
#import "BegController.h"
#import "userData.h"


@interface BegController ()

@property (nonatomic, strong) userData *userinfo;


/**求流量赠流量的附加信息*/
@property(nonatomic,strong) NSString * addMessage;
@end

@implementation BegController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.trafficField.layer setMasksToBounds:YES];
    self.trafficField.layer.borderWidth = 0.5;
    self.trafficField.layer.borderColor = [UIColor colorWithRed:0.000 green:0.588 blue:1.000 alpha:1.000].CGColor;
    self.trafficField.layer.cornerRadius = 6;
    
    self.begButton.layer.cornerRadius = 6;
    self.begButton.layer.borderWidth = 0.5;
    self.begButton.layer.borderColor = self.begButton.backgroundColor.CGColor;
    
    [self registerForKeyboardNotifications];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
/**
 *  键盘弹出
 *
 *  @param noto <#noto description#>
 */
-(void)keyboardWasShown:(NSNotification *) note{
    
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat sizesss = CGRectGetMaxY(self.begButton.frame) - (ScreenHeight - kbSize.height);
    
    if (sizesss > 0) {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(0,-(sizesss));
        }];
        
    }
}

/**
 *  键盘退下
 *
 *  @param noto <#noto description#>
 */
-(void)keyboardWillBeHidden:(NSNotification *) note{
    [UIView animateWithDuration:0.1 animations:^{
        
        self.view.transform = CGAffineTransformIdentity;
    }];
}


/**退下下键盘*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * fileName = [path stringByAppendingPathComponent:LocalUserDate];
    self.userinfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    NSURL * url = [NSURL URLWithString:self.userinfo.pictureURL];
    [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        [self.userHeadBtu setBackgroundImage:image forState:UIControlStateNormal];
    }];
    
    [self.trafficField becomeFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/**
 *  送流量
 */
- (IBAction)sendFlow:(UIButton *)sender {
    
    if (![self judegeFlay]) {
        [MBProgressHUD showError:@"请求流量不能为空"];
        return;
    }
    UIAlertView * addMes = [[UIAlertView alloc] initWithTitle:nil message:@"向你的小伙伴说点什么" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    addMes.alertViewStyle = UIAlertViewStylePlainTextInput;
    addMes.tag = 1; //送流量
    UITextField * aa = [addMes textFieldAtIndex:0];
    aa.placeholder = @"朕赏你点流量,还不谢恩";
    [addMes show];
}

/**
 *  求流量
 */
- (IBAction)begFlow:(UIButton *)sender {
    if (![self judegeFlay]) {
        [MBProgressHUD showError:@"请输入正确的流量"];
        return;
    }
    UIAlertView * addMes = [[UIAlertView alloc] initWithTitle:nil message:@"向你的小伙伴说点什么" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    addMes.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * aa = [addMes textFieldAtIndex:0];
    aa.placeholder = @"亲，送奴婢点流量吧";
    addMes.tag = 2; //求流量
    [addMes show];

}


/**
 *  判断文本狂内容内容
 */
- (BOOL)judegeFlay{
    
    if (!self.flowField.text.length) {
        return NO;
    }else{
        NSString *regex = @"^[1-9]*[1-9][1-9]*$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [predicate evaluateWithObject:self.flowField.text];
    }
}

/**
 *  获取文本框的文字
 */
- (NSString *)getTextFieldMessage:(UIAlertView *)alertView{
    
    UITextField * aa = [alertView textFieldAtIndex:0];
    return (aa.text.length?aa.text:aa.placeholder);
}

/**
 *  求流量和送流量与服务器交互
 */
- (void)toMutualWithServer:(NSInteger)type andStrin:(NSString*)mess{ //1送流量,2求流量
    
    
    NSString * port = nil;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    if (type == 1) {//1送流量
       port = @"makeProvide";
       parames[@"originMobile"] = @"123";
    }else{//2求流量
       port = @"makeRequest";
       parames[@"to"] = @"123";
    }
    parames[@"message"] = mess;
    parames[@"message"] = self.flowField.text;
    NSString * urlStr = [MainURL stringByAppendingPathComponent:port];
    [UserLoginTool loginRequestGet:urlStr parame:parames success:^(NSDictionary* json) {
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==1) {//送流量
        if (!buttonIndex) {
            NSString *mess = [self getTextFieldMessage:alertView];
            NSLog(@"xxx%@",mess);
            [self toMutualWithServer:alertView.tag andStrin:mess];
        }
    }else if(alertView.tag == 2){//求流量
        if (!buttonIndex) {
            NSString *mess = [self getTextFieldMessage:alertView];
            [self toMutualWithServer:alertView.tag andStrin:mess];
            NSLog(@"xxx%@",mess);
        }
    }
    
    [self.view endEditing:YES];
    
}
@end
