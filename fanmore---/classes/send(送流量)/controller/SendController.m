//
//  SendController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/12.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "SendController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface SendController ()

@end

@implementation SendController

- (void)viewDidLoad {
    [super viewDidLoad];
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        
    }
    
    else
        
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
        
        ABRecordID *reId = ABRecordGetRecordID(person);
        NSLog(@"%d", reId);
//        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
//        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
//        CFStringRef abFullName = ABRecordCopyCompositeName(person);
//        NSString *nameString = (__bridge NSString *)abName;
//        NSString *lastNameString = (__bridge NSString *)abLastName;
//        if ((__bridge id)abFullName != nil) {
//            nameString = (__bridge NSString *)abFullName;
//        } else {
//            if ((__bridge id)abLastName != nil)
//            {
//                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
//            }
//        }
//        NSLog(@"%@",nameString);
        
//        ABPropertyID multiProperties[] = {
//            kABPersonPhoneProperty,
//            kABPersonEmailProperty
//        };
//        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
//        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
//            ABPropertyID property = multiProperties[j];
//            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
//            NSInteger valuesCount = 0;
//            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
//            
//            if (valuesCount == 0) {
//                CFRelease(valuesRef);
//                continue;
//            }
//            //获取电话号码和email
//            
//            for (NSInteger k = 0; k < valuesCount; k++) {
//                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
//                switch (j) {
//                    case 0: {// Phone number
//                        NSLog(@"%@", (__bridge NSString*)value);
//                        break;
//                    }®
//                }
//                CFRelease(value);
//            }
//            CFRelease(valuesRef);
//        }
    }
    //    NSLog(@"%@",allPeople);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
