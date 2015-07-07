//
//  PersonMessageTableViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  账号信息

#import <SDWebImageManager.h>
#import "PersonMessageTableViewController.h"
#import "UserLoginTool.h"
#import "GTMBase64.h"
#import "ProfessionalController.h"
#import "userData.h"
#import "GlobalData.h"
#import "twoOption.h"
#import "NameController.h"
#import "SexController.h"
#import "HobbyController.h"
#import <CoreLocation/CoreLocation.h>
#import "PinYin4Objc.h"

@interface PersonMessageTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,ProfessionalControllerDelegate,ProfessionalControllerDelegate,NameControllerdelegate,HobbyControllerDelegate,UIActionSheetDelegate,SexControllerdelegate>

@property(nonatomic,strong)NSArray * messages;
/**1用户头像*/
@property (weak, nonatomic) IBOutlet UIButton *iconView;
/**2用户姓名*/
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
/**3用户性别*/
@property (weak, nonatomic) IBOutlet UILabel *sexLable;
/**4用户出生年月*/
@property (weak, nonatomic) IBOutlet UILabel *birthDayLable;
/**5用户职业*/
@property (weak, nonatomic) IBOutlet UILabel *careerLable;
/**6用户收入*/
@property (weak, nonatomic) IBOutlet UILabel *userIncomeLable;
/**7用户爱好*/
@property (weak, nonatomic) IBOutlet UILabel *favLable;
/**8用户所在区域*/
@property (weak, nonatomic) IBOutlet UILabel *placeLable;
/**9用户账号时间*/
@property (weak, nonatomic) IBOutlet UILabel *registTimeLable;


/**自己的性别*/
@property(assign,nonatomic) int selfsex;


/**时间选择器*/
@property(nonatomic,strong) UIDatePicker *datePicker;

@property (nonatomic, strong) userData *userinfo;


@property(nonatomic,strong) CLGeocoder *geocoder;

- (IBAction)iconViewCkick:(id)sender;
@end

@implementation PersonMessageTableViewController


