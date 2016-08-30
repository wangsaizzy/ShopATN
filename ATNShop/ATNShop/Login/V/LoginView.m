//
//  LoginView.m
//  @的你
//
//  Created by 吴明飞 on 16/3/14.
//  Copyright © 2016年 吴明飞. All rights reserved.
//


#import "LoginView.h"
@implementation LoginView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.customerPhotoImageView];
        [self addSubview:self.accountNumberTF];
        [self addSubview:self.secretNumberTF];
        [self addSubview:self.loginBtn];
        [self addSubview:self.forgetSecretBtn];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *accountImage = [[UIImageView alloc] initWithFrame:CGRectMake(60 * kMulriple, 194 * kHMulriple, 25 * kMulriple, 25 * kHMulriple)];
    accountImage.image = [UIImage imageNamed:@"userName"];
    [self addSubview:accountImage];
    
    UIImageView *secretImage = [[UIImageView alloc] initWithFrame:CGRectMake(60 * kMulriple, 259 * kHMulriple, 25 * kMulriple, 25 * kHMulriple)];
    secretImage.image = [UIImage imageNamed:@"secret"];
    [self addSubview:secretImage];
    
    UILabel *firstLineView = [[UILabel alloc] initWithFrame:CGRectMake(40 * kMulriple, 234 * kHMulriple, 295 * kMulriple, 1 * kHMulriple)];
    firstLineView.backgroundColor = RGB(249, 174, 161);
    [self addSubview:firstLineView];
    
    UILabel *secondLineView = [[UILabel alloc] initWithFrame:CGRectMake(40 * kMulriple, 294 * kHMulriple, 295 * kMulriple, 1 * kHMulriple)];
    secondLineView.backgroundColor = RGB(249, 174, 161);
    [self addSubview:secondLineView];
    
    
}

- (UIImageView *)customerPhotoImageView {
    if (!_customerPhotoImageView) {
        self.customerPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(147 * kMulriple, 84 * kHMulriple, 80 * kMulriple, 80 * kHMulriple)];
        [self.customerPhotoImageView setImage:[UIImage imageNamed:@"headImage"]];
        self.customerPhotoImageView.layer.cornerRadius = 40 * kMulriple;
        self.customerPhotoImageView.layer.masksToBounds = YES;
        
    }
    return _customerPhotoImageView;
}


- (UITextField *)accountNumberTF {
    if (!_accountNumberTF) {
        self.accountNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(100 * kMulriple, 194 * kHMulriple, 200 * kMulriple, 25 * kHMulriple)];
        self.accountNumberTF.placeholder = @"请输入11位的手机号";
        _accountNumberTF.keyboardType=UIKeyboardTypeNumberPad;
        self.accountNumberTF.borderStyle = UITextBorderStyleNone;
        [self.accountNumberTF setFont:[UIFont systemFontOfSize:15 * kMulriple]];
        
    }
    return _accountNumberTF;
}

- (UITextField *)secretNumberTF {
    if (!_secretNumberTF) {
        self.secretNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(100 * kMulriple, 259 * kHMulriple, 200 * kMulriple, 25 * kHMulriple)];
        self.secretNumberTF.borderStyle = UITextBorderStyleNone;
        self.secretNumberTF.placeholder = @"请输入6到20位的密码";
        _secretNumberTF.secureTextEntry = YES;
        [self.secretNumberTF setFont:[UIFont systemFontOfSize:15 * kMulriple]];
    }
    return _secretNumberTF;
}


- (UIButton *)forgetSecretBtn {
    if (!_forgetSecretBtn) {
        self.forgetSecretBtn = [[UIButton alloc] initWithFrame:CGRectMake(60 * kMulriple, 314 * kHMulriple, 80 * kMulriple, 20 * kHMulriple)];
        [self.forgetSecretBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [self.forgetSecretBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.forgetSecretBtn.titleLabel.font = [UIFont systemFontOfSize:15 * kMulriple];
    }
    return _forgetSecretBtn;
    
}


- (UIButton *)loginBtn {
    if (!_loginBtn) {
        self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(40 * kMulriple, 359 * kHMulriple, 295 * kMulriple, 50 * kHMulriple)];
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:18 * kMulriple];
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.loginBtn.backgroundColor = RGB(255, 84, 66);
        self.loginBtn.layer.cornerRadius = 20 * kMulriple;
        self.loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}


@end
