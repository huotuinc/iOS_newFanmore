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

@interface PersonMessageTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,ProfessionalControllerDelegate,ProfessionalControllerDelegate,NameControllerdelegate,HobbyControllerDelegate>

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
    [self setupPersonMessage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage * iconImage = [[NSUserDefaults standardUserDefaults] objectForKey:UserIconView];
    if (iconImage) {
        
        [self.iconView setBackgroundImage:iconImage forState:UIControlStateNormal];
    }
    
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
    
    

    if (!self.userinfo.area) {
        CGFloat longs =  [[[NSUserDefaults standardUserDefaults] stringForKey:DWLongitude] floatValue];
        CGFloat weis = [[[NSUserDefaults standardUserDefaults] stringForKey:DWLatitude] floatValue];
        CLLocation * loc = [[CLLocation alloc] initWithLatitude:weis longitude:longs];
        [self reverseGeocode:loc];
    }else{
        
        self.placeLable.text = self.userinfo.area;
    }
    self.nameLable.text = self.userinfo.realName; //2姓名
    self.sexLable.text =  self.userinfo.sex?@"女":@"男";  //3性别
    
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
        NSLog(@"%@",aa);
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
                UIAlertAction * photo = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    UIImagePickerController * pc = [[UIImagePickerController alloc] init];
                    pc.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    pc.delegate = self;
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
            }
        }
        if (indexPath.row == 1) { //姓名
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NameController *nameVC = [storyboard instantiateViewControllerWithIdentifier:@"NameController"];
            nameVC.name = self.userinfo.realName;
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

    NSLog(@"%@",info);
    UIImage * photoImage = info[@"UIImagePickerControllerOriginalImage"];
    [self.iconView setBackgroundImage:photoImage forState:UIControlStateNormal];
    NSData * data = nil;
    BOOL flag = NO;
    if (UIImagePNGRepresentation(photoImage) == nil) {
        data = UIImageJPEGRepresentation(photoImage, 1);
    } else {
        flag = YES;
        data = UIImagePNGRepresentation(photoImage);
    }
    
    NSString * imagefile = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *urlStr = [MainURL stringByAppendingPathComponent:@"updateProfile"];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"profileType"] = @(0);
        params[@"profileData"] = imagefile;
        [MBProgressHUD showMessage:@"头像上传中，请稍候"];
        [UserLoginTool loginRequestPost:urlStr parame:params success:^(NSDictionary* json) {
            [MBProgressHUD hideHUD];
            
            if ([json[@"systemResultCode"] intValue] ==1&&[json[@"resultCode"] intValue]) {
                userData * user = [userData objectWithKeyValues:json[@"resultData"][@"user"]];
                NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
                [NSKeyedArchiver archiveRootObject:user toFile:fileName];
            }
            [MBProgressHUD showSuccess:@"上传成功"];
            [self setupPersonMessage];
//            [self.tableView reloadData];
            NSLog(@"icon%@",json);
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            NSLog(@"%@",error.description);
        }];
        
    }];
    
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
    
    
    
    NSLog(@"------%@",datePick.date);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [datePick removeFromSuperview];
        
    });
    self.birthDayLable.text = birthtime;
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"updateProfile"]; //保存到服务器
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"profileType"] = @(2);
    parame[@"profileData"] =@((long long)[datePick.date timeIntervalSince1970] * 1000);
    [self toupDatePersonMessageWithApi:urlStr withParame:parame];
    
}


- (void)toupDatePersonMessageWithApi:(NSString *)urlStr withParame:(NSMutableDictionary *)paremes{

    [UserLoginTool loginRequestPost:urlStr parame:paremes success:^(id json) {
        
        NSLog(@"大大叔大叔大叔大叔大叔大叔大叔的时代%@",json);
        [MBProgressHUD showSuccess:@"生日资料上传成功"];
        NSLog(@"dadasd%@",json);
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
- (void)ProfessionalControllerBringBackCareer:(twoOption *)career isFlag:(BOOL)flag{
    
    NSLog(@"个人sasa时dadasdasdasd");
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
    NSLog(@"%d",career.value);
    [self toupDatePersonMessageWithApi:urlStr withParame:parame];
    
}

- (void)NameControllerpickName:(NSString *)name{
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.nameLable.text = name;
    });
    
}

- (IBAction)iconViewCkick:(id)sender {
}



/**
 *  反地理编码
 *
 *  @param loc <#loc description#>
 */
- (void)reverseGeocode:(CLLocation *)loc{
    
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error) {
            
            self.placeLable.text = @"杭州";
        }else {
            
            CLPlacemark *pm = [placemarks firstObject];
            self.placeLable.text = pm.name;
        }
    }];
}


/**
 *  上传个人爱好
 *
 *  @param parame <#parame description#>
 *  @param option <#option description#>
 */
- (void)pickOVerhobby:(NSString *)parame andOption:(NSString *)option{
    NSLog(@"dadasdasd%@---%@",parame,option);
    
    //把职业上传到服务器
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"updateProfile"]; //保存到服务器
    NSMutableDictionary * parames = [NSMutableDictionary dictionary];
    parames[@"profileType"] = @(5);
    parames[@"profileData"] = parame;
    [UserLoginTool loginRequestPost:urlStr parame:parames success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            userData * user = [userData objectWithKeyValues:json[@"resultData"][@"user"]];
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
            [NSKeyedArchiver archiveRootObject:user toFile:fileName];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.favLable.text = option;
    });
    
}
@end