- (CLGeocoder *)geocoder{
    
    if (_geocoder == nil) {
        
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (UIDatePicker *)datePicker
{
    if (_datePicker==nil) {
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.date = [NSDate date];
        _datePicker.backgroundColor = [UIColor colorWithWhite:0.955 alpha:1];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    
    return _datePicker;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //初始化个人信息
    
    [self saveControllerToAppDelegate:self];
    self.title = @"用户资料";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage * iconImage = [[NSUserDefaults standardUserDefaults] objectForKey:UserIconView];
    if (iconImage) {
        
        [self.iconView setBackgroundImage:iconImage forState:UIControlStateNormal];
    }
    [self setupPersonMessage];
    
}
/**
 *  初始化个人信息
 */
- (void)setupPersonMessage{
    //获取用户数据
    //初始化
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * fileName = [path stringByAppendingPathComponent:LocalUserDate];
    self.userinfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    fileName = [path stringByAppendingPathComponent:InitGlobalDate];
    GlobalData * glo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
   
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    NSURL * url = [NSURL URLWithString:self.userinfo.pictureURL];
    [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        [self.iconView setBackgroundImage:image forState:UIControlStateNormal];
    }];
    
    

    if ([self.userinfo.area isEqualToString:@""]) {
        CGFloat longs =  [[[NSUserDefaults standardUserDefaults] stringForKey:DWLongitude] floatValue];
        CGFloat weis = [[[NSUserDefaults standardUserDefaults] stringForKey:DWLatitude] floatValue];
        CLLocation * loc = [[CLLocation alloc] initWithLatitude:weis longitude:longs];
        [self reverseGeocode:loc];
    }else{
        
        self.placeLable.text = self.userinfo.area;
    }
    self.nameLable.text = self.userinfo.realName; //2姓名
    self.sexLable.text =  self.userinfo.sex==1?@"女":@"男";  //3性别
    
    self.selfsex = self.userinfo.sex;
    
    NSDate * ptime = [NSDate dateWithTimeIntervalSince1970:(self.userinfo.birthDate/1000.0)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * publishtime = [formatter stringFromDate:ptime]; //唯独
    self.birthDayLable.text = publishtime;  //4
    
    for (twoOption * aa in glo.career) {
        if (aa.value == self.userinfo.career) {
            self.careerLable.text = aa.name;//5
            break;
        }
    }
    for (twoOption * aa in glo.incomings) {
        if (aa.value == self.userinfo.incoming) {
            self.userIncomeLable.text = aa.name;//5
            break;
        }
    }
    
    NSArray * favs = [self.userinfo.favs componentsSeparatedByString:@","];
    NSMutableString * favStr = [NSMutableString string];
    for (NSString * aa in favs) {
       
        for (twoOption * bb in glo.favs) {
            
            if (bb.value == [aa intValue]) {
                
                [favStr appendFormat:@"%@,",bb.name];
            }
        }
        
    }
    if (favStr.length != 0) {
        NSString * aa = [favStr substringToIndex:(favStr.length -1)];
//        NSLog(@"%@",aa);
        self.favLable.text = aa;//7
    }
    
//    self.placeLable.text = self.userinfo.area;//8
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(self.userinfo.regDate/1000.0)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * retime = [dateFormatter stringFromDate:date];
    self.registTimeLable.text =retime;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma tableview

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {//头像
            
            if (IsIos8) {
                
                UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                   }];
                UIAlertAction * photo = [UIAlertAction actionWithTitle:@"从本地相册选择图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    UIImagePickerController * pc = [[UIImagePickerController alloc] init];
                    pc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                    pc.delegate = self;
                    pc.allowsEditing = YES;
                    [self presentViewController:pc animated:YES completion:nil];
                }];
                UIAlertAction * ceme  = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    UIImagePickerController * pc = [[UIImagePickerController alloc] init];
                    pc.allowsEditing = YES;
                    pc.sourceType=UIImagePickerControllerSourceTypeCamera;
                    pc.delegate = self;
                    [self presentViewController:pc animated:YES completion:nil];
                }];
                [alertVc addAction:photo];
                [alertVc addAction:ceme];
                [alertVc addAction:action];
                [self presentViewController:alertVc animated:YES completion:nil];
            }else{
                
                UIActionSheet * aa = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
                [aa showInView:self.view];
                
            }
        }
        if (indexPath.row == 1) { //姓名
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NameController *nameVC = [storyboard instantiateViewControllerWithIdentifier:@"NameController"];
            nameVC.name = self.userinfo.realName;
            nameVC.delegate = self;
            [self.navigationController pushViewController:nameVC animated:YES];
        }
        if (indexPath.row == 2) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SexController *nameVC = [storyboard instantiateViewControllerWithIdentifier:@"SexController"];
            nameVC.sex = self.selfsex;
            nameVC.delegate = self;
            [self.navigationController pushViewController:nameVC animated:YES];
        }
        if (indexPath.row == 3) {//生日
            self.datePicker.center = self.view.center;
             [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:self.datePicker];
        }
    }
    if (indexPath.section == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (indexPath.row == 0) { //职业
            ProfessionalController *pro = [storyboard instantiateViewControllerWithIdentifier:@"ProfessionalController"];
            pro.delegate = self;
            pro.isPrefessional = YES;
            pro.currentCareer = self.careerLable.text;
            [self.navigationController pushViewController:pro animated:YES];
        }
        if (indexPath.row == 1) { //收入
            ProfessionalController *pro = [storyboard instantiateViewControllerWithIdentifier:@"ProfessionalController"];
            pro.delegate = self;
            pro.currentCareer = self.userIncomeLable.text;
            pro.isPrefessional = NO;
            [self.navigationController pushViewController:pro animated:YES];
        }
        if (indexPath.row == 2) { //爱好
            HobbyController *pro = [storyboard instantiateViewControllerWithIdentifier:@"HobbyController"];
            pro.delegate = self;
            pro.userHobby = self.userinfo.favs;
            [self.navigationController pushViewController:pro animated:YES];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
//    NSLog(@"%@",info);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    NSLog(@"%@",mediaType);
    // 判断获取类型：图片
    UIImage *photoImage = nil;
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            photoImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            photoImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    [self.iconView setBackgroundImage:photoImage forState:UIControlStateNormal];
    NSData *data;
    if (UIImagePNGRepresentation(photoImage) == nil) {
        
        data = UIImageJPEGRepresentation(photoImage, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(photoImage);
    }
    NSString * imagefile = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"profileType"] = @(0);
        params[@"profileData"] = imagefile;
        [MBProgressHUD showMessage:@"头像上传中，请稍候"];
        NSString * urlStr = [MainURL stringByAppendingPathComponent:@"updateProfile"];
        [UserLoginTool loginRequestPost:urlStr parame:params success:^(NSDictionary* json) {
            [MBProgressHUD hideHUD];
            if ([json[@"systemResultCode"] intValue] ==1&&[json[@"resultCode"] intValue] == 1) {
                userData * user = [userData objectWithKeyValues:json[@"resultData"][@"user"]];
                NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
                [NSKeyedArchiver archiveRootObject:user toFile:fileName];
            }
            [MBProgressHUD showSuccess:@"上传成功"];
            [self setupPersonMessage];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
//            NSLog(@"%@",error.description);
        }];
        
    }];
}


