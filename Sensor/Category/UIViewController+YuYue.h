//
//  UIViewController+YuYue.h
//  YuYueiPhone
//
//  Created by xiaodongdan on 15/10/26.
//  Copyright © 2015年 寓悦家居科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YuYue)


- (NSString *)stringWithTel:(NSString *)tel;

#pragma mark - HUD相关API，所有API都以hud开头[self yuy_hudxxx]
- (void)yuy_hudShowLoading:(NSString *)loadingStr;
- (void)yuy_hudShowLoading;
- (void)yuy_hudHide;
- (void)yuy_hudAllHide;

- (void)hiddenTabBar;
- (void)showTabBar;



@end
