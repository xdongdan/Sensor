//
//  SSHomeViewController.m
//  Sensor
//
//  Created by xiaodongdan on 2017/10/23.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSHomeViewController.h"
#import "STLoopProgressView.h"
#import "SSWeather.h"
#import "STLoopProgressView+BaseConfiguration.h"

#import "SSCityViewController.h"

@interface SSHomeViewController ()

@property (weak, nonatomic) IBOutlet STLoopProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *quality;
@property (weak, nonatomic) IBOutlet UILabel *pm2_5;
@property (weak, nonatomic) IBOutlet UILabel *temp;
@property (weak, nonatomic) IBOutlet UILabel *weather;
@property (weak, nonatomic) IBOutlet UILabel *wind;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic, strong) SSWeather *data;
@property (nonatomic, strong) NSString *city;

@end

@implementation SSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
    self.city = [[NSUserDefaults standardUserDefaults] valueForKey:kLocationCity];
    WEAKSELF
    [self addRightBarButtonItemWithImageName:@"ic_refresh" block:^{
        STRONGSELF
        [strongSelf loadData];
    }];
    self.progressView.persentage = 0;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTabBar];
    self.location.text = self.city;
    [self loadData];
}

- (void)loadData {
    [self yuy_hudShowLoading];
    if (CHECK_VALID_STRING(self.city)) {
        NSMutableDictionary *data = [@{@"city": self.city} mutableCopy];
        if ([SSUserManager userManager].isLogin) {
            [data setObject:[SSUserManager userManager].user.token forKey:@"token"];
        }
        [[SSHTTPManager sharedManager] APIDataWithURL:kGetWeatherData requestType:HTTPRequestTypeGet data:data success:^(NSURLSessionDataTask *operation, NSDictionary *responseDic) {
            [self yuy_hudHide];
            NSString *code = responseDic[@"code"];
            if ([code integerValue] == 0) {
                [[NSUserDefaults standardUserDefaults] setValue:responseDic[@"data"] forKey:kWeatherData];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.data = [SSWeather mj_objectWithKeyValues:responseDic[@"data"]];
                [self refreshView];
            } else {
                [self yuy_hudAuto:responseDic[@"msg"]];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [self yuy_hudHide];
            [self yuy_hudAuto:@"天气加载失败"];
        }];
    }
}

- (void)refreshView {
    self.progressView.persentage = [STLoopProgressView currentPercentWithNum:[self.data.pm2_5 floatValue]];
    self.pm2_5.text = self.data.pm2_5;
    self.pm2_5.textColor = [STLoopProgressView currentColorWithNum:[self.data.pm2_5 floatValue]];
    self.quality.text = self.data.quality;
    self.quality.textColor = [STLoopProgressView currentColorWithNum:[self.data.pm2_5 floatValue]];
    self.temp.text = [NSString stringWithFormat:@"%@°", self.data.temp];
    self.weather.text = self.data.weather;
    self.wind.text = [NSString stringWithFormat:@"%@%@", self.data.winddirect, self.data.windpower];
}

- (IBAction)changeCity:(id)sender {
    SSCityViewController *cityVC = [[SSCityViewController alloc] init];
    [cityVC returnText:^(NSString *cityname) {
        self.city = cityname;
        [self loadData];
    }];

    [self.navigationController pushViewController:cityVC animated:YES];
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
