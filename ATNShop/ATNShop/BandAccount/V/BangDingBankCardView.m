//
//  BangDingBankCardView.m
//  @的你
//
//  Created by 吴明飞 on 16/3/25.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "BangDingBankCardView.h"

@implementation BangDingBankCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self addSubview:self.commitBtn];
        self.backgroundColor = RGB(238, 238, 238);
    }
    return self;
}

- (void)setupViews {

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 260 * kHMulriple)];
    contentView.backgroundColor = [UIColor whiteColor];


    //银行
    UIView *bankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 65 * kHMulriple)];
    //Label
    UILabel *bankTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 15 * kHMulriple, 85 * kMulriple, 35 * kHMulriple)];

    bankTextLabel.text = @"银行";
    bankTextLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    bankTextLabel.textColor = RGB(111, 111, 111);
   [bankView addSubview:bankTextLabel];
    [bankView addSubview:self.bankTF];
    [contentView addSubview:bankView];
   
 
    //开户行
    UIView *openBankView = [[UIView alloc] initWithFrame:CGRectMake(0, 65 * kHMulriple, kWight, 65 * kHMulriple)];
    
    UILabel *openBankTextView = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 15 * kHMulriple, 105 * kMulriple, 35 * kHMulriple)];
    
    openBankTextView.text = @"开户行";
    openBankTextView.font = [UIFont systemFontOfSize:17 * kMulriple];
    openBankTextView.textColor = RGB(111, 111, 111);
    [openBankView addSubview:openBankTextView];
    [openBankView addSubview:self.openBankTF];
    [contentView addSubview:openBankView];

    //卡号
    UIView *bankCardView = [[UIView alloc] initWithFrame:CGRectMake(0, 130 * kHMulriple, kWight, 65 * kHMulriple)];
    //Label
    UILabel *bankCardTextView = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 15 * kHMulriple, 105 * kMulriple, 35 * kHMulriple)];

    bankCardTextView.text = @"卡号";
    bankCardTextView.font = [UIFont systemFontOfSize:17 * kMulriple];
    bankCardTextView.textColor = RGB(111, 111, 111);
    [bankCardView addSubview:bankCardTextView];
    [bankCardView addSubview:self.bankNumberTF];
    [contentView addSubview:bankCardView];


    //真实姓名
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(0, 195 * kHMulriple, kWight, 65 * kHMulriple)];
    //Label
    UILabel *accountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 15 * kHMulriple, 105 * kMulriple, 35 * kHMulriple)];
    accountTextLabel.text = @"真实姓名";
    accountTextLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    accountTextLabel.textColor = RGB(111, 111, 111);
    [accountView addSubview:accountTextLabel];
    [accountView addSubview:self.nameTF];
    [contentView addSubview:accountView];


   for (int i = 0; i < 3; i++) {
    //分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 * kHMulriple + i * 65 * kHMulriple, kWight, 1.5 * kHMulriple)];
    lineLabel.backgroundColor = RGB(237, 237, 237);
    [contentView addSubview:lineLabel];
   }
    [self addSubview:contentView];



   //提示内容
   UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 270 * kHMulriple, 335 * kMulriple, 30 * kHMulriple)];

   textLabel.text = @"提现账号一经填写，再次更改需联系业务经理。";
   textLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
    textLabel.textAlignment = NSTextAlignmentCenter;
   textLabel.textColor = RGB(111, 111, 111);
   [contentView addSubview:textLabel];
}


//输入银行
- (UITextField *)bankTF {
    if (!_bankTF) {
        self.bankTF = [[UITextField alloc] initWithFrame:CGRectMake(125 * kMulriple, 15 * kHMulriple, 220 * kMulriple, 35 * kHMulriple)];
        _bankTF.placeholder = @"请输入银行";
        
        _bankTF.borderStyle = UITextBorderStyleNone;
        
        [_bankTF setFont:[UIFont systemFontOfSize:18 * kMulriple]];
    }
    return _bankTF;
}

- (UITextField *)openBankTF {
    
    if (!_openBankTF) {
        self.openBankTF =  [[UITextField alloc] initWithFrame:CGRectMake(125 * kMulriple, 15 * kHMulriple, 180 * kMulriple, 35 * kHMulriple)];
        _openBankTF.placeholder = @"请输入开户行";
        _openBankTF.borderStyle = UITextBorderStyleNone;
        [_openBankTF setFont:[UIFont systemFontOfSize:18 * kMulriple]];
    }
    return _openBankTF;
}

//输入银行卡号
- (UITextField *)bankNumberTF {
    if (!_bankNumberTF) {
        self.bankNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(125 * kMulriple, 15 * kHMulriple, 245 * kMulriple, 35 * kHMulriple)];
        _bankNumberTF.placeholder = @"请输入银行卡号";
        _bankNumberTF.borderStyle = UITextBorderStyleNone;
        [_bankNumberTF setFont:[UIFont systemFontOfSize:18 * kMulriple]];
    }
    return _bankNumberTF;
}

//输入真实姓名
- (UITextField *)nameTF {
    if (!_nameTF) {
        self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(125 * kMulriple, 15 * kHMulriple, 180 * kMulriple, 35 * kHMulriple)];
        _nameTF.placeholder = @"请输入真实姓名";
        _nameTF.borderStyle = UITextBorderStyleNone;
        [_nameTF setFont:[UIFont systemFontOfSize:18 * kMulriple]];
    }
    return _nameTF;
}

//提交修改按钮
- (UIButton *)commitBtn {
    if (!_commitBtn) {
        self.commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(60 * kMulriple, 320 * kHMulriple, 255 * kMulriple, 50 * kHMulriple)];
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
