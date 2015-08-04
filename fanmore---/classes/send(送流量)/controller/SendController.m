//
//  SendController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/12.
//  Copyright (c) 2015年 HT. All rights reserved.
//  xxxxxxxxxxxxx

#import "SendController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "FriendCell.h"
#import "PinYin4Objc.h"
#import "BegController.h"
#import "ResultContactInfo.h"
#import "ContactGroup.h"
#import <BlocksKit+UIKit.h>
#import <SDWebImageManager.h>

@interface SendController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchDisplayController *searchDisplay;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) UIBarButtonItem *right;

/**联系人列表分组模型*/
@property (nonatomic,strong) NSMutableArray * groupArray;


@end

@implementation SendController

NSString *frinedCellIdentifier = @"friend";

NSString *searchCellIdentifier = @"searchBar";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.personArray = [NSMutableArray array];
    
    self.groupArray = [NSMutableArray array];
    self.userPhone = [[NSMutableString alloc] init];
    
    [self readFromaddProbook];
    
    [self.view addSubview:self.searchBar];
    
    self.navigationItem.rightBarButtonItem = self.right;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
 
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:frinedCellIdentifier];
    

    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView removeSpaces];
    [self.tableView setHeaderHidden:YES];
    self.tableView.sectionIndexBackgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
    
    [self.view addSubview:self.tableView];
    
    
    [self _initSearchDisplayController];
    
    
    self.titleArray = [[NSMutableArray alloc] init];
    self.searchArray = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < 26; i++) {
        NSString *str = [[NSString alloc] initWithFormat:@"%c", 65 + i];
        [self.titleArray addObject:str];
    }
    
}

- (void)_initSearchDisplayController
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 44) ];
    self.searchBar.placeholder = @"搜索";
    [self.searchBar sizeToFit];
    self.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchBar;
    
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    [searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:searchCellIdentifier];
    [searchDisplayController.searchResultsTableView removeSpaces];
    
    self.searchDisplay = searchDisplayController;
}


/**
 *  读取通讯录
 */
