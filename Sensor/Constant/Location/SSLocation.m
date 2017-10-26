//
//  SSLocation.m
//  Sensor
//
//  Created by xiaodongdan on 2017/10/25.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSLocation.h"
#import <UIKit/UIKit.h>
#import "NSString+BaseString.h"
#import "SSMacro.h"

@interface SSLocation () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation SSLocation

__strong static SSLocation *sharedObject;
+ (instancetype)sharedLocation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (void)startLocation {
    // 判断定位操作是否被允许
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        // 设置定位精确度到米
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置过滤器为无
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        [self.locationManager requestAlwaysAuthorization];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位服务未开启" message:@"请在系统设置中允许森尚净化使用定位服务" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [alert addAction:cancel];
        [alert addAction:confirm];
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        [vc presentViewController:alert animated:YES completion:nil];
    }
    [self.locationManager startUpdatingLocation];
}

- (NSString *)locationCityName {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kLocationCity];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    // 此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前所在的城市
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // 根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks firstObject];
            // 获取城市
            NSString *city = placemark.locality;
            if (!city) {
                // 四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得
                city = placemark.administrativeArea;
            }
            if (CHECK_VALID_STRING(city)) {
                [[NSUserDefaults standardUserDefaults] setValue:city forKey:kLocationCity];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            NSLog(@"----%@", city);
            // 获取之后就停止更新
            [self.locationManager stopUpdatingLocation];
        } else if (error == nil && placemarks.count == 0) {
            NSLog(@"No result were return");
        } else if (!error) {
            NSLog(@"%@", error);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因
        NSLog(@"%@", error);
    }
}

@end
