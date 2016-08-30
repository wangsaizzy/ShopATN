//
//  AppointmentCell.m
//  ATN
//
//  Created by 吴明飞 on 16/4/29.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "AppointmentCell.h"

@implementation AppointmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.dayLabel];
        [self addSubview:self.weekLabel];
        [self addSubview:self.posterImageView];
        
        
    }
    return self;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 10 * kHMulriple, 50 * kMulriple, 30 * kHMulriple)];
        _dayLabel.text = @"28号";
        _dayLabel.textColor = RGB(111, 111, 111);
        _dayLabel.font = [UIFont systemFontOfSize:20 * kMulriple];
    }
    return _dayLabel;
}

- (UILabel *)weekLabel {
    if (!_weekLabel) {
        self.weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 45 * kHMulriple, 30 * kMulriple, 15 * kHMulriple)];
        _weekLabel.text = @"周日";
        _weekLabel.textColor = RGB(111, 111, 111);
        _weekLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
    }
    return _weekLabel;
}

- (UIImageView *)posterImageView {
    if (!_posterImageView) {
        self.posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85 * kMulriple, 10 * kHMulriple, 60 * kMulriple, 60 * kHMulriple)];
        _posterImageView.image = [UIImage imageNamed:@"userImage"];
    }
    return _posterImageView;
}

@end
