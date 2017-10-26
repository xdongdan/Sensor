//
//  SSEquipmentViewController.m
//  Sensor
//
//  Created by xiaodongdan on 2017/10/23.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSEquipmentViewController.h"
#import "SSWeather.h"
#import "SSBluetoothViewController.h"

@interface SSEquipmentViewController ()

@property (nonatomic, strong) UIImageView *navigationImageView;

@property (weak, nonatomic) IBOutlet UIView *bluetoothIcon;
@property (weak, nonatomic) IBOutlet UIView *state;     // 连接状态
@property (weak, nonatomic) IBOutlet UIView *pm2_5View;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@end

@implementation SSEquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备";
    self.navigationImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    self.pm2_5View.layer.cornerRadius = (ScreenWidth - 160) / 2;
    
    WEAKSELF
    [self addRightBarButtonItemWithImageName:@"ic_search" block:^{
        STRONGSELF
        SSBluetoothViewController *bluetoothVC = [[SSBluetoothViewController alloc] init];
        [strongSelf.navigationController pushViewController:bluetoothVC animated:YES];
    }];

    NSDictionary *data = [[NSUserDefaults standardUserDefaults] valueForKey:kWeatherData];
    SSWeather *weather = [SSWeather mj_objectWithKeyValues:data];
    self.weatherLabel.text = [NSString stringWithFormat:@"%@   %@   %@%@   %@   %@", weather.city, weather.weather, weather.winddirect, weather.windpower, weather.pm2_5, weather.quality];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTabBar];
    self.navigationImageView.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationImageView.hidden = NO;
}

-(UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
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
