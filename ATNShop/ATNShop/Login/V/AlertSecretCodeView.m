//
//  AlertSecretCodeView.m
//  ATN
//
//  Created by 吴明飞 on 16/6/3.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "AlertSecretCodeView.h"

@implementation AlertSecretCodeView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.commitBtn];
        [self setupViews];
        self.backgroundColor = RGB(237, 237, 237);
    }
    return self;
}

- (void)setupViews {
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 60 * kHMulriple)];
    textView.backgroundColor = [UIColor whiteColor];
    [self addSubview:textView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 10 * kHMulriple, 335 * kMulriple, 40 * kHMulriple)];
    textLabel.text = @"   请输入手机号并获取验证码，我们将给您的手机发送一条验证短信。请在5分钟内填写验证码完成验证。";
    textLabel.textColor = RGB(150, 150, 150);
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
    [textView addSubview:textLabel];
    
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 70 * kHMulriple, kWight, 65 * kHMulriple)];
    phoneView.backgroundColor = [UIColor whiteColor];
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 15 * kHMulriple, 60 * kMulriple, 35 * kHMulriple)];
    phoneLabel.textColor = RGB(111, 111, 111);
    phoneLabel.text = @"手机号";
    phoneLabel.font = KFont;
    
    //分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63.5 * kHMulriple, kWight, 2 * kHMulriple)];
    lineLabel.backgroundColor = RGB(237, 237, 237);
    [phoneView addSubview:lineLabel];
    [phoneView addSubview:phoneLabel];
    [phoneView addSubview:self.phoneNumberTF];
    [phoneView addSubview:self.acquireTestBtn];
    [self addSubview:phoneView];
    
    
    
    
    UIView *testSectetView = [[UIView alloc] initWithFrame:CGRectMake(0, 135 * kHMulriple, kWight, 65 * kHMulriple)];
    testSectetView.backgroundColor = [UIColor whiteColor];
    [self addSubview:testSectetView];
    
    
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 15 * kHMulriple, 60 * kMulriple, 35 * kHMulriple)];
    testLabel.text  =@"验证码";
    testLabel.font = KFont;
    testLabel.textColor = RGB(111, 111, 111);
    [testSectetView addSubview:self.bringTestNumberTF];
    [testSectetView addSubview:testLabel];
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63.5 * kHMulriple, kWight, 2 * kHMulriple)];
    line.backgroundColor = RGB(237, 237, 237);
    [testSectetView addSubview:line];
    
    UIView *newSecretView = [[UIView alloc] initWithFrame:CGRectMake(0, 200 * kHMulriple, kWight, 65 * kHMulriple)];
    newSecretView.backgroundColor = [UIColor whiteColor];
    UILabel *newSecretLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 15 * kHMulriple, 70 * kMulriple, 35 * kHMulriple)];
    newSecretLabel.text = @"新密码";
    newSecretLabel.font = KFont;
    newSecretLabel.textColor = RGB(111, 111, 111);
    
    UILabel *lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, 63.5 * kHMulriple, kWight, 1.5 * kHMulriple)];
    lineView.backgroundColor = RGB(237, 237, 237);
    [newSecretView addSubview:lineView];
    [newSecretView addSubview:newSecretLabel];
    [newSecretView addSubview:self.SecretNumberTF];
    [self addSubview:newSecretView];
    
    
    
    
    UIView *sectetView = [[UIView alloc] initWithFrame:CGRectMake(0, 265 * kHMulriple, kWight, 65 * kHMulriple)];
    sectetView.backgroundColor = [UIColor whiteColor];
    [self addSubview:sectetView];
    
    
    UILabel *secretLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 15 * kHMulriple, 75 * kMulriple, 35 * kHMulriple)];
    secretLabel.text  =@"确认密码";
    secretLabel.font = KFont;
    secretLabel.textColor = RGB(111, 111, 111);
    [sectetView addSubview:self.reSetSecretNumberTF];
    [sectetView addSubview:secretLabel];
    
}

- (UITextField *)phoneNumberTF {
    if (!_phoneNumberTF) {
        self.phoneNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(95 * kMulriple, 15 * kHMulriple, 135 * kMulriple, 35 * kHMulriple)];
        self.phoneNumberTF.placeholder = @"请输入手机号";
        _phoneNumberTF.keyboardType=UIKeyboardTypeNumberPad;
        self.phoneNumberTF.font = [UIFont systemFontOfSize:18 * kMulriple];
    }
    return _phoneNumberTF;
}

- (UIButton *)acquireTestBtn {
    if (!_acquireTestBtn) {
        self.acquireTestBtn = [[UIButton alloc] initWithFrame:CGRectMake(245 * kMulriple, 7.5 * kHMulriple, 105 * kMulriple, 50 * kHMulriple)];
        self.acquireTestBtn.backgroundColor = [UIColor orangeColor];
        [_acquireTestBtn.titleLabel setFont:[UIFont systemFontOfSize:17 * kMulriple]];
        [self.acquireTestBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.acquireTestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.acquireTestBtn.layer.cornerRadius = 5 * kMulriple;
        self.acquireTestBtn.layer.masksToBounds = YES;
    }
    return _acquireTestBtn;
}

- (UITextField *)bringTestNumberTF {
    if (!_bringTestNumberTF) {
        self.bringTestNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(95 * kMulriple, 15 * kHMulriple, 115 * kMulriple, 35 * kHMulriple)];
        self.bringTestNumberTF.placeholder = @"请输入验证码";
        
        _bringTestNumberTF.keyboardType=UIKeyboardTypeNumberPad;
        self.bringTestNumberTF.font = KFont;
    }
    return _bringTestNumberTF;
}

- (UITextField *)SecretNumberTF {
    if (!_SecretNumberTF) {
        self.SecretNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(95 * kMulriple, 15 * kHMulriple, 180 * kMulriple, 35 * kHMulriple)];
        self.SecretNumberTF.placeholder = @"请设置新密码";
        _SecretNumberTF.secureTextEntry = YES;
        self.SecretNumberTF.borderStyle = UITextBorderStyleNone;
        
        [self.SecretNumberTF setFont:KFont];
    }
    return _SecretNumberTF;
}

- (UITextField *)reSetSecretNumberTF {
    if (!_reSetSecretNumberTF) {
        self.reSetSecretNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(95 * kMulriple, 15 * kHMulriple, 180 * kMulriple, 35 * kHMulriple)];
        self.reSetSecretNumberTF.placeholder = @"请再输入一遍新密码";
        _reSetSecretNumberTF.secureTextEntry = YES;
        self.reSetSecretNumberTF.borderStyle = UITextBorderStyleNone;
        [self.reSetSecretNumberTF setFont:KFont];
    }
    return _reSetSecretNumberTF;
}


- (UIButton *)commitBtn {
    if (!_commitBtn) {
        self.commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(60 * kMulriple, 360 * kHMulriple, 255 * kMulriple, 50 * kHMulriple)];
        [self.commitBtn setTitle:@"提交修改" forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        self.commitBtn.layer.cornerRadius = 25 * kMulriple;
        self.commitBtn.layer.masksToBounds = YES;
        self.commitBtn.backgroundColor = [UIColor redColor];
        [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _commitBtn;
}

@end
