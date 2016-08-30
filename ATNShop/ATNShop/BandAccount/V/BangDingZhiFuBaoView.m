//
//  BangDingZhiFuBaoView.m
//  @的你
//
//  Created by 吴明飞 on 16/3/25.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "BangDingZhiFuBaoView.h"

@implementation BangDingZhiFuBaoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self addSubview:self.commitBtn];
    }
    return self;
}

- (void)setupViews {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 130 * kHMulriple)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 65 * kHMulriple)];
    UILabel *accountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 15 * kHMulriple, 70 * kMulriple, 35 * kHMulriple)];
    accountTextLabel.text = @"账号";
    accountTextLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    accountTextLabel.textColor = RGB(111, 111, 111);
    
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 * kHMulriple, kWight, 1.5 * kHMulriple)];
    lineLabel.backgroundColor = RGB(237, 237, 237);
    [contentView addSubview:lineLabel];
    
    [accountView addSubview:accountTextLabel];
    [accountView addSubview:self.accountNumberTF];
    [contentView addSubview:accountView];
    
    
    
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 65 * kHMulriple, kWight, 65 * kHMulriple)];
    [contentView addSubview:nameView];
    
    
    UILabel *nameTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 15 * kHMulriple, 75 * kMulriple, 35 * kHMulriple)];
    nameTextLabel.text  =@"真实姓名";
    nameTextLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    nameTextLabel.textColor = RGB(111, 111, 111);
    [nameView addSubview:self.nameTF];
    [nameView addSubview:nameTextLabel];
    
    [contentView addSubview:nameView];
    
    [self addSubview:contentView];
    
    //提示view
    UIView *promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 140 * kHMulriple, kWight, 20 * kHMulriple)];
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kMulriple, 0, 355 * kMulriple, 20 * kHMulriple)];
    promptLabel.text = @"提现账号一经填写，再次更改需联系业务经理。";
    promptLabel.textColor = RGB(159, 159, 159);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
    [promptView addSubview:promptLabel];
    [self addSubview:promptView];
}

//输入支付宝账号
- (UITextField *)accountNumberTF {
    if (!_accountNumberTF) {
        self.accountNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(125 * kMulriple, 15 * kHMulriple, 220 * kMulriple, 35 * kHMulriple)];
        _accountNumberTF.placeholder = @"请输入支付宝账号";
        _accountNumberTF.borderStyle = UITextBorderStyleNone;
        
        [_accountNumberTF setFont:[UIFont systemFontOfSize:18 * kMulriple]];
    }
    return _accountNumberTF;
}

//输入姓名
- (UITextField *)nameTF {
    if (!_nameTF) {
        self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(125 * kMulriple, 15 * kHMulriple, 180 * kMulriple, 35 * kHMulriple)];
        _nameTF.placeholder = @"请输入姓名";
        _nameTF.borderStyle = UITextBorderStyleNone;
        [_nameTF setFont:[UIFont systemFontOfSize:18 * kMulriple]];
    }
    return _nameTF;
}

//提交修改按钮
- (UIButton *)commitBtn {
    if (!_commitBtn) {
        self.commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(60 * kMulriple, 180 * kHMulriple, 255 * kMulriple, 50 * kHMulriple)];
        [self.commitBtn setTitle:@"提交修改" forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        self.commitBtn.layer.cornerRadius = 5 * kMulriple;
        self.commitBtn.layer.masksToBounds = YES;
        self.commitBtn.backgroundColor = RGB(255, 84, 66);
        [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _commitBtn;
}


@end
