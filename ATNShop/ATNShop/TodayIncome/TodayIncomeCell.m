//
//  TodayIncomeCell.m
//  ATNShop
//
//  Created by 王赛 on 16/10/10.
//  Copyright © 2016年 王赛. All rights reserved.
//
/**
@property (nonatomic, strong) UILabel *dayLabel;//日期
@property (nonatomic, strong) UILabel *weekLabel;//周几
@property (nonatomic, strong) UIImageView *posterImageView;//图片

@property (nonatomic, strong) UILabel *moneyLabel;//金额
@property (nonatomic, strong) UILabel *timeLabel;//具体时间
*/
#import "TodayIncomeCell.h"
#import "TodayIncomeModel.h"
@implementation TodayIncomeCell

-( instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.dayLabel];
        [self addSubview:self.weekLabel];
        [self addSubview:self.moneyLabel];
        [self addSubview:self.posterImageView];
        [self addSubview:self.timeLabel];
    }
    return self;
}
/** 号 */
-(UILabel *)dayLabel
{
    if (!_dayLabel) {
        self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 10 * kHMulriple, 50 * kMulriple, 30 * kHMulriple)];
        _dayLabel.textColor = RGB(111, 111, 111);
        _dayLabel.font = [UIFont systemFontOfSize:20*kMulriple];
        
    }
    return _dayLabel;
}


/** 星期 */
- (UILabel *)weekLabel {
    if (!_weekLabel) {
        self.weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 45 * kHMulriple, 30 * kMulriple, 15 * kHMulriple)];
        
        _weekLabel.textColor = RGB(111, 111, 111);
        _weekLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
    }
    return _weekLabel;
}


/** 头像 */
- (UIImageView *)posterImageView {
    if (!_posterImageView) {
        self.posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(75 * kMulriple, 10 * kHMulriple, 60 * kMulriple, 60 * kHMulriple)];
        _posterImageView.image = [UIImage imageNamed:@"userImage"];
        _posterImageView.layer.cornerRadius = 30 * kMulriple;
        _posterImageView.layer.masksToBounds = YES;
    }
    return _posterImageView;
}


/** 消费金额 */
-(UILabel *)moneyLabel{

    if (!_moneyLabel) {
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 *kMulriple, 40*kHMulriple, 250 *kMulriple, 30 *kHMulriple)];
        _moneyLabel.font = [UIFont systemFontOfSize:21 *kMulriple];
        _moneyLabel.textColor = RGB(111, 111, 111);
        
    }
    return _moneyLabel;
    
}

/** 具体时间 */
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(315 * kMulriple, 15 * kHMulriple, 60 * kMulriple, 15 * kHMulriple)];
        
        _timeLabel.textColor = RGB(111, 111, 111);
        _timeLabel.font = [UIFont systemFontOfSize:15 * kMulriple];
    }
    return _timeLabel;
}




-(void) setIncomemodel:(TodayIncomeModel *)incomemodel
{
    if (_incomemodel != incomemodel) {
        _incomemodel = incomemodel;
    }
    
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Service_Url,incomemodel.userPortrait]] placeholderImage:[UIImage imageNamed:@"userImage"]];
     
    NSTimeInterval _interval=[incomemodel.createtime doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [objDateformat stringFromDate:date];
    
    self.dayLabel.text = [NSString stringWithFormat:@"%@号", [dateString substringWithRange:NSMakeRange(8, 2)]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [dateString substringWithRange:NSMakeRange(11, 5)]];
    
    self.moneyLabel.text = [NSString stringWithFormat:@"+ %@",incomemodel.income];
    
    self.weekLabel.text = [NSString stringWithFormat:@"%@",[self featureWeekdayWithDate:dateString]];
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
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
}

//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
