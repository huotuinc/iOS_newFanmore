//
//  PersonMessageTableViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  账号信息

#import "PersonMessageTableViewController.h"
#import "ProfessionalController.h"


@interface PersonMessageTableViewController ()

@property(nonatomic,strong)NSArray * messages;

/**用户头像*/
@property (weak, nonatomic) IBOutlet UIButton *iconView;

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
                }];
                UIAlertAction * ceme  = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
    if (indexPath.section == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (indexPath.row == 0) {
            ProfessionalController *pro = [storyboard instantiateViewControllerWithIdentifier:@"ProfessionalController"];
            pro.goods = @[@"教师",@"护士",@"医生",@"攻城狮",@"程序猿"];
            [self.navigationController pushViewController:pro animated:YES];
        }
    }
}



- (void)dateChanged:(UIDatePicker *) datePick{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * birthtime = [dateFormatter stringFromDate:datePick.date];
    NSLog(@"zzzzzzz%@",birthtime);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



///**
// *  设置datepicker的工具条
// */
//- (void)setupDatePicker
//{
//    
//    UIToolbar * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    UIBarButtonItem * item1 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleClick)];
//    UIBarButtonItem * item2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(selectClick)];
//    UIBarButtonItem * item3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    toolBar.items = @[item1,item3,item2];
//    //    self.datePicker.inputAccessoryView = toolBar;
//    self.DateText.inputAccessoryView = toolBar;
//    self.serverTime.inputAccessoryView = toolBar;
//}



#pragma mark - Table view data source





- (IBAction)iconViewCkick:(id)sender {
}
@end
