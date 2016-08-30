//
//  HistoryCashCell.m
//  ATN
//
//  Created by 吴明飞 on 16/4/28.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "HistoryCashCell.h"
#import "HistoryCashModel.h"
@implementation HistoryCashCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.cashLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.statusLabel];
        
    }
    return self;
}

//提现金额
- (UILabel *)cashLabel {
    if (!_cashLabel) {
        self.cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 32.5 * kHMulriple, 160 * kMulriple, 25 * kHMulriple)];
        self.cashLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        _cashLabel.textColor = [UIColor redColor];
    }
    return _cashLabel;
}

//时间
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(180 * kMulriple, 15 * kHMulriple, 175 * kMulriple, 25 * kHMulriple)];
        _timeLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = RGB(111, 111, 111);

    }
    return _timeLabel;
}

//状态
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(180 * kMulriple, 45 * kHMulriple, 175 * kMulriple, 25 * kHMulriple)];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        _statusLabel.textColor = [UIColor redColor];
    }
    return _statusLabel;
}

- (void)setModel:(HistoryCashModel *)model {
    
    if (_model != model) {
        
        _model = model;
    }
    
    NSTimeInterval _interval=[model.createtime doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [objDateformat stringFromDate:date];
    self.timeLabel.text = dateString;
    self.cashLabel.text = [NSString stringWithFormat:@"￥%@", model.amount];
    if ([model.status isEqualToString:@"WAIT"]) {
        
        self.statusLabel.text = @"等待审核";
    }
    if ([model.status isEqualToString:@"ING"]) {
        
        self.statusLabel.text = @"审核中";
    }
    if ([model.status isEqualToString:@"SUCCESS"]) {
        
        self.statusLabel.text = @"审核通过，已打款";
    }
    if ([model.status isEqualToString:@"FAIL"]) {
        
        self.statusLabel.text = @"审核失败";
    }
}

@end
