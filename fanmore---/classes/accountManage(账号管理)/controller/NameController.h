//
//  NameController.h
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/8.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NameControllerdelegate <NSObject>

@optional

/**选择姓名*/
- (void)NameControllerpickName:(NSString *) name;
@end

@interface NameController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;

@property (nonatomic, strong) NSString *name;

@property(nonatomic,weak) id<NameControllerdelegate> delegate;
@end