- (void)readFromaddProbook{
    
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        
    }else
    {
        addressBooks = ABAddressBookCreate();
    }
    
    //获取通讯录中的所有人
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    for (NSInteger i = 0; i < nPeople; i++) {
        
        
        
        //        TKAddressBook *addressBook = [[TKAddressBook alloc] init];
        //唯一识别符号
        
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        
        ABRecordID reId = ABRecordGetRecordID(person);
        CFTypeRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty); //姓
        CFTypeRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);//名
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)firstName;//姓
        NSString *lastNameString = (__bridge NSString *)lastName;//名
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)lastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesRef!=nil && valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //            //获取电话号码和email
            //
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        [self.userPhone appendFormat:@"%d\r%@\t",reId,(__bridge NSString*)value];
                        
                        /**
                         生成一个model
                         */
                        FriendModel *model = [[FriendModel alloc] init];
                        
                        model.originIdentify = (__bridge NSString *)((__bridge void *)([NSString stringWithFormat:@"%d",reId]));
                        model.name = nameString;
                        model.phone = [NSString stringWithFormat:@"%@", (__bridge NSString*)value];
                        HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
                        
                        //姓名全部拼音
                        NSString *str = [PinyinHelper toHanyuPinyinStringWithNSString:nameString withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
                        model.hanyupingyin = str;
                        
                        //取出首字母
                        NSString *first = [str substringWithRange:NSMakeRange(0, 1)];
                        model.fristLetter = first;
                        
                        [self.personArray addObject:model];
                        
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
    }
    
    
    //获取联系人流量信息
    NSString * urlStr = [MainURL stringByAppendingPathComponent:@"contactInfo"];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"contacts"] = self.userPhone;
    
    __weak SendController * wself = self;
    [MBProgressHUD showMessage:nil];
    [UserLoginTool loginRequestPost:urlStr parame:params success:^(id json) {
        //        NSLog(@"%@",json);
        [MBProgressHUD hideHUD];
        if ([json[@"systemResultCode"] intValue] == 1) {
            
            if ([json[@"resultCode"] intValue]==56001){
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AppToken];
                [[NSUserDefaults standardUserDefaults] setObject:@"wrong" forKey:loginFlag];
                UIAlertView * aaa = [[UIAlertView alloc] initWithTitle:@"账号提示" message:@"当前账号被登录，是否重新登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [aaa show];
                return ;
            }
            
            if ([json[@"resultCode"] intValue] == 1) {
                
                NSArray * contactsInfo = [ResultContactInfo objectArrayWithKeyValuesArray:json[@"resultData"][@"contactInfo"]];
                NSMutableArray * effect = [NSMutableArray array];
                for (int i = 0; i<wself.personArray.count; i++) {
                    FriendModel *fd = wself.personArray[i];
                    for (int j = 0; j < contactsInfo.count; j++) {
                        
                        ResultContactInfo * rs = contactsInfo[j];
                        if ([fd.originIdentify isEqualToString:rs.originIdentify]) {//合法的
                            
                            fd.phone = rs.originMobile;
                            fd.image = rs.fanmorePicUrl;
                            fd.sex = rs.fanmoreSex;
                            fd.teleBalance = rs.teleBalance;
                            fd.flowLabel = [NSString stringWithFormat:@"%f", rs.fanmoreBalance];
                            //                            fd.fanmoreBalance = rs.fanmoreBalance;
                            fd.operatorLabel = rs.fanmoreTele;
                            
                            fd.fanmoreUsername = rs.fanmoreUsername;
                            
                            
                            
                            [effect addObject:fd];
                            break;
                        }
                        
                    }
                    
                    
                }
                
                
                
                [wself.personArray removeAllObjects];
                wself.personArray=effect;  //剔除无效数据
                
                [wself.personArray sortUsingComparator:^NSComparisonResult(FriendModel * obj1, FriendModel * obj2) {
                    return [obj1.fristLetter compare:obj2.fristLetter] == NSOrderedDescending;
                }];
                FriendModel * aaas = [[FriendModel alloc] init];
                ContactGroup * bbbs = [[ContactGroup alloc] init];
                for (FriendModel * friend in wself.personArray) {
                    if ([aaas.fristLetter isEqualToString:friend.fristLetter]) {//一样
                        
                        
                        aaas = friend;
                        
                        
                        [bbbs.friends addObject:friend];
                        
                        
                        
                    }else{//不一样
                        
                        aaas = friend;
                        
                        ContactGroup * group = [[ContactGroup alloc] init];
                        
                        group.firstLetter = friend.fristLetter;
                        [group.friends addObject:friend];
                        bbbs = group;
                        [wself.groupArray addObject:group];
                        
                        
                    }
                }
                
                if (self.groupArray.count > 0) {
                    [self setWiteBackground];
                }else {
                    [self setClearBackground];
                }
                [wself.tableView reloadData];
            }
            
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"连接服务器失败"];
        //        NSLog(@"%@",error.description);
    }];
}
/**
 *  账号被顶掉
 *
 *  @param alertView
 *  @param buttonIndex
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        LoginViewController * aa = [[LoginViewController alloc] init];
        UINavigationController * bb = [[UINavigationController alloc] initWithRootViewController:aa];
        [self presentViewController:bb animated:YES completion:^{
            [self readFromaddProbook];
            
        }];
    }
}

#pragma mark tableView

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        NSMutableArray *array = [NSMutableArray array];
        for (ContactGroup * group in self.groupArray) {
            [array addObject:group.firstLetter];
        }
        
        self.titleArray = array;
        return array;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        
        return 30;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView == self.tableView) {
        return self.groupArray.count;

    }else {
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        ContactGroup * aa = self.groupArray[section];
        return aa.firstLetter;
    }else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        
        ContactGroup * aa = self.groupArray[section];
        return aa.friends.count;

    }else {
        [self.searchArray removeAllObjects];
        NSString *str = [[NSString alloc] initWithFormat:@"%@",self.searchBar.text];
        NSString *str1 = str.uppercaseString;
        NSString *str2 = str1.lowercaseString;
//        NSLog(@"%@",self.personArray);
        for (FriendModel *model in self.personArray) {
            if ([model.phone rangeOfString:str].location !=NSNotFound) {
                [self.searchArray addObject:model];
                continue;
            }
            if ([model.hanyupingyin rangeOfString:str].location != NSNotFound) {
                [self.searchArray addObject:model];
                continue;
            }
            if ([model.hanyupingyin rangeOfString:str2].location != NSNotFound) {
                [self.searchArray addObject:model];
                continue;
            }
            if ([model.name rangeOfString:str].location != NSNotFound) {
                [self.searchArray addObject:model];
                continue;
            }
            
        }
//        NSLog(@"%@", self.searchArray);
       
        
        return self.searchArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendCell" owner:nil options:nil] lastObject];
//    }
    
    if (tableView == self.tableView) {
        FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:frinedCellIdentifier forIndexPath:indexPath];
        
        ContactGroup * group = self.groupArray[indexPath.section];
        FriendModel * friend = group.friends[indexPath.row];
        if (friend.image.length) {
            
            NSString *str = [NSString string];
            CGFloat userFlow = [friend.flowLabel doubleValue];
            if (userFlow - (int)userFlow > 0) {
                str = [NSString stringWithFormat:@"%.1fM",[friend.flowLabel doubleValue]];
            }else {
                str = [NSString stringWithFormat:@"%.0fM",[friend.flowLabel doubleValue]];
            }
            if (userFlow > 1024) {
                str = [NSString stringWithFormat:@"%.3fG",[friend.flowLabel doubleValue] / 1024];
            }
            
            [cell setUserPhone:friend.phone AndUserName:friend.name  AndSex:friend.sex AndFlow:str AndOperator:nil];
            
            cell.flowLabel.hidden = NO;
            cell.sexImage.hidden = NO;
            
            SDWebImageManager * manager = [SDWebImageManager sharedManager];
            NSURL * url = [NSURL URLWithString:friend.image];
            [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error == nil) {
                    [cell.headImage setBackgroundImage:image forState:UIControlStateNormal];
                    [cell.headImage setBackgroundImage:image forState:UIControlStateHighlighted];
                }
            }];
            cell.backgroundColor = [UIColor whiteColor];
        }else {
            cell.flowLabel.hidden = YES;
            cell.sexImage.hidden = YES;
            [cell setUserName:friend.name AndUserPhone:friend.phone];
            [cell.headImage setBackgroundImage:[UIImage imageNamed:@"mrtou_h"] forState:UIControlStateNormal];
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }else{
        FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
        FriendModel *model = self.searchArray[indexPath.row];
        
        if (model.image.length) {
//            NSLog(@"!!!%@", model);
            
            NSString *str = [NSString string];
            CGFloat userFlow = [model.flowLabel doubleValue];
            if (userFlow - (int)userFlow > 0) {
                str = [NSString stringWithFormat:@"%.1fM",[model.flowLabel doubleValue]];
            }else {
                str = [NSString stringWithFormat:@"%.0fM",[model.flowLabel doubleValue]];
            }
            if (userFlow > 1024) {
                str = [NSString stringWithFormat:@"%.3fG",[model.flowLabel doubleValue] / 1024];
            }
            
            [cell setUserPhone:model.phone AndUserName:model.name  AndSex:model.sex AndFlow:str AndOperator:nil];
            
            
            SDWebImageManager * manager = [SDWebImageManager sharedManager];
            NSURL * url = [NSURL URLWithString:model.image];
            [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error == nil) {
                    [cell.headImage setBackgroundImage:image forState:UIControlStateNormal];
                    [cell.headImage setBackgroundImage:image forState:UIControlStateHighlighted];
                }
            }];
            cell.backgroundColor = [UIColor whiteColor];
        }else {
            [cell setUserName:model.name AndUserPhone:model.phone];
            cell.backgroundColor = [UIColor whiteColor];
            
        }
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BegController *beg = [storyboard instantiateViewControllerWithIdentifier:@"BegController"];
    if (self.tableView == tableView) {
        ContactGroup * group = self.groupArray[indexPath.section];
        FriendModel * fmod = group.friends[indexPath.row];
        beg.model = fmod;
        
        if (fmod.image.length) {
            beg.isFanmoreUser = YES;
        }else {
            beg.isFanmoreUser = NO;
        }
    }else {
        FriendModel * fmod = self.searchArray[indexPath.row];
        beg.model = fmod;
        
        if (fmod.image.length) {
            beg.isFanmoreUser = YES;
        }else {
            beg.isFanmoreUser = NO;
        }
    }
    

    
    [self.navigationController pushViewController:beg animated:YES];
}


- (BOOL):(UISearchBar *)searchBar
{
    searchBar.frame = CGRectMake(0, 20, ScreenWidth, 44);
    self.tableView.frame = CGRectMake(0, searchBar.frame.origin.y + searchBar.frame.size.height, ScreenWidth, ScreenHeight - 44 - 20);
    return YES;
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    RootViewController * root = (RootViewController *)self.mm_drawerController;
    [root setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma searchDisplayControllerWillBeginSearch
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    [UIView animateWithDuration:0.25 animations:^{
//        self.searchBar.frame = CGRectMake(0, 20, ScreenWidth, 44);
//        self.tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 108);
//    }];
//    return YES;
//}
//
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
//{
//    if (searchBar.text.length == 0) {
//        searchBar.frame = CGRectMake(0, 64, ScreenWidth, 44);
//        self.tableView.frame = CGRectMake(0, 108, ScreenWidth, ScreenHeight - 64 - 44);
//    }else {
//        self.searchBar.frame = CGRectMake(0, 64, ScreenWidth, 44);
//    }
//    return YES;
//}
//
//
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    [UIView animateWithDuration:0.25 animations:^{
//        self.searchBar.frame = CGRectMake(0, 64, ScreenWidth, 44);
//        self.tableView.frame = CGRectMake(0, 108, ScreenWidth, ScreenHeight - 108 + 64);
//    }];
//}
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
//    return YES;
//}

#pragma 设置背景图片
- (void)setClearBackground {
    if (ScreenWidth == 375) {
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg750x1334"]];
    }
    if (ScreenWidth == 414) {
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg1242x2208"]];
    }
    if (ScreenWidth == 320) {
        if (ScreenHeight <= 480) {
            self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg640x960"]];
        }else {
            self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg640x1136"]];
        }
    }
}

- (void)setWiteBackground {
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
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
