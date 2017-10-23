//
//  UIView+YuYue.h
//  YuYueiPhone
//
//  Created by xiaodongdan on 15/10/27.
//  Copyright © 2015年 寓悦家居科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

typedef enum : NSUInteger {
    ViewLayerTop,
    ViewLayerLeft,
    ViewLayerBottom,
    ViewLayerRight,
} ViewLayer;

@interface UIView (YuYue)

@property (readonly) UIViewController *viewController;

#pragma mark - BlockGesture
- (void)addTapActionWithBlock:(GestureActionBlock)block;
- (void)addLongPressActionWithBlock:(GestureActionBlock)block;

#pragma mark frame
// shortcuts for frame properties
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

// shortcuts for positions
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;


@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat left;

/**
 *  相当于left/top
 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

//递归得到所有的subview（不仅仅是子视图）
- (NSMutableArray*)allSubViews;
/**
 *  添加到某个view，并且当作他的子视图
 *
 *  @param parentView <#parentView description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)addTo:(UIView*)parentView;

/**
 *  在宽度一定的情况下得到高度(UIlabel高度计算)
 *
 *  @param width 期望的宽度
 *
 *  @return 高度
 */
- (CGFloat)heightWithWidth:(CGFloat)width;
@end
