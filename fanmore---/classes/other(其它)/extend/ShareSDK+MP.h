//
//  ShareSDK+MP.h
//  minipartner
//
//  Created by Cai Jiang on 4/13/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>

@interface ShareSDK (MP)

+(void)simpleShare:(id<ISSContent>)content controller:(UIViewController*)controller sender:(id)sender;

@end
