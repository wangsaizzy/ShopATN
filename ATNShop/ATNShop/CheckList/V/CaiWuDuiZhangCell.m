//
//  CaiWuDuiZhangCell.m
//  ATN
//
//  Created by 吴明飞 on 16/4/27.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "CaiWuDuiZhangCell.h"
#import "CaiWuModel.h"
@implementation CaiWuDuiZhangCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.dayLabel];
        [self addSubview:self.weekLabel];
        [self addSubview:self.posterImageView];
        [self addSubview:self.priceLabel];
        [self addSubview:self.typeLabel];
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * kMulriple, 79.5 * kHMulriple, kWight, 0.3 * kHMulriple)];
    lineLabel.backgroundColor = RGB(111, 111, 111);
    [self addSubview:lineLabel];
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 10 * kHMulriple, 50 * kMulriple, 30 * kHMulriple)];
        _dayLabel.textColor = RGB(111, 111, 111);
        _dayLabel.font = [UIFont systemFontOfSize:20 * kMulriple];
    }
    return _dayLabel;
}

- (UILabel *)weekLabel {
    if (!_weekLabel) {
        self.weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 45 * kHMulriple, 30 * kMulriple, 15 * kHMulriple)];
        _weekLabel.textColor = RGB(111, 111, 111);
        _weekLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
    }
    return _weekLabel;
}

- (UIImageView *)posterImageView {
    if (!_posterImageView) {
        self.posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85 * kMulriple, 13 * kHMulriple, 55 * kMulriple, 55 * kHMulriple)];
        _posterImageView.layer.cornerRadius = 27.5 * kMulriple;
        _posterImageView.layer.masksToBounds = YES;
        
    }
    return _posterImageView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(160 * kMulriple, 10 * kHMulriple, 160 * kMulriple, 30 * kHMulriple)];
        _priceLabel.textColor = RGB(111, 111, 111);
        _priceLabel.font = [UIFont systemFontOfSize:20 * kMulriple];
    }
    return _priceLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(160 * kMulriple, 50 * kHMulriple, 100 * kMulriple, 15 * kHMulriple)];
        _typeLabel.text = @"线下消费";
        _typeLabel.textColor = RGB(111, 111, 111);
        _typeLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
    }
    return _typeLabel;
}

- (void)setModel:(CaiWuModel *)model {
    
    if (_model != model) {
        
        _model = model;
    }
    
    NSTimeInterval _interval=[model.updatetime doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [objDateformat stringFromDate:date];
    
    self.dayLabel.text = [NSString stringWithFormat:@"%@号", [dateString substringWithRange:NSMakeRange(8, 2)]];
    
    float cash = [model.amount floatValue] - [model.backAmount floatValue];
    
    self.priceLabel.text = [NSString stringWithFormat:@"+%.2f", cash];
    
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Service_Url, model.userPortrait]] placeholderImage:[UIImage imageNamed:@"userImage"]];
    
    self.weekLabel.text = [NSString stringWithFormat:@"%@", [self featureWeekdayWithDate:dateString]];
    
}

/**
 *  获取未来某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
- (NSString *)featureWeekdayWithDate:(NSString *)featureDate{
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy-MM-dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *endDate = [formatter dateFromString:featureDate];
    // 判断当前日期 和 未来某个时刻日期 相差的天数
    long days = [self daysFromDate:[NSDate date] toDate:endDate];
    // 将总天数 换算为 以 周 计算（假如 相差10天，其实就是等于 相差 1周零3天，只需要取3天，更加方便计算）
    long day = days >= 7 ? days % 7 : days;
    long week = [self getNowWeekday] + day;
    switch (week) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
            
        default:
            break;
    }
    return nil;
}

/**
 *  计算2个日期相差天数
 *  startDate   起始日期
 *  endDate     截至日期
 */
-(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/3600/60;
    if (days <= 0 && hours <= 0&&minute<= 0) {
    
        return 0;
    }
    else {
        
        // 之所以要 + 1，是因为 此处的days 计算的结果 不包含当天 和 最后一天\
        （如星期一 和 星期四，计算机 算的结果就是2天（星期二和星期三），日常算，星期一——星期四相差3天，所以需要+1）\
        对于时分 没有进行计算 可以忽略不计
        return days + 1;
    }
}

// 获取当前是星期几
- (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
}


@end
