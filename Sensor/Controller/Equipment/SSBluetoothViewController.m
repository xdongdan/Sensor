//
//  SSBluetoothViewController.m
//  Sensor
//
//  Created by xiaodongdan on 2017/10/26.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSBluetoothViewController.h"
#import "SSBlueTableViewCell.h"

#import "SSBLEManager.h"

@interface SSBluetoothViewController () <UITableViewDelegate, UITableViewDataSource, SSBLEManagerDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SSBluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"所有设备";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SSBlueTableViewCell class]) bundle:nil] forCellReuseIdentifier:kBlueCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
        
    [SSBLEManager sharedManager].delegate = self;
    self.dataArray = [SSBLEManager sharedManager].peripheralArray;
    
    WEAKSELF
    [self addRightBarButtonItemWithImageName:@"ic_refresh" block:^{
        STRONGSELF
        [strongSelf yuy_hudShowLoading:@"搜索设备中"];
        strongSelf.dataArray = nil;
        [strongSelf.tableView reloadData];
        [[SSBLEManager sharedManager] scanPeripherals];
    }];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - SSBLEManagerDelegate
- (void)findPeripherals:(NSArray *)peripherals {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataArray = peripherals;
        [self yuy_hudHide];
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSBlueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBlueCellIdentifier forIndexPath:indexPath];
    CBPeripheral *peripheral = self.dataArray[indexPath.row];
    if (CHECK_VALID_STRING(peripheral.name)) {
        cell.name.text = peripheral.name;
    } else {
        cell.name.text = @"Unnamed";
    }
    cell.state = peripheral.state;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CBPeripheral *peripheral = self.dataArray[indexPath.row];
        [[SSBLEManager sharedManager] connectPeripheral:peripheral];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