/**
 *  头像上传
 *
 *  @param parame <#parame description#>
 */
- (void)updatefile:(NSMutableDictionary *)parame{
    
    NSURL *url = [NSURL URLWithString:@"http://apitest.51flashmall.com:8080/fanmoreweb/app/updateProfile"];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary * paramsOption = [NSMutableDictionary dictionary];
    paramsOption[@"appKey"] = APPKEY;
    paramsOption[@"appSecret"] = HuoToAppSecret;
    NSString * lat = [[NSUserDefaults standardUserDefaults] objectForKey:DWLatitude];
    NSString * lng = [[NSUserDefaults standardUserDefaults] objectForKey:DWLongitude];
    paramsOption[@"lat"] = lat?lat:@(40.0);
    paramsOption[@"lng"] = lng?lng:@(116.0);;
    paramsOption[@"timestamp"] = apptimesSince1970;;
    paramsOption[@"operation"] = OPERATION_parame;
    paramsOption[@"version"] = AppVersion;
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:AppToken];
    paramsOption[@"token"] = token?token:@"";
    paramsOption[@"imei"] = DeviceNo;
    paramsOption[@"cityCode"] = @"1372";
    paramsOption[@"cpaCode"] = @"default";
    if (parame != nil) { //传入参数不为空
        [paramsOption addEntriesFromDictionary:parame];
    }
    paramsOption[@"sign"] = [NSDictionary asignWithMutableDictionary:paramsOption];  //计算asign
    [paramsOption removeObjectForKey:@"appSecret"];
    
    NSArray *bodyStr = [paramsOption allKeys];
    NSMutableString * aa = [NSMutableString string];
    for (NSString * key in bodyStr) {
        
        [aa appendString:[NSString stringWithFormat:@"%@=%@&",key,[paramsOption objectForKey:key]]];
    }
//    NSLog(@"%@",aa);
    NSData *data = [[aa substringToIndex:aa.length -1] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [request setHTTPBody:data];
    
//    [MBProgressHUD showMessage:@"头像上传中"];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError||data==nil) {
            [MBProgressHUD showError:@"请求失败"];
            return ;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"服务返回数据%@",dict);
        NSString *error = dict[@"error"];
        if(error){
            
            [MBProgressHUD showError:@"头像上传失败"];
        }else{
            NSString * success = dict[@"success"];
            [MBProgressHUD showSuccess:success];
        }
    }];
    
}


/**
 *  取消拍照
 *
 *  @param picker <#picker description#>
 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  修改个人生日资料
 *
 *  @param datePick datePick description
 */
- (void)dateChanged:(UIDatePicker *) datePick{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * birthtime = [dateFormatter stringFromDate:datePick.date];
    
    
    
//    NSLog(@"------%@",datePick.date);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [datePick removeFromSuperview];
        
    });
    self.birthDayLable.text = birthtime;
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"updateProfile"]; //保存到服务器
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"profileType"] = @(2);
    parame[@"profileData"] =@((long long)[datePick.date timeIntervalSince1970] * 1000);
    [self toupDatePersonMessageWithApi:urlStr withParame:parame withOptin:@"生日上传成功"];
    
}


