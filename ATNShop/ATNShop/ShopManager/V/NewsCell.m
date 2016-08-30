//
//  NewsCell.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/12.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "NewsCell.h"
#import "NewsModel.h"
@implementation NewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.timeLabel];
        
        [self addSubview:self.backView];
    }
    return self;
}


- (UIView *)backView {
    
    if (!_backView) {
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(15 * kMulriple, 35 * kHMulriple, 345 * kMulriple, 150 * kHMulriple)];
        _backView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:self.backImageView];
        [_backView addSubview:self.contentLabel];
    }
    return _backView;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 * kMulriple, 10 * kHMulriple, 175 * kMulriple, 15 * kHMulriple)];
        self.timeLabel.textColor = RGB(111, 111, 111);
        _timeLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _timeLabel;
}

- (UIImageView *)backImageView {
    
    if (!_backImageView) {
        
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * kMulriple, 10 * kHMulriple, 315 * kMulriple, 100 * kHMulriple)];
    }
    return _backImageView;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * kMulriple, 119 * kHMulriple, 315 * kMulriple, 20 * kHMulriple)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;

        _contentLabel.textColor = RGB(111, 111, 111);
        _contentLabel.font = [UIFont systemFontOfSize:15 * kMulriple];
    }
    return _contentLabel;
}

- (void)setModel:(NewsModel *)model {
    
    if (_model != model) {
        
        _model = model;
    }
    
    
    NSTimeInterval _interval = [model.createtime doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [objDateformat stringFromDate:date];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", dateString];

    self.backImageView.image = [UIImage imageNamed:@"backImageView"];
    self.contentLabel.text = model.content;
    self.contentLabel.frame = CGRectMake(15 * kMulriple, 119 * kHMulriple, 315 * kMulriple, [[self class] heightForContentText:self.contentLabel.text]);
    
    self.backView.frame = CGRectMake(15 * kMulriple, 35 * kHMulriple, 345 * kMulriple, [[self class] heightForContentText:self.contentLabel.text] + 128 * kHMulriple);
    
}

//提供外部接口 动态返回cell的高度
+ (CGFloat)heightForRowWithModel:(NewsModel *)model{
    
  return [[self class] heightForContentText:model.content] + 163 * kHMulriple;

}

//动态计算文本的高度
+ (CGFloat)heightForContentText:(NSString *)text{
    //文本渲染时需要一个矩形的大小 第一个参数:size 在限定的范围(宽高区域内) size(控件的宽度, 尽量大的高度值)
    //attributes属性:设置的字体大小要和控件(contentLabel)的字体大小匹配一致 避免出现计算偏差
    
    CGSize boudingSize = CGSizeMake(335, 300);
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    return [text boundingRectWithSize:boudingSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
}


@end
