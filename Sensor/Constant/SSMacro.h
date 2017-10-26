//
//  SSMacro.h
//  Sensor
//
//  Created by xiaodongdan on 2017/10/23.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#ifndef SSMacro_h
#define SSMacro_h

static NSString *kLoginSucess = @"loginSucess";
static NSString *kLoginCancel = @"loginCancel";

static NSString *kUserData = @"UserData";       // 用户信息key
static NSString *kLoginKey = @"LoginKey";       // 是否登录key
static NSString *kRemeberPwd = @"RemeberPwd";   // 记住密码key
static NSString *kPasswordData = @"Password";       // 记住密码后保存的手机号密码key

static NSString *kLocationCity = @"LocationCity";   // 定位城市
static NSString *kWeatherData = @"WeatherData";     // 天气数据

#ifndef ScreenWidth
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#endif
#ifndef ScreenHeight
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#endif

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define StrongSelf(strongSelf, weakSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf;

#define WEAKSELF WeakSelf(weakSelf)
#define STRONGSELF StrongSelf(strongSelf, weakSelf)


#endif /* SSMacro_h */
