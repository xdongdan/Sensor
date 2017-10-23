//
//  SSAPI.h
//  Sensor
//
//  Created by xiaodongdan on 2017/10/23.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#ifndef SSAPI_h
#define SSAPI_h

// host
static NSString *kApiHost = @"http://outsourcing.kilcreapark.com";

// 注册
static NSString *kRegister = @"/user/register";

// 登录
static NSString *kLogin = @"/user/login";

// 发送验证码
static NSString *kSendVerifyCode = @"/user/sendVerifyCode";

// 修改密码
static NSString *kResetPwd = @"/user/sendVerifyCode";

// 忘记密码
static NSString *kForgetPwd = @"/user/forgetPwd";

// 登出
static NSString *kLoginOut = @"/user/forgetPwd";

// 获取天气
static NSString *kGetWeatherData = @"/data/getWeatherdata";

#endif /* SSAPI_h */
