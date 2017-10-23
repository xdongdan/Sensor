//
//  SSUserSpaceViewController.m
//  Sensor
//
//  Created by xiaodongdan on 2017/10/23.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSUserSpaceViewController.h"

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

- (IBAction)login:(id)sender {
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
