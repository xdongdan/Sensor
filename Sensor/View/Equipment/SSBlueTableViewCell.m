//
//  SSBlueTableViewCell.m
//  Sensor
//
//  Created by xiaodongdan on 2017/10/27.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSBlueTableViewCell.h"

@implementation SSBlueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setState:(NSInteger)state {
    NSString *str = @"未连接";
    switch (state) {
        case 0:
            str = @"未连接";
            break;
        case 1:
            str = @"正在连接";
            break;
        case 2:
            str = @"已连接";
            break;
        default:
            break;
    }
    self.connect.text = str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
