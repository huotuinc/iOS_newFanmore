//
//  PersonMessageTableViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  账号信息

#import "PersonMessageTableViewController.h"
#import "FSMediaPicker.h"
#import "GTMBase64.h"

@interface PersonMessageTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,strong)NSArray * messages;

/**用户头像*/
@property (weak, nonatomic) IBOutlet UIButton *iconView;
/**用户出生年月*/
@property (weak, nonatomic) IBOutlet UILabel *birthDayLable;

@property(nonatomic,strong) UIDatePicker *datePicker;

- (IBAction)iconViewCkick:(id)sender;
@end

@implementation PersonMessageTableViewController



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


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage * iconImage = [[NSUserDefaults standardUserDefaults] objectForKey:UserIconView];
    if (iconImage) {
        
        [self.iconView setBackgroundImage:iconImage forState:UIControlStateNormal];
    }
    
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
                    pc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
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
        if (indexPath.row == 3) {//生日
            self.datePicker.center = self.view.center;
             [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:self.datePicker];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    NSLog(@"xxxxxxxx====%@",info);
    UIImage * photoImage = info[@"UIImagePickerControllerOriginalImage"];
    [self.iconView setBackgroundImage:photoImage forState:UIControlStateNormal];
    NSData * data = nil;
    if (UIImagePNGRepresentation(photoImage) == nil) {
        data = UIImageJPEGRepresentation(photoImage, 1);
    } else {
        data = UIImagePNGRepresentation(photoImage);
    }
    NSString * imageString = [GTMBase64 stringByEncodingData:data];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"profileType"] = @"0";
    params[@"profileData"] = imageString;
    NSString *urlStr = [MainURL stringByAppendingPathComponent:@"updateProfile"];
    [UserLoginTool loginRequestPost:urlStr parame:params success:^(id json) {
        
        NSLog(@"上传头像success===%@",json);
    } failure:^(NSError *error) {
        NSLog(@"上传头像failure%@",[error description]);
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)dateChanged:(UIDatePicker *) datePick{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * birthtime = [dateFormatter stringFromDate:datePick.date];
    NSLog(@"zzzzzzz%@",birthtime);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [datePick removeFromSuperview];
        
    });
    
}




#pragma mark - Table view data source





- (IBAction)iconViewCkick:(id)sender {
}
@end