- (void)toupDatePersonMessageWithApi:(NSString *)urlStr withParame:(NSMutableDictionary *)paremes withOptin:(NSString *)nn{

    [UserLoginTool loginRequestPost:urlStr parame:paremes success:^(id json) {
        
//        NSLog(@"大大叔大叔大叔大叔大叔大叔大叔的时代%@",json);
        [MBProgressHUD showSuccess:nn];
//        NSLog(@"dadasd%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            userData * user = [userData objectWithKeyValues:json[@"resultData"][@"user"]];
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
            [NSKeyedArchiver archiveRootObject:user toFile:fileName];
            
        }
       
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"生日资料上传失败"];
    }];
    

}

#pragma mark - Table view data source


#pragma ProfessionalControllerDelegate


/**
 *  职业收入的代理方法
 *
 *  @param career <#career description#>
 *  @param flag   <#flag description#>
 */
- (void)ProfessionalControllerBringBackCareer:(twoOption *)career isFlag:(BOOL)flag {
    
//    NSLog(@"个人sasa时dadasdasdasd");
     NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    if (flag) {//职业
         self.careerLable.text = career.name;
         parame[@"profileType"] = @(3);
    }else{
         self.userIncomeLable.text = career.name;
         parame[@"profileType"] = @(4);
    }
    //把职业上传到服务器
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"updateProfile"]; //保存到服务器
    parame[@"profileData"] = @(career.value);
//    NSLog(@"%d",career.value);
    NSString * ak = nil;
    if (flag) {
       ak = @"职业上传成功";
    }else{
        ak = @"收入上传成功";
    }
    [self toupDatePersonMessageWithApi:urlStr withParame:parame withOptin:ak];
    
}

- (void)NameControllerpickName:(NSString *)name{
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.nameLable.text = name;
//        [self setupPersonMessage];
    });
    
}

- (IBAction)iconViewCkick:(id)sender {
    
    UIActionSheet * aa = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从本地相册选择图片",@"相机", nil];
    [aa showInView:self.view];
    
}



/**
 *  反地理编码
 *
 *  @param loc ;
 */
- (void)reverseGeocode:(CLLocation *)loc{
    
//    NSLog(@"%f ---sssss-- %f" ,loc.coordinate.longitude ,loc.coordinate.latitude);
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *pm = [placemarks firstObject];
        self.placeLable.text = pm.locality;
        
    }];
}


/**
 *  上传个人爱好
 *
 *  @param parame <#parame description#>
 *  @param option <#option description#>
 */
- (void)pickOVerhobby:(NSString *)parame andOption:(NSString *)option{
//    NSLog(@"dadasdasd%@---%@",parame,option);
    
    //把职业上传到服务器
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"updateProfile"]; //保存到服务器
    NSMutableDictionary * parames = [NSMutableDictionary dictionary];
    parames[@"profileType"] = @(5);
    parames[@"profileData"] = parame;
    [UserLoginTool loginRequestPost:urlStr parame:parames success:^(id json) {
//        NSLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            userData * user = [userData objectWithKeyValues:json[@"resultData"][@"user"]];
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
            [NSKeyedArchiver archiveRootObject:user toFile:fileName];
            
        }
    } failure:^(NSError *error) {
//        NSLog(@"%@",error.description);
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.favLable.text = option;
    });
    
}


/**
 *    相机掉出
 *
 *  @param actionSheet <#actionSheet description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UIImagePickerController * pc = [[UIImagePickerController alloc] init];
        pc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        pc.delegate = self;
        pc.allowsEditing = YES;
        [self presentViewController:pc animated:YES completion:nil];
        
    }else if(buttonIndex == 1) {
        
        UIImagePickerController * pc = [[UIImagePickerController alloc] init];
        pc.allowsEditing = YES;
        pc.sourceType=UIImagePickerControllerSourceTypeCamera;
        pc.delegate = self;
        [self presentViewController:pc animated:YES completion:nil];
    }
}


/**
 *  性别选择的代理方法
 *
 *  @param sex <#sex description#>
 */
- (void)selectSexOver:(int)sex
{
    if (self.selfsex) {
        self.selfsex  = 0;
    }else{
        self.selfsex = 1;
    }
    
    if (sex) {
        self.sexLable.text = @"女";
    }else{
        self.sexLable.text = @"男";
    }
}
@end
