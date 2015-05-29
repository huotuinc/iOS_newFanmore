//
//  LocatedHelper.m
//  minipartner
//
//  Created by Cai Jiang on 1/21/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import "LocatedHelper.h"
#import "NSDictionary+UserData.h"
#import <ASIHTTPRequest.h>


@implementation UIApplication (LocatedHelper)

-(void)logicRelogin{
//    AppDelegate* ad = [AppDelegate getInstance];
//    [[ad getFanOperations] login:nil block:^(LoginState *state, NSError *error) {
//        
//    } userName:[ad getLastUsername] password:[ad getLastPassword]];
}


-(CityCode)getCurrentCityCode{
    return [(NSNumber*)[self.preferences $for:@"CurrentCityCode"]longValue];
}
-(CityCode)getPrefectCityCode{
    return [(NSNumber*)[self.preferences $for:@"PrefectCityCode"]longValue];
}
-(void)storePrefectCityCode:(CityCode)cityCode;{
    [self.preferences $obj:$long(cityCode) for:@"PrefectCityCode"];
    [self savePreferences];
}

/**
 *  保存地理位置
 *
 *  @param location <#location description#>
 */
-(void)saveCLLocation:(CLLocation*)location{
    self.preferences[@"saveCLLocationlatitude"] = $double(location.coordinate.latitude);
    self.preferences[@"saveCLLocationlongitude"] = $double(location.coordinate.longitude);
    [self savePreferences];
}
/**
 *  获取地理位置
 *
 *  @return <#return value description#>
 */
-(CLLocationCoordinate2D)getLocation{
    CLLocationCoordinate2D c2d;
    c2d.longitude = 0;
    c2d.latitude = 0;
    if (self.preferences[@"saveCLLocationlatitude"] && self.preferences[@"saveCLLocationlongitude"]) {
        c2d.latitude = [self.preferences[@"saveCLLocationlatitude"] doubleValue];
        c2d.longitude = [self.preferences[@"saveCLLocationlongitude"] doubleValue];
    }else{
        NSNumber* failed = self.preferences[@"LocatingFailedTime"];
        if($safe(failed) && [failed intValue]>=5){
            CLLocationCoordinate2D c22d;
            c22d.longitude = -1;
            c22d.latitude = -1;
            return c22d;
        }
    }
    return c2d;
}

@end


@implementation LocatedHelper

-(void)handleCitycode:(CLLocation*)location citycode:(CityCode)citycode{
    //如果当时已登录 则静默重新登录
    //反之仅仅保存就可以了
    UIApplication* app = [UIApplication sharedApplication];
    if (citycode==-1){
        NSNumber* failed = app.preferences[@"LocatingFailedTime"];
        if(!$safe(failed)){
            failed = @0;
        }
        failed = $int([failed intValue]+1);
        app.preferences[@"LocatingFailedTime"] = failed;
        [app savePreferences];
    }else{
        app.preferences[@"LocatingFailedTime"] = @0;
        [app savePreferences];
    }
    
    if (location) {
        [app saveCLLocation:location];
        if([app.useData hasLogined]){
            [app logicRelogin];
        }
    }
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //Error Domain=kCLErrorDomain Code=0 "The operation couldn’t be completed. (kCLErrorDomain error 0.)"
    NSLog(@"%@",error);
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    __weak LocatedHelper* wself = self;
    if (abs(howRecent) < 15.0) {
        [manager stopUpdatingLocation];
        // If the event is recent, do something with it.
        LOG(@"latitude %+.6f, longitude %+.6f\n",
            location.coordinate.latitude,
            location.coordinate.longitude);
        
        NSString* urlBuffer = $str(@"http://api.map.baidu.com/geocoder/v2/?output=json&ak=lRfC2kF5DwU8i6QWRiEqPikn&coordtype=wgs84ll&location=%.6f,%.6f&pois=0",location.coordinate.latitude,location.coordinate.longitude);
        
        ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlBuffer]];
        __weak ASIHTTPRequest* wrequest = request;
        //        __weak CLLocation* wlocation = location;
        [request addRequestHeader:@"Referer" value:@"http://www.fanmore.com/"];
        [request setCompletionBlock:^{
            //            JSONDecoder *jd=[[JSONDecoder alloc] init];
            //            NSDictionary* obj = [jd objectWithData:[request responseData]];
            NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:[wrequest responseData] options:0 error:NULL];
            if ([[obj $for:@"status"] isEqual:@0]){
                NSDictionary* cityrs = [obj $for:@"result"];
                LOG(@"%@",cityrs);
                NSNumber* nscityCode =(NSNumber*)[cityrs $for:@"cityCode"];
                [[UIApplication sharedApplication].preferences $obj:nscityCode for:@"CurrentCityCode"];
                [wself handleCitycode:location citycode:[nscityCode longValue]];
            }else{
                [wself handleCitycode:location citycode:-1];
            }
            
        }];
        [request startAsynchronous];
        
        //        CLGeocoder* coder =  $new(CLGeocoder);
        //        [coder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //            for (CLPlacemark * placemark in placemarks) {
        //                LOG(@"%@",placemark);
        //            }
        //        }];
    }
}


@end
