//
//  SSUser.h
//  Sensor
//
//  Created by xiaodongdan on 2017/10/24.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSUser : NSObject

@property (nonatomic, strong) NSString *username;  // 手机号码
@property (nonatomic, strong) NSString *nickname;  // 昵称
@property (nonatomic, strong) NSString *token;

@end
