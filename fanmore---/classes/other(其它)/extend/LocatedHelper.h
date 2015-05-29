//
//  LocatedHelper.h
//  minipartner
//
//  Created by Cai Jiang on 1/21/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CitycodeHandler.h"
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface LocatedHelper : NSObject<CitycodeHandler,CLLocationManagerDelegate>

@end


@interface UIApplication (LocatedHelper)

/**
 *  重登录
 */
-(void)logicRelogin;
/**
 *  保存地理位置
 *
 *  @param location <#location description#>
 */
-(void)saveCLLocation:(CLLocation*)location;
/**
 *  获取地理位置
 *
 *  @return <#return value description#>
 */
-(CLLocationCoordinate2D)getLocation;

-(CityCode)getCurrentCityCode;

@end
