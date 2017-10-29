//
//  SSBLEManager.m
//  Sensor
//
//  Created by xiaodongdan on 2017/10/29.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSBLEManager.h"
#import "SSMacro.h"

// 外设名字
static NSString *kPeripheralName = @"BLE-UART";

@interface SSBLEManager () <CBCentralManagerDelegate, CBPeripheralDelegate>


@end

@implementation SSBLEManager

+ (instancetype)sharedManager {
    static SSBLEManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SSBLEManager alloc] init];
        manager.peripheralArray = [NSMutableArray array];
    });
    return manager;
}

- (void)setDelegate:(id<SSBLEManagerDelegate>)delegate {
    _delegate = delegate;
    if (self.centralManager) {
        return;
    }
    dispatch_queue_t centeralQueue = dispatch_queue_create("CenterQueue", DISPATCH_QUEUE_SERIAL);
    // CBCentralManagerOptionShowPowerAlertKey:初始化的时候如果蓝牙没打开会弹出提示框
    // CBCentralManagerOptionRestoreIdentifierKey:用于蓝牙进程呗杀掉恢复连接时用的
    NSDictionary *options = @{CBCentralManagerOptionShowPowerAlertKey: [NSNumber numberWithBool:YES]};
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centeralQueue options:options];
}

- (void)scanPeripherals {
    [self.peripheralArray removeAllObjects];
    // 不重复扫描已发现设备
    NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO], CBCentralManagerOptionShowPowerAlertKey: @YES};
    [self.centralManager scanForPeripheralsWithServices:nil options:options];
}

- (void)cancelPeripheralConnection {
    [self.centralManager cancelPeripheralConnection:self.peripheral];
    self.peripheral = nil;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (self.delegate && [self.delegate respondsToSelector:@selector(BLECentralState:)]) {
        [self.delegate BLECentralState:central.state];
    }
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            //打开状态
            //开始扫描
            [self scanPeripherals];
            break;
        case CBCentralManagerStatePoweredOff:
            //关闭状态
            // 提示打开蓝牙
            break;
        case CBCentralManagerStateResetting:
            //复位
            break;
        case CBCentralManagerStateUnsupported:
            //表明设备不支持蓝牙低功耗
            break;
        case CBCentralManagerStateUnauthorized:
            //该应用程序是无权使用蓝牙低功耗
            break;
        case CBCentralManagerStateUnknown:
            //未知
            break;
        default:
            break;
    }
}

// peripheral：外设类
// advertisementData：广播的值，一般携带设备名，serviceUUIDs等信息
// RSSI：绝对值越大，表示信号越差，设备离得越远。如果想转换成百分比强度，(RSSI+100)/100
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (![self.peripheralArray containsObject:peripheral]) {
        [self.peripheralArray addObject:peripheral];
        if (self.delegate && [self.delegate respondsToSelector:@selector(findPeripherals:)]) {
            [self.delegate findPeripherals:self.peripheralArray];
        }
        if ([peripheral.name isEqualToString:kPeripheralName] && !self.peripheral) {
            // 连接外设
            [self connectPeripheral:peripheral];
        }
    }
}

// 连接外设
- (void)connectPeripheral:(CBPeripheral *)peripheral {
    [self.centralManager connectPeripheral:peripheral options:nil];
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    if (self.delegate && [self.delegate respondsToSelector:@selector(findPeripheral:)]) {
        [self.delegate findPeripheral:peripheral];
    }
}

// 连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self.centralManager stopScan];
    NSLog(@"%@", self.peripheralArray);
    // 连接成功后寻找服务，传nil会寻找所有服务
    [peripheral discoverServices:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(connectPeripheral:)]) {
        [self.delegate connectPeripheral:peripheral];
    }
}

// 连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (peripheral == self.peripheral) {
        self.peripheral = nil;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(failToConnectPeripheral:error:)]) {
        [self.delegate failToConnectPeripheral:peripheral error:error];
    }
}

// 连接断开
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (!self.peripheral) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(disconnectPeripheral:)]) {
        [self.delegate disconnectPeripheral:peripheral];
    }
    if (peripheral == self.peripheral) {
        self.peripheral = nil;
    }
}

#pragma mark - CBPeripheralDelegate
// 发现服务的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (!error) {
        for (CBService *service in peripheral.services) {
            if (service) {
                [peripheral discoverCharacteristics:nil forService:service];
            }
        }
    }
}

// 发现服务的特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        // 监听外设特征值
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
}

// 已经更新特征的值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateValueForCharacteristic:)]) {
        [self.delegate updateValueForCharacteristic:characteristic];
    }
}

@end
