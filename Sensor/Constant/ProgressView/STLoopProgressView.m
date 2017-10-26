//
//  STLoopProgressView.m
//  STLoopProgressView
//
//  Created by TangJR on 6/29/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "STLoopProgressView.h"
#import "STLoopProgressView+BaseConfiguration.h"
#import "SSMacro.h"

@interface STLoopProgressView ()

@property (strong, nonatomic) CAShapeLayer *colorMaskLayer; // 渐变色遮罩
@property (strong, nonatomic) CAShapeLayer *colorLayer; // 渐变色
@property (strong, nonatomic) CAShapeLayer *blueMaskLayer; // 蓝色背景遮罩

@property (nonatomic, strong) CAGradientLayer *leftLayer;

@end

@implementation STLoopProgressView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [STLoopProgressView backgroundColor];
    
    [self setupColorLayer];
    [self setupColorMaskLayer];
    [self setupBlueMaskLayer];
}

/**
 *  设置整个蓝色view的遮罩
 */
- (void)setupBlueMaskLayer {
    
    CAShapeLayer *layer = [self generateMaskLayer];
    self.layer.mask = layer;
    self.blueMaskLayer = layer;
}

/**
 *  设置渐变色，渐变色由左右两个部分组成，左边部分由黄到绿，右边部分由黄到红
 */
- (void)setupColorLayer {
    
    self.colorLayer = [CAShapeLayer layer];
    self.colorLayer.frame = self.bounds;
    [self.layer addSublayer:self.colorLayer];

    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0,  ScreenWidth - 60, ScreenWidth - 60);
    self.leftLayer = leftLayer;
    [self.colorLayer addSublayer:leftLayer];
}

/**
 *  设置渐变色的遮罩
 */
- (void)setupColorMaskLayer {
    
    CAShapeLayer *layer = [self generateMaskLayer];
    layer.lineWidth = [STLoopProgressView lineWidth] + 0.5; // 渐变遮罩线宽较大，防止蓝色遮罩有边露出来
    self.colorLayer.mask = layer;
    self.colorMaskLayer = layer;
}

/**
 *  生成一个圆环形的遮罩层
 *  因为蓝色遮罩与渐变遮罩的配置都相同，所以封装出来
 *
 *  @return 环形遮罩
 */
- (CAShapeLayer *)generateMaskLayer {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    
    // 创建一个圆心为父视图中点的圆，半径为父视图宽的2/5，起始角度是从-240°到60°
    
    UIBezierPath *path = nil;
    if ([STLoopProgressView clockWiseType]) {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake((ScreenWidth - 60) / 2, (ScreenWidth - 60) / 2) radius:(ScreenWidth - 60) / 2 - 10 startAngle:[STLoopProgressView startAngle] endAngle:[STLoopProgressView endAngle] clockwise:YES];
    } else {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake((ScreenWidth - 60) / 2, (ScreenWidth - 60) / 2) radius:(ScreenWidth - 100) / 2 - 10 startAngle:[STLoopProgressView endAngle] endAngle:[STLoopProgressView startAngle] clockwise:NO];
    }
    
    layer.lineWidth = [STLoopProgressView lineWidth];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor; // 填充色为透明（不设置为黑色）
    layer.strokeColor = [UIColor blackColor].CGColor; // 随便设置一个边框颜色
    layer.lineCap = kCALineCapRound; // 设置线为圆角
    return layer;
}

/**
 *  在修改百分比的时候，修改彩色遮罩的大小
 *
 *  @param persentage 百分比
 */
- (void)setPersentage:(CGFloat)persentage {
    
    _persentage = persentage;
    self.colorMaskLayer.strokeEnd = persentage;
    
    if (persentage <= 1/6.0) {
         self.leftLayer.colors = @[(id)[STLoopProgressView color1].CGColor, (id)[STLoopProgressView color1].CGColor];
    } else if (persentage <= 2 / 6.0) {
         self.leftLayer.colors = @[(id)[STLoopProgressView color2].CGColor, (id)[STLoopProgressView color2].CGColor];
    } else if ( persentage <= 3 / 6.0) {
        self.leftLayer.colors = @[(id)[STLoopProgressView color3].CGColor, (id)[STLoopProgressView color3].CGColor];
    } else if (persentage <= 4 / 6.0) {
        self.leftLayer.colors = @[(id)[STLoopProgressView color4].CGColor, (id)[STLoopProgressView color4].CGColor];
    } else if (persentage <= 5 / 6.0) {
        self.leftLayer.colors = @[(id)[STLoopProgressView color5].CGColor, (id)[STLoopProgressView color5].CGColor];
    } else {
        self.leftLayer.colors = @[(id)[STLoopProgressView color6].CGColor, (id)[STLoopProgressView color6].CGColor];
    }
}

@end
