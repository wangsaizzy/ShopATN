//
//  ApplyActivityView.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/7.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "ApplyActivityView.h"

@implementation ApplyActivityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.commitBtn];
        [self setupViews];
        self.backgroundColor = RGB(238, 238, 238);
    }
    return self;
}

- (void)setupViews {
    
    
    UIView *rateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 65 * kHMulriple)];
    rateView.backgroundColor = [UIColor whiteColor];
    UILabel *rateTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 15 * kHMulriple, 125 * kMulriple, 35 * kHMulriple)];
    rateTextLabel.text = @"折扣力度(单位 %)";
    rateTextLabel.textColor = RGB(111, 111, 111);
    rateTextLabel.font = [UIFont systemFontOfSize:15 * kMulriple];
    [rateView addSubview:rateTextLabel];
    [rateView addSubview:self.rateTF];
    [self addSubview:rateView];
    
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 65 * kHMulriple, kWight, 65 * kHMulriple)];
    timeView.backgroundColor = [UIColor whiteColor];
    UILabel *timeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 15 * kHMulriple, 80 * kMulriple, 35 * kHMulriple)];
    timeTextLabel.text = @"活动时间";
    timeTextLabel.textColor = RGB(111, 111, 111);
    timeTextLabel.font = [UIFont systemFontOfSize:15 * kMulriple];
    
    UIImageView *timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(180 * kMulriple, 10 * kHMulriple, 15 * kMulriple, 10 * kHMulriple)];
    [timeImage setImage:[UIImage imageNamed:@"dropdown"]];
    timeImage.centerY = self.chooseTimeBtn.height / 2;
    [self.chooseTimeBtn addSubview:timeImage];

    
    [timeView addSubview:timeTextLabel];
    [self.chooseTimeBtn addSubview:self.timeLabel];
    [timeView addSubview:self.chooseTimeBtn];
    [self addSubview:timeView];
    
    //分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63.5 * kHMulriple, kWight, 1.5 * kHMulriple)];
    lineLabel.backgroundColor = RGB(237, 237, 237);
    [rateView addSubview:lineLabel];

}

- (UITextField *)rateTF {
    
    if (!_rateTF) {
        
        self.rateTF = [[UITextField alloc] initWithFrame:CGRectMake(150 * kMulriple, 10 * kHMulriple, 205 * kMulriple, 45 * kHMulriple)];
        self.rateTF.backgroundColor = RGB(238, 238, 238);
        self.rateTF.font = [UIFont systemFontOfSize:15 * kMulriple];
        self.rateTF.placeholder = @"请输入100以内的整数";
        _rateTF.keyboardType=UIKeyboardTypeNumberPad;
        UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10 * kMulriple,0,7 * kMulriple,26 * kHMulriple)];
        leftView.backgroundColor = [UIColor clearColor];
        _rateTF.leftView = leftView;
        _rateTF.leftViewMode = UITextFieldViewModeAlways;
        _rateTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _rateTF;
}

- (UIButton *)chooseTimeBtn {
    
    if (!_chooseTimeBtn) {
        
        self.chooseTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(150 * kMulriple, 10 * kHMulriple, 205 * kMulriple, 45 * kHMulriple)];
        [self.chooseTimeBtn.layer setBorderWidth:1 * kMulriple];   //边框宽度
        [self.chooseTimeBtn.layer setBorderColor:RGB(237, 237, 237).CGColor];//边框颜色
    }
    return _chooseTimeBtn;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kMulriple, 5 * kHMulriple, 185 * kMulriple, 35 * kHMulriple)];
        self.timeLabel.centerY = self.chooseTimeBtn.height / 2;
        self.timeLabel.textColor = RGB(111, 111, 111);
        self.timeLabel.font = [UIFont systemFontOfSize:15 * kMulriple];
    }
    return _timeLabel;
}

- (UIButton *)commitBtn {
    
    if (!_commitBtn) {
        
        self.commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20 * kMulriple, 155 * kHMulriple, 335 * kMulriple, 50 * kHMulriple)];
        [self.commitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        self.commitBtn.titleLabel.font = [UIFont systemFontOfSize:20 * kMulriple];
        [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.commitBtn.backgroundColor = RGB(255, 84, 66);
        self.commitBtn.layer.cornerRadius = 20 * kMulriple;
        self.commitBtn.layer.masksToBounds = YES;
    }
    return _commitBtn;
}

@end
