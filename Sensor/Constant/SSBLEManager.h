//
//  SSBLEManager.h
//  Sensor
//
//  Created by xiaodongdan on 2017/10/29.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol SSBLEManagerDelegate <NSObject>

@optional

// BLE状态
- (void)BLECentralState:(NSInteger)state;

// 发现外设
- (void)findPeripherals:(NSArray *)peripherals;
- (void)findPeripheral:(CBPeripheral *)peripheral;

// 外设连接成功
- (void)connectPeripheral:(CBPeripheral *)peripheral;

// 外设连接失败
- (void)failToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

// 断开外设连接
- (void)disconnectPeripheral:(CBPeripheral *)peripheral;

// 外设返回的数据
- (void)updateValueForCharacteristic:(CBCharacteristic *)characteristic;


@end


@interface SSBLEManager : NSObject 

@property (nonatomic, weak) id <SSBLEManagerDelegate>delegate;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSMutableArray *peripheralArray;

+ (instancetype)sharedManager;

// 扫描外设
- (void)scanPeripherals;

// 连接外设
- (void)connectPeripheral:(CBPeripheral *)peripheral;

// 断开外设连接
- (void)cancelPeripheralConnection;

// 重置数据
- (void)resetData;


@end
