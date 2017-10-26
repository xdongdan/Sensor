//
//  UIColor+HxColor.h
//  RedStarMain
//
//  Created by LT on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HxColor)

//16进制颜色码
+ (UIColor *) hxStringToColor: (NSString *) stringToConvert;
+ (UIColor *) hxStringToColor: (NSString *) stringToConvert alpha:(CGFloat)alpha;

@end
