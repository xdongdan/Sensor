//
//  CALayer+RSLayerColor.m
//  RedStarMain
//
//  Created by xiaodongdan on 16/7/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CALayer+RSLayerColor.h"

@implementation CALayer (RSLayerColor)

- (void)setBorderUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
