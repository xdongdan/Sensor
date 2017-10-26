//
//  SSRegisterViewController.m
//  Sensor
//
//  Created by xiaodongdan on 2017/10/24.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSRegisterViewController.h"

@interface SSRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *codeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextfield;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *selImage;
@property (weak, nonatomic) IBOutlet UIButton *selButton;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property(nonatomic,assign) int verificationTime; //时间
@property (nonatomic, strong) NSTimer *timer;//定时器

@end

@implementation SSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.selButton.selected = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.phoneTextfield becomeFirstResponder];
}

- (IBAction)getCode:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    self.verificationTime = 90;

    if (![NSString checkMobilePhone:self.phoneTextfield.text]) {
        [self yuy_hudAuto:@"手机号码格式不对"];
         sender.userInteractionEnabled = YES;
        return;
    }
    [[SSHTTPManager sharedManager] APIDataWithURL:kSendVerifyCode requestType:HTTPRequestTypePost data:@{@"mobile": self.phoneTextfield.text, @"purpose": @"register"} success:^(NSURLSessionDataTask *operation, NSDictionary *responseDic) {
        NSString *code = responseDic[@"code"];
        if (code.integerValue == 0) {
            [self yuy_hudAuto:@"验证码发送成功"];
            self.timer =[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            [self updateTimer];
        } else {
            [self yuy_hudAuto:responseDic[@"msg"]];
             sender.userInteractionEnabled = YES;
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self yuy_hudAuto:@"验证码发送失败"];
        sender.userInteractionEnabled = YES;
    }];
}

- (void)updateTimer {
    int temp = self.verificationTime--;
    NSString *string = [NSString stringWithFormat:@"%ds",temp];
    [self.codeBtn setTitle:string forState:UIControlStateNormal];
    if(temp<=0){
        [self.timer invalidate];
        NSString * string = @"重新获取";
        [self.codeBtn setTitle:string forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = YES;
    }
}

- (IBAction)registerUser:(id)sender {
    if (![NSString checkMobilePhone:self.phoneTextfield.text]) {
        [self yuy_hudAuto:@"手机号码格式不对"];
        return;
    }
    if (!CHECK_VALID_STRING(self.codeTextfield.text)) {
        [self yuy_hudAuto:@"请输入验证码"];
        return;
    }
    if (self.pwdTextfield.text.length < 6 || self.pwdTextfield.text.length > 30) {
        [self yuy_hudAuto:@"密码大等于6位小于30位"];
        return;
    }
    if (!CHECK_VALID_STRING(self.nicknameTextfield.text)) {
        [self yuy_hudAuto:@"请输入昵称"];
        return;
    }
    [[SSHTTPManager sharedManager] APIDataWithURL:kRegister requestType:HTTPRequestTypePost data:@{@"mobile": self.phoneTextfield.text, @"verifyCode": self.codeTextfield.text, @"password": self.pwdTextfield.text, @"nickname": self.nicknameTextfield.text} success:^(NSURLSessionDataTask *operation, NSDictionary *responseDic) {
        NSString *code = responseDic[@"code"];
        if (code.integerValue == 0) {
            [self yuy_hudAuto:@"注册成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self yuy_hudAuto:responseDic[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self yuy_hudAuto:@"注册失败"];
    }];
}
- (IBAction)userDeal:(id)sender {
    self.selButton.selected = !self.selButton.selected;
    if (self.selButton.selected) {
        self.selImage.image = [UIImage imageNamed:@"ic_check_sel"];
    } else {
        self.selImage.image = [UIImage imageNamed:@"ic_check_unsel"];
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
