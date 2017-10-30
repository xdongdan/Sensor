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
#import "SSBLEManager.h"

@interface SSEquipmentViewController () <SSBLEManagerDelegate>

@property (nonatomic, strong) UIImageView *navigationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bluetoothIcon;

@property (weak, nonatomic) IBOutlet UILabel *state;     // 连接状态
@property (weak, nonatomic) IBOutlet UIView *pm25View;
@property (weak, nonatomic) IBOutlet UILabel *pm25Label;
@property (weak, nonatomic) IBOutlet UILabel *quality;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@property (nonatomic, assign) NSInteger bleState;  // 蓝牙状态
@property (nonatomic, strong) NSMutableArray *incomeData;
@property (nonatomic, strong) NSMutableArray *averaeArray;

@property (nonatomic, assign) NSInteger pm25;
@property (weak, nonatomic) IBOutlet UIView *animationView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint2;

@property (nonatomic, assign) NSTimeInterval lastUpdate;

@end

@implementation SSEquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备";
    self.navigationImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    self.pm25View.layer.cornerRadius = (ScreenWidth - 100) / 2;
    self.animationView.layer.cornerRadius = (ScreenWidth - 100) / 2;
    
     if (ScreenWidth == 320) {
        self.constraint1.constant = -5;
         self.constraint2.constant = -5;
    }
        
    WEAKSELF
    [self addRightBarButtonItemWithImageName:@"ic_search" block:^{
        STRONGSELF
        if (strongSelf.bleState == CBCentralManagerStatePoweredOff) {
            [strongSelf alertOpenBLE];
            return;
        }
        SSBluetoothViewController *vc = [[SSBluetoothViewController alloc] init];
        [strongSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    self.incomeData = [NSMutableArray array];
    self.averaeArray = [NSMutableArray array];

    NSDictionary *data = [[NSUserDefaults standardUserDefaults] valueForKey:kWeatherData];
    if (!data) {
        return;
    }
    SSWeather *weather = [SSWeather mj_objectWithKeyValues:data];
    self.weatherLabel.text = [NSString stringWithFormat:@"%@   %@   %@%@   %@   %@", weather.city, weather.weather, weather.winddirect, weather.windpower, weather.pm2_5, weather.quality];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTabBar];
    self.navigationImageView.hidden = YES;
    [SSBLEManager sharedManager].delegate = self;
    
    if (self.bleState == CBCentralManagerStatePoweredOff) {
        [self alertOpenBLE];
    }
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

- (void)alertOpenBLE {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"蓝牙服务未开启，请在系统设置中开启蓝牙" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *set = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Bluetooth"]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:set];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateViewWithVount:(CGFloat)currentVount {
    if (self.averaeArray.count >= 50) {
        [self.averaeArray removeObjectAtIndex:0];
    }
    [self.averaeArray addObject:[NSNumber numberWithFloat:currentVount]];
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (self.lastUpdate == 0) {
        self.lastUpdate = now;
    } else {
        if (now - self.lastUpdate < 1) {
            return;
        }
    }
    self.lastUpdate = now;
    
    CGFloat sum = 0;
    for (NSNumber *num in self.averaeArray) {
        sum += num.floatValue;
    }
    
    CGFloat finalVount = sum / self.averaeArray.count;
    
    if (self.pm25 == (NSInteger)finalVount) {
        return;
    }
    self.pm25 = (NSInteger)finalVount;
    UIColor *color = nil;;
    NSString *quality = nil;
    if (self.pm25 < 35) {
        color = [STLoopProgressView color1];
        quality = @"优";
    } else if (self.pm25 < 75) {
        color = [STLoopProgressView color2];
        quality = @"良";
    } else if (self.pm25 < 115) {
        color = [STLoopProgressView color3];
        quality = @"轻度污染";
    } else if (self.pm25 < 150) {
        color = [STLoopProgressView color4];
        quality = @"中度污染";
    } else if (self.pm25 < 250) {
        color = [STLoopProgressView color5];
        quality = @"重度污染";
    } else {
        color = [STLoopProgressView color6];
        quality = @"严重污染";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pm25Label.text = [NSString stringWithFormat:@"%@", @(self.pm25).description];
        self.pm25View.backgroundColor = color;
        self.quality.text = quality;
        self.animationView.backgroundColor = color;
        self.animationView.alpha = .7;
        
        if (self.animationView.layer.animationKeys.count > 0) {
            return;
        }
        
        CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = 1;
        animation.fromValue = @ (1);
        animation.toValue = @ (1.2);
        animation.removedOnCompletion = NO ;
        animation.repeatCount = HUGE_VALF;
        animation.fillMode = kCAFillModeForwards;
        [self.animationView.layer addAnimation:animation forKey:@"transform.scale"];
        
        CABasicAnimation *opacityAnimation = [ CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = 1;
        opacityAnimation.fromValue = @ (.7);
        opacityAnimation.toValue = @ (0);
        opacityAnimation.removedOnCompletion = NO ;
        opacityAnimation.repeatCount = HUGE_VALF;
        opacityAnimation.fillMode = kCAFillModeForwards;
        [self.animationView.layer addAnimation:opacityAnimation forKey:@"opacity"];
    });
}

#pragma mark - SSBLEManagerDelegate
- (void)BLECentralState:(NSInteger)state {
    self.bleState = state;
    switch (state) {
        case CBCentralManagerStatePoweredOff:
            // 未开启蓝牙
            [self alertOpenBLE];
            break;
            
        default:
            break;
    }
}

- (void)findPeripheral:(CBPeripheral *)peripheral {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self yuy_hudShowLoading];
        self.bluetoothIcon.image = [UIImage imageNamed:@"ic_bluetooth_connected_white"];
        self.state.text = @"车内空气净化器 正在连接";
    });
}

- (void)connectPeripheral:(CBPeripheral *)peripheral {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bluetoothIcon.image = [UIImage imageNamed:@"ic_bluetooth_connected_white"];
        self.state.text = @"车内空气净化器 已连接";
    });
}

- (void)failToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self yuy_hudHide];
        self.bluetoothIcon.image = [UIImage imageNamed:@"ic_bluetooth_disabled_white"];
        self.state.text = [NSString stringWithFormat:@"车内空气净化器 连接失败：%@", error.domain];
    });
}

- (void)disconnectPeripheral:(CBPeripheral *)peripheral {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self yuy_hudHide];
        self.bluetoothIcon.image = [UIImage imageNamed:@"ic_bluetooth_disabled_white"];
        self.state.text = [NSString stringWithFormat:@"车内空气净化器 断开连接"];
    });
}

- (void)updateValueForCharacteristic:(CBCharacteristic *)characteristic {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self yuy_hudHide];
    });
    NSString *data = [NSString convertDataToHexStr:characteristic.value];
    if ([data isEqualToString:@"aa"]) {
        [self.incomeData removeAllObjects];
        return;
    } else if ([data isEqualToString:@"ff"]) {
        if (self.incomeData.count == 5) {
            NSInteger voutH = strtoul([self.incomeData[0] UTF8String],0,16);
            NSInteger voutL =  strtoul([self.incomeData[1] UTF8String],0,16);
            CGFloat pm25 = (voutH * 256 + voutL) / 1024. * 5 * 1100;
            [self updateViewWithVount:pm25];
        }
        [self.incomeData removeAllObjects];
        return;
    }
    [self.incomeData addObject:data];
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
