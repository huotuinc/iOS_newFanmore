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
#import <MessageUI/MessageUI.h>


@interface BegController ()<MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) userData *userinfo;


/**求流量赠流量的附加信息*/
@property(nonatomic,strong) NSString * addMessage;

/**两个按钮都显示的lable*/
@property (weak, nonatomic) IBOutlet UILabel *twoLable;
@property (weak, nonatomic) IBOutlet UILabel *oneLable;

//@property(nonatomic,strong) UILabel * 
@end

@implementation BegController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.flowField.layer setMasksToBounds:YES];
    self.flowField.layer.borderWidth = 0.5;
    self.flowField.layer.borderColor = [UIColor colorWithRed:0.000 green:0.588 blue:1.000 alpha:1.000].CGColor;
    self.flowField.layer.cornerRadius = 6;
    
    self.begButton.layer.cornerRadius = 6;
    self.begButton.layer.borderWidth = 0.5;
    self.begButton.layer.borderColor = self.begButton.backgroundColor.CGColor;
    
    
    [self toAddTipLable];
    [self registerForKeyboardNotifications];
    
}

/**
 *  处理两个提示lable
 */
- (void)toAddTipLable{
    
    if(self.isFanmoreUser){
        self.twoLable.hidden = NO;
        self.twoLable.lineBreakMode = NSLineBreakByWordWrapping;
//        self.twoLable.numberOfLines = 2;
    }else{
        
        self.oneLable.hidden = NO;
        self.twoLable.hidden = YES;
    }
    
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

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.flowField becomeFirstResponder];
    
    
}
/**
 *  键盘弹出
 *
 *  @param noto <#noto description#>
 */
-(void)keyboardWasShown:(NSNotification *) note{
    
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat sizesss = 180 + 200 + 60 - (ScreenHeight - kbSize.height);
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.flowField resignFirstResponder];
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
    
    /**
     *  设置用户剩余流量
     */
    CGFloat userFlow = [self.userinfo.balance doubleValue];
    if (userFlow - (int)userFlow > 0) {
        self.userFlow.text = [NSString stringWithFormat:@"我的流量：%.1fM",[self.userinfo.balance doubleValue]];
    }else {
        self.userFlow.text = [NSString stringWithFormat:@"我的流量：%.0fM",[self.userinfo.balance doubleValue]];
    }
    if (userFlow > 1024) {
        self.userFlow.text = [NSString stringWithFormat:@"我的流量：%.3fG",[self.userinfo.balance doubleValue] / 1024];
    }
    
    [self setFriendInformation];
    
    
    if (!self.isFanmoreUser) {
        self.begButton.hidden = YES;
    }
    
}

/**
 *  设置好友信息
 */
- (void)setFriendInformation {
    
    //设置手机号
    self.friendPhone.text = self.model.name;
    
    //设置用户头像
    if (self.isFanmoreUser) {
        SDWebImageManager * manager = [SDWebImageManager sharedManager];
        NSURL * url = [NSURL URLWithString:self.model.image];
        [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            [self.friendHeadBtu setBackgroundImage:image forState:UIControlStateNormal];
        }];
    }
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
    
    [self.view endEditing:YES];
    
    if (![self judegeFlay]) {
        [MBProgressHUD showError:@"请求流量不能为空"];
        return;
    }
    if ([self.userinfo.balance doubleValue] < [self.flowField.text doubleValue]) {
        [MBProgressHUD showError:@"没那么多流量"];
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
    
    [self.view endEditing:YES];
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
        NSString *regex = @"^[0-9]*[0-9][0-9]*$";
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
       parames[@"originMobile"] = self.model.phone;
    }else{//2求流量
       port = @"makeRequest";
       parames[@"to"] = self.model.phone;
    }
    parames[@"fc"] = self.flowField.text;
    parames[@"message"] = mess;
    
    NSString * urlStr = [MainURL stringByAppendingPathComponent:port];
    
    [MBProgressHUD showMessage:nil];
    __weak BegController * wself = self;
    [UserLoginTool loginRequestGet:urlStr parame:parames success:^(NSDictionary* json) {
        [MBProgressHUD hideHUD];
        if ([json[@"systemResultCode"] intValue]==1 && [json[@"resultCode"] intValue] == 1) {
            if (type == 1) {
                NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                
                //1、保存个人信息
                NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
                userData* userInfo =  [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
                userInfo.balance = [NSString stringWithFormat:@"%.1f",([userInfo.balance floatValue] - [wself.flowField.text floatValue])];
                [NSKeyedArchiver archiveRootObject:userInfo toFile:fileName];
                CGFloat userFlow = [self.userinfo.balance doubleValue];
                if (userFlow - (int)userFlow > 0) {
                    self.userFlow.text = [NSString stringWithFormat:@"我的流量：%.1fM",[userInfo.balance doubleValue]];
                }else {
                    self.userFlow.text = [NSString stringWithFormat:@"我的流量：%.0fM",[userInfo.balance doubleValue]];
                }
                if (userFlow > 1024) {
                    self.userFlow.text = [NSString stringWithFormat:@"我的流量：%.3fG",[userInfo.balance doubleValue] / 1024];
                }
                [MBProgressHUD showSuccess:@"赠送流量成功"];
                
            }
            if (type == 1 && self.isFanmoreUser == NO) {
                [MBProgressHUD showSuccess:@"请求已发送"];
                if ([MFMessageComposeViewController canSendText]) {
                    MFMessageComposeViewController * aa = [[MFMessageComposeViewController alloc] init];
                    aa.body = [NSString stringWithFormat:@"%@",json[@"resultData"][@"smsContent"]];
                    aa.recipients = @[wself.model.phone];
                    aa.messageComposeDelegate = wself;
                    [self presentViewController:aa animated:YES completion:nil];
                }else {
                    [MBProgressHUD showError:@"设备没有短信功能"];
                }   
            }
            
        }
        
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"粉猫服务器连接异常"];
    }];
}

#pragma UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==1) {//送流量
        if (!buttonIndex) {
            NSString *mess = [self getTextFieldMessage:alertView];
//            NSLog(@"xxx%@",mess);
            [self toMutualWithServer:alertView.tag andStrin:mess];
        }
    }else if(alertView.tag == 2){//求流量
        if (!buttonIndex) {
            NSString *mess = [self getTextFieldMessage:alertView];
            [self toMutualWithServer:alertView.tag andStrin:mess];
//            NSLog(@"xxx%@",mess);
        }
    }
    
    [self.view endEditing:YES];
    
}

#pragma MFMessageComposeViewControllerDelegate 
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultSent) {
        [MBProgressHUD showSuccess:@"发送成功"];
    }else if (result == MessageComposeResultFailed) {
        [MBProgressHUD showError:@"发送失败"];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
