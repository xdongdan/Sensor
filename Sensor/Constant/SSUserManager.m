//
//  SSUserManager.m
//  Sensor
//
//  Created by xiaodongdan on 2017/10/24.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSUserManager.h"
#import "MJExtension.h"
#import "SSMacro.h"

@implementation SSUserManager

+ (instancetype)userManager {
    static SSUserManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SSUserManager alloc] init];
    });
    return manager;
}

- (void)saveUser:(NSDictionary *)user {
    self.user = [SSUser mj_objectWithKeyValues:user];
    self.login = YES;
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:kUserData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)deleteUser {
    self.user = nil;
    self.login = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLogin:(BOOL)login {
    [[NSUserDefaults standardUserDefaults] setBool:login forKey:kLoginKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kLoginKey];
}

- (SSUser *)user {
    if (!_user) {
        if (self.isLogin) {
            NSDictionary *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserData];
            _user = [SSUser mj_objectWithKeyValues:data];
        }
    }
    return _user;
}

@end
