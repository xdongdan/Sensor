//
//  UIScreen+YuYue.m
//  yuyueiphone
//
//  Created by 肖冬丹 on 15/9/1.
//  Copyright (c) 2015年 寓悦家居科技有限公司. All rights reserved.
//

#import "UIScreen+YuYue.h"

@implementation UIScreen (YuYue)

+ (CGFloat)yuy_screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)yuy_screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

@end
