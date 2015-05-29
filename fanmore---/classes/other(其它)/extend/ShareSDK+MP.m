//
//  ShareSDK+MP.m
//  minipartner
//
//  Created by Cai Jiang on 4/13/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "ShareSDK+MP.h"

@implementation ShareSDK (MP)

+(void)simpleShare:(id<ISSContent>)content controller:(UIViewController*)controller sender:(id)sender{
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    UIDevice* device = [UIDevice currentDevice];
    if (device.userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        [container setIPadContainerWithView:sender?sender:controller.navigationController.navigationBar arrowDirect:UIPopoverArrowDirectionAny];
    }
    
    //        [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    id<ISSAuthOptions> _auth = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
    [_auth setPowerByHidden:YES];
    
    SSPublishContentEventHandler handler =^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        if (state == SSResponseStateSuccess)
        {
            if (controller) {
                [controller.view alertMessage:@"分享成功！"];
            }
        }
        else if (state == SSResponseStateFail)
        {
            LOG(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
        }else if (state == SSResponseStateCancel)
        {
            LOG(@"用户取消");
        }
    };
    
    NSMutableArray* types  = $marrnew;
    __block id<ISSContent> bcontent = content;
    
    if (!$safe([bcontent content])) {
        [bcontent setContent:@""];
    }
    
    for (NSNumber* typeid in [ShareSDK connectedPlatformTypes]) {
        ShareType type =(ShareType)[typeid intValue];
        [types addObject:[ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:type] icon:[ShareSDK getClientIconWithType:type] clickHandler:^(){
            //短信和邮件没有包含URL
            LOG(@"url:%@",[bcontent url]);
            if (type==ShareTypeSMS || type==ShareTypeMail || type==ShareTypeSinaWeibo) {
                [bcontent setContent:$str(@"%@\n%@",[bcontent content],[bcontent url])];
            }else if(type==ShareTypeWeixiTimeline){
                [bcontent setTitle:[bcontent content]];
            }
            //微信朋友圈的话 需要将title替换为content
            
            
            id<ISSAuthOptions> _auth = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
            [_auth setPowerByHidden:YES];
            
            [ShareSDK shareContent:bcontent type:type authOptions:_auth statusBarTips:YES result:handler];
        }]];
    }
    
    [ShareSDK showShareActionSheet:container shareList:types content:content statusBarTips:YES authOptions:_auth shareOptions:nil result:NULL];
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:content
//                     statusBarTips:YES
//                       authOptions:_auth
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    if (controller) {
//                                        [controller.view alertMessage:@"分享成功！"];
//                                    }
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    LOG(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
//                                }else if (state == SSResponseStateCancel)
//                                {
//                                    LOG(@"用户取消");
//                                }
//                            }];
}

@end
