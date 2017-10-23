//
//  SSBaseViewController.h
//  Sensor
//
//  Created by xiaodongdan on 2017/10/23.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIView+YuYue.h"
#import "UIScreen+YuYue.h"
#import "UIControl+Blocks.h"
#import "SSHTTPManager.h"
#import "MJExtension.h"
#import "UIViewController+YuYue.h"

#import "SSMacro.h"

static CGFloat StatuBarHeight = 20;
static CGFloat NavigationBarHeight = 64;
static CGFloat TabBarHeight = 49;

typedef void(^leftBarButtonItemTapBlock)(void);
typedef void(^rightBarButtonItemTapBlock)(void);
typedef void(^errorBlock)(void);

@interface SSBaseViewController : UIViewController

@property (nonatomic, copy) leftBarButtonItemTapBlock leftBlock;
@property (nonatomic, copy) rightBarButtonItemTapBlock rightBlock;

@property (nonatomic, strong) AFURLSessionManager *sessionManager;

- (void)cancelTasks;

-(UINavigationController*)mainNavigationController;

- (void)addLeftBarButtonItemWithTitle:(NSString *)title block:(leftBarButtonItemTapBlock)block;
- (void)addRightBarButtonItemWithTitle:(NSString *)title block:(rightBarButtonItemTapBlock)block;

- (void)addLeftBarButtonItemWithImageName:(NSString *)imageName block:(leftBarButtonItemTapBlock)block;
- (void)addRightBarButtonItemWithImageName:(NSString *)imageName block:(rightBarButtonItemTapBlock)block;

- (void)backButtonTapped;

- (void)login;
- (BOOL)isLogined;
- (void)loginSucess;
- (void)loginCancel;

@end
