//
//  SSLoginViewController.m
//  Sensor
//
//  Created by xiaodongdan on 2017/10/23.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSLoginViewController.h"
#import "SSRegisterViewController.h"
#import "SSFindPasswordViewController.h"
#import "SSUser.h"

@interface SSLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTexfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *remerberPwd;

@end

@implementation SSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kRemeberPwd]) {
        self.remerberPwd.image = [UIImage imageNamed:@"ic_check_sel"];
        NSDictionary *data = [[NSUserDefaults standardUserDefaults] objectForKey:kPasswordData];
        if (CHECK_VALID_STRING(data[@"mobile"])) {
            self.phoneTexfield.text = data[@"mobile"];
        }
        if (CHECK_VALID_STRING(data[@"password"])) {
            self.pwdTextfield.text = data[@"password"];
        }
    } else {
        self.remerberPwd.image = [UIImage imageNamed:@"ic_check_unsel"];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kRemeberPwd]) {
        [self.phoneTexfield becomeFirstResponder];
    }
}

// 忘记密码
- (IBAction)forgetPsw:(id)sender {
    SSFindPasswordViewController *findVC = [[SSFindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findVC animated:YES];
}

// 新用户注册
- (IBAction)registerUser:(id)sender {
    SSRegisterViewController *registerVC = [[SSRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

// 登录
- (IBAction)login:(id)sender {
    if (![NSString checkMobilePhone:self.phoneTexfield.text]) {
        self.phoneTexfield.text = nil;
        [self yuy_hudAuto:@"手机号码格式不对"];
        return;
    }
    if (self.pwdTextfield.text.length < 6 || self.pwdTextfield.text.length > 30) {
        [self yuy_hudAuto:@"密码大等于6位小于30位"];
        return;
    }
    NSDictionary *data = @{@"mobile": self.phoneTexfield.text, @"password": self.pwdTextfield.text};
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kPasswordData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[SSHTTPManager sharedManager] APIDataWithURL:kLogin requestType:HTTPRequestTypePost data:data success:^(NSURLSessionDataTask *operation, NSDictionary *responseDic) {
        NSString *code = responseDic[@"code"];
        if ([code integerValue] == 0) {
            [[SSUserManager userManager] saveUser:responseDic[@"data"]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self yuy_hudAuto:responseDic[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self yuy_hudAuto:@"登录失败"];
    }];
    
}

// 记住密码
- (IBAction)remeberPwd:(id)sender {
    BOOL remeber = [[NSUserDefaults standardUserDefaults] boolForKey:kRemeberPwd];
    if (remeber) {
        self.remerberPwd.image = [UIImage imageNamed:@"ic_check_unsel"];
    } else {
        self.remerberPwd.image = [UIImage imageNamed:@"ic_check_sel"];
    }
    [[NSUserDefaults standardUserDefaults] setBool:!remeber forKey:kRemeberPwd];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.phoneTexfield) {
        
    }
    
    if (textField == self.pwdTextfield) {
        
    }
    return YES;
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
