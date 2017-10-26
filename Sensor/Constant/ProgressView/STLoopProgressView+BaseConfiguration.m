//
//  STLoopProgressView+BaseConfiguration.m
//  STLoopProgressView
//
//  Created by TangJR on 7/1/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "STLoopProgressView+BaseConfiguration.h"
#import "UIColor+HxColor.h"

#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

@implementation STLoopProgressView (BaseConfiguration)

+ (UIColor *)color1 {
    return [UIColor hxStringToColor:@"2ECC71"];
}

+ (UIColor *)color2 {
    return [UIColor hxStringToColor:@"F1C40F"];
}

+ (UIColor *)color3 {
    return [UIColor hxStringToColor:@"E67E22"];
}

+ (UIColor *)color4 {
    return [UIColor hxStringToColor:@"E74C3C"];
}

+ (UIColor *)color5 {
    return [UIColor hxStringToColor:@"8E44AD"];
}

+ (UIColor *)color6 {
    return [UIColor hxStringToColor:@"6D4C41"];
}

+ (UIColor *)currentColorWithNum:(CGFloat)num {
    if (num <= 35) {
        return [self color1];
    } else if (num <= 75) {
        return [self color2];
    } else if (num <= 115) {
        return [self color3];
    } else if (num <= 150) {
        return [self color4];
    } else if (num <= 250) {
        return [self color5];
    } else {
        return [self color6];
    }
}

+ (CGFloat)currentPercentWithNum:(CGFloat)num {
    if (num <= 35) {
        return 1.0 / 6;
    } else if (num <= 75) {
        return 2.0 / 6;
    } else if (num <= 115) {
        return 3.0 / 6;
    } else if (num <= 150) {
        return 4.0 / 6;
    } else if (num <= 250) {
        return 5.0 / 6;
    } else {
        return 1;
    }
}

+ (UIColor *)backgroundColor {
    
    return [UIColor whiteColor];
}

+ (CGFloat)lineWidth {
    return 10;
}

+ (CGFloat)startAngle {
    return DEGREES_TO_RADOANS(-210);
}

+ (CGFloat)endAngle {
    return DEGREES_TO_RADOANS(30);
}

+ (STClockWiseType)clockWiseType {
    return STClockWiseNo;
}

@end
