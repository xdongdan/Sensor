//
//  SSUserSpaceViewController.m
//  Sensor
//
//  Created by xiaodongdan on 2017/10/23.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSUserSpaceViewController.h"
#import "SSLoginViewController.h"

@interface SSUserSpaceViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SSUserSpaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTabBar];
    [self setData];
}

- (void)setData {
    SSUser *user = [SSUserManager userManager].user;
    if ([SSUserManager userManager].isLogin) {
        self.nickName.text = user.nickname;
        self.phone.text = user.username;
        [self.loginButton setTitle:@"退出" forState:UIControlStateNormal];
    } else {
        self.nickName.text = @"未登录";
        self.phone.text = @"未登录";
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    }
}

- (IBAction)login:(id)sender {
    if ([SSUserManager userManager].isLogin) {
        [self yuy_hudShowLoading:nil];
        [[SSHTTPManager sharedManager] APIDataWithURL:kLoginOut requestType:HTTPRequestTypePost data:@{@"mobile": [SSUserManager userManager].user.username, @"token": [SSUserManager userManager].user.token} success:^(NSURLSessionDataTask *operation, NSDictionary *responseDic) {
            [self yuy_hudHide];
            NSString *code = responseDic[@"code"];
            if ([code integerValue] == 0) {
                [[SSUserManager userManager] deleteUser];
                [self setData];
            } else {
                [self yuy_hudAuto:responseDic[@"msg"]];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [self yuy_hudHide];
            [self yuy_hudAuto:@"退出失败"];
        }];
    } else {
        SSLoginViewController *loginVC = [[SSLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
