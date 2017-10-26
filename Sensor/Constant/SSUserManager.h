//
//  SSUserManager.h
//  Sensor
//
//  Created by xiaodongdan on 2017/10/24.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSUser.h"

@interface SSUserManager : NSObject

@property (nonatomic, assign, getter=isLogin) BOOL login;   // 登录状态 默认为no未登录
@property (nonatomic, strong) SSUser *user;

+ (instancetype)userManager;

- (void)saveUser:(NSDictionary *)user;
- (void)deleteUser;

@end
