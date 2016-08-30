//
//  AroundInformationCell.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/9.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "AroundInformationCell.h"

@implementation AroundInformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.posterImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subtitleLabel];
    }
    return self;
}


- (UIImageView *)posterImageView {
    
    if (!_posterImageView) {
        
        self.posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 * kMulriple, 25 * kHMulriple, 20 * kMulriple, 25 * kHMulriple)];
        _posterImageView.image = [UIImage imageNamed:@"mapImage"];
        
    }
    return _posterImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 * kMulriple, 10 * kHMulriple, 310 * kMulriple, 30 * kHMulriple)];
        self.titleLabel.font = [UIFont systemFontOfSize:16 * kMulriple];
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    
    if (!_subtitleLabel) {
        
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 * kMulriple, 35 * kHMulriple, 310 * kMulriple, 35 * kHMulriple)];
        self.subtitleLabel.font = [UIFont systemFontOfSize:15 * kMulriple];
        self.subtitleLabel.textColor = RGB(111, 111, 111);
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _subtitleLabel;
}




@end
