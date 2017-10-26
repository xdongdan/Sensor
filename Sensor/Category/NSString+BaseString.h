//
//  NSString+BaseString.h
//  RedStarMain
//
//  Created by LT on 16/7/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

/** VALID CHECKING**/
#define CHECK_VALID_STRING(__string)               (__string && [__string isKindOfClass:[NSString class]] && [__string length] && ![__string  isEqualToString:@"(null)"] && ![__string  isEqualToString:@"null"]&& ![__string  isEqualToString:@"<null>"])
@interface NSString (BaseString)

//判断字符串入字典前非空判断
NSString* NoEmptyString(id obj);

//表情符号的判断
+ (BOOL)stringContainsEmoji:(NSString *)string;

//电话
+ (BOOL)checkMobilePhone:(NSString*)mobile;

//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

//邮箱
+ (BOOL)validateEmail:(NSString *)email;

//判断是否为纯数字
+ (BOOL)basicNumbers:(NSString*)number;

//简单检测密码
+ (BOOL)checkPassWord:(NSString*)passWord;

// 判断是否是空格
- (BOOL)isNotBlankString;

//手机号打码
+ (NSString *)telHandle:(NSString *)tel;


/// 加密显示字符串，[@"123456789" securyForm:2 to:7 withChar:'*'] -> 12******89
- (NSString*)securyForm:(NSUInteger)form to:(NSUInteger)to withChar:(char)replaceChar;

@end
