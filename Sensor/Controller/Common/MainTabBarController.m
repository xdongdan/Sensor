//
//  MainTabBarController.m
//  yuyueiphone
//
//  Created by Guangfeng Liu on 15/9/2.
//  Copyright (c) 2015年 寓悦家居科技有限公司. All rights reserved.
//

#import "MainTabBarController.h"

#import "SSUserSpaceViewController.h"
#import "SSHomeViewController.h"
#import "SSEquipmentViewController.h"
#import "SSLoginViewController.h"

@interface MainTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, strong) UINavigationController *userNavc;
@property (nonatomic, strong) UINavigationController *homeNavc;
@property (nonatomic, strong) UINavigationController *equipmentNavc;

@property (nonatomic, strong) NSArray *items;

@end

@implementation MainTabBarController{
    NSMutableArray *constraints;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self.tabBar setTintColor:[UIColor hxStringToColor:@"4692D0"]];
    
    SSUserSpaceViewController *userVC = [[SSUserSpaceViewController alloc] init];
    self.userNavc = [[UINavigationController alloc] initWithRootViewController:userVC];
    self.userNavc.tabBarItem.title = @"用户";
    self.userNavc.tabBarItem.image = [UIImage imageNamed:@"ic_tab_mine_nor"];
    
    SSHomeViewController *homeVC = [[SSHomeViewController alloc] init];
    self.homeNavc = [[UINavigationController alloc] initWithRootViewController:homeVC];
    self.homeNavc.tabBarItem.title = @"主页";
    self.homeNavc.tabBarItem.image = [UIImage imageNamed:@"ic_tab_star_nor"];
    
    SSEquipmentViewController *equipmentVC = [[SSEquipmentViewController alloc] init];
    self.equipmentNavc = [[UINavigationController alloc] initWithRootViewController:equipmentVC];
    self.equipmentNavc.tabBarItem.title = @"设备";
    self.equipmentNavc.tabBarItem.image = [UIImage imageNamed:@"ic_tab_ck_nor"];
    
    self.viewControllers = @[self.userNavc, self.homeNavc, self.equipmentNavc];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController {
    if (viewController == self.equipmentNavc) {
        if (![SSUserManager userManager].isLogin) {
            SSLoginViewController *loginVC = [[SSLoginViewController alloc] init];
            [self.homeNavc pushViewController:loginVC animated:YES];
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

@end
