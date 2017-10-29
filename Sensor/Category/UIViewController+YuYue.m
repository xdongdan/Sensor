//
//  UIViewController+YuYue.m
//  YuYueiPhone
//
//  Created by xiaodongdan on 15/10/26.
//  Copyright © 2015年 寓悦家居科技有限公司. All rights reserved.
//

#import "UIViewController+YuYue.h"


@implementation UIViewController (YuYue)

- (NSString *)stringWithTel:(NSString *)tel {
    return [NSString stringWithFormat:@"tel://%@", tel];
}

#pragma mark HUD（Head Up Display）相关
- (void)yuy_hudShowLoading:(NSString *)loadingStr {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = loadingStr;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
}

- (void)yuy_hudShowLoading{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中";
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
}

- (void)yuy_hudAuto:(NSString*)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.0];
}

- (void)yuy_hudHide{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)yuy_hudAllHide {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)hiddenTabBar {
    UITabBarController *tabbarcontroller = self.tabBarController;
    
    for(UIView *view in tabbarcontroller.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            view.hidden = YES;
        }
    }
}

- (void)showTabBar {
    UITabBarController *tabbarcontroller = self.tabBarController;
    for(UIView *view in tabbarcontroller.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            view.hidden = NO;
        }
    }
}

@end
