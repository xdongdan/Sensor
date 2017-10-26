//
//  SSWeather.h
//  Sensor
//
//  Created by xiaodongdan on 2017/10/25.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSWeather : NSObject

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *weather;
@property (nonatomic, strong) NSString *week;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *temp;
@property (nonatomic, strong) NSString *temphigh;
@property (nonatomic, strong) NSString *templow;
@property (nonatomic, strong) NSString *windpower;
@property (nonatomic, strong) NSString *winddirect;
@property (nonatomic, strong) NSString *pm2_5;
@property (nonatomic, strong) NSString *quality;

@end
