//
//  SSLocation.h
//  Sensor
//
//  Created by xiaodongdan on 2017/10/25.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SSLocation : NSObject

+ (instancetype)sharedLocation;

- (void)startLocation;
- (NSString *)locationCityName;

@end
