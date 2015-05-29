//
//  CitycodeHandler.h
//  minipartner
//
//  Created by Cai Jiang on 1/21/15.
//  Copyright (c) 2015 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@protocol CitycodeHandler <NSObject>

-(void)handleCitycode:(CLLocation*)location citycode:(CityCode)citycode;

@end
