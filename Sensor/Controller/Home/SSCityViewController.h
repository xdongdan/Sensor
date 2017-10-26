//
//  SSCityViewController.h
//  Sensor
//
//  Created by xiaodongdan on 2017/10/25.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSBaseViewController.h"

typedef void(^ReturnCityName)(NSString *cityname);
@interface SSCityViewController : SSBaseViewController

@property (nonatomic, copy) ReturnCityName returnBlock;

- (void)returnText:(ReturnCityName)block;

@end
