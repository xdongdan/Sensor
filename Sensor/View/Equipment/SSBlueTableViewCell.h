//
//  SSBlueTableViewCell.h
//  Sensor
//
//  Created by xiaodongdan on 2017/10/27.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kBlueCellIdentifier = @"BlueCell";
@interface SSBlueTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *connect;

@property (nonatomic, assign) NSInteger state;

@end
