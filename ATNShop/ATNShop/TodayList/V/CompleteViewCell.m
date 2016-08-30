//
//  CompleteViewCell.m
//  @你
//
//  Created by 吴明飞 on 16/5/16.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "CompleteViewCell.h"
#import "CompleteModel.h"
@implementation CompleteViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.dayLabel];
        [self addSubview:self.weekLabel];
        [self addSubview:self.posterImageView];
        [self addSubview:self.priceLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.timeLabel];
        
    }
    return self;
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
        self.weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 45 * kHMulriple, 40 * kMulriple, 15 * kHMulriple)];
        
        _weekLabel.textColor = RGB(111, 111, 111);
        _weekLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
    }
    return _weekLabel;
}

- (UIImageView *)posterImageView {
    if (!_posterImageView) {
        self.posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(75 * kMulriple, 10 * kHMulriple, 55 * kMulriple, 55 * kHMulriple)];
        _posterImageView.layer.cornerRadius = 27.5 * kMulriple;
        _posterImageView.layer.masksToBounds = YES;
    }
    return _posterImageView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(140 * kMulriple, 10 * kHMulriple, 90 * kMulriple, 30 * kHMulriple)];
        
        _priceLabel.textColor = RGB(111, 111, 111);
        _priceLabel.font = [UIFont systemFontOfSize:20 * kMulriple];
    }
    return _priceLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140 * kMulriple, 45 * kHMulriple, 230 * kMulriple, 15 * kHMulriple)];
        _nameLabel.textColor = RGB(111, 111, 111);
        _nameLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(305 * kMulriple, 15 * kHMulriple, 60 * kMulriple, 15 * kHMulriple)];
        
        _timeLabel.textColor = RGB(111, 111, 111);
        _timeLabel.font = [UIFont systemFontOfSize:15 * kMulriple];
    }
    return _timeLabel;
}

- (void)setCompleteModel:(CompleteModel *)completeModel {
    
    if (_completeModel != completeModel) {
        
        _completeModel = completeModel;
    }
    
    
    NSTimeInterval _interval=[completeModel.updatetime doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [objDateformat stringFromDate:date];
   
    NSString *substring = [dateString substringWithRange:NSMakeRange(8, 2)];
    if ([substring integerValue] > 9) {
        
        self.dayLabel.text = [NSString stringWithFormat:@"%@号", substring];
    } else {
        
        self.dayLabel.text = [NSString stringWithFormat:@"%@号", [substring substringWithRange:NSMakeRange(1, 1)]];
    }

    self.timeLabel.text = [NSString stringWithFormat:@"%@", [dateString substringWithRange:NSMakeRange(11, 5)]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@", completeModel.amount];
    self.nameLabel.text = completeModel.userName;
    
    self.weekLabel.text = [NSString stringWithFormat:@"%@", [self featureWeekdayWithDate:dateString]];
    
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Service_Url, completeModel.userPortrait]] placeholderImage:[UIImage imageNamed:@"userImage"]];
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
