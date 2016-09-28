//
//  ShopManagerView.m
//  ATN
//
//  Created by 吴明飞 on 16/6/1.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "ShopManagerView.h"

@implementation ShopManagerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        
        self.backgroundColor = RGB(238, 238, 238);
    }
    return self;
}

- (void)setupViews {
    
    //背景视图
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 20 * kHMulriple, kWight, 195 * kHMulriple)];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:headView.bounds];
    [headView addSubview:backImageView];
    backImageView.image = [UIImage imageNamed:@"shopBackGround"];
    [headView addSubview:self.photoImageView];
    [headView addSubview:self.nameLabel];
    [headView addSubview:self.setUpBtn];
    [headView addSubview:self.messageBtn];
    
    
    [self addSubview:headView];
    
    //中间视图
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 215 * kHMulriple, kWight, 100 * kHMulriple)];
    secondView.backgroundColor = [UIColor whiteColor];
    
    [self.inComeBtn addSubview:self.priceLabel];
    [self.inComeBtn addSubview:self.priceLittleLabel];
    
    
    UILabel *todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 * kMulriple, 40 * kHMulriple, 90 * kMulriple, 25 * kHMulriple)];
    todayLabel.centerX = self.inComeBtn.width / 2;
    todayLabel.text = @"今日收入";
    todayLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    todayLabel.textColor = RGB(111, 111, 111);
    todayLabel.textAlignment = NSTextAlignmentCenter;
    [self.inComeBtn addSubview:todayLabel];

    [secondView addSubview:self.inComeBtn];
    
    UILabel *listLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 * kMulriple, 40 * kHMulriple, 90 * kMulriple, 25 * kHMulriple)];
    listLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    listLabel.centerX = self.listBtn.width / 2;
    listLabel.text = @"今日订单";
    listLabel.textColor = RGB(111, 111, 111);
    listLabel.textAlignment = NSTextAlignmentCenter;
    [self.listBtn addSubview:listLabel];
    [self.listBtn addSubview:self.acountLabel];
    [secondView addSubview:self.listBtn];
    
    [self addSubview:secondView];
    
    //分类视图
    UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 316.5 * kHMulriple, kWight, kHeight - 322 * kHMulriple)];
    categoryView.backgroundColor = RGB(237, 237, 237);
    
    NSArray *firstLineImageArr = @[@"verifyMoney",@"cashApply",@"shopInformation"];
    NSArray *firstLineLabelArr = @[@"财务对账", @"收入提现", @"店铺信息"];
    for (int i = 0; i < 3; i++) {
        
        //第一行按钮
        UIButton *firstLineBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * 125.5 * kMulriple, 0, 124 * kMulriple, 114 * kHMulriple)];
        firstLineBtn.backgroundColor = [UIColor whiteColor];
        UIImageView *firstLineBtnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:firstLineImageArr[i]]];
        [firstLineBtn addSubview:firstLineBtnImage];
        firstLineBtnImage.centerX = firstLineBtn.width / 2;
        firstLineBtnImage.centerY = 80  * kHMulriple / 2;
        UILabel *firstLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, firstLineBtnImage.frame.size.height + 20 * kHMulriple, firstLineBtn.frame.size.width, 12 * kHMulriple)];
        firstLineLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
        firstLineLabel.textAlignment = NSTextAlignmentCenter;
        firstLineLabel.textColor = RGB(111, 111, 111);
        firstLineLabel.text = firstLineLabelArr[i];
        firstLineLabel.centerY = 155 * kHMulriple / 2;
        [firstLineBtn addSubview:firstLineLabel];
        
        firstLineBtn.tag = 1000 + i;
        [categoryView addSubview:firstLineBtn];
    }
    
    NSArray *secondLineImageArr = @[@"goodsManager",@"comment", @"business"];
    NSArray *secondLineLabelArr = @[@"产品管理", @"查看评价", @"分类管理"];
    for (int j = 0; j < 3; j++) {
        
        //第二行按钮
        UIButton *secondLineBtn = [[UIButton alloc] initWithFrame:CGRectMake(125.5 * j * kMulriple, 115.5 * kHMulriple, 124 * kMulriple, 114 * kHMulriple)];
        secondLineBtn.backgroundColor = [UIColor whiteColor];
        UIImageView *secondLineBtnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:secondLineImageArr[j]]];
        [secondLineBtn addSubview:secondLineBtnImage];
        secondLineBtnImage.centerX = secondLineBtn.width / 2;
        secondLineBtnImage.centerY = 80 * kHMulriple / 2;
        UILabel *secondLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, secondLineBtnImage.frame.size.height + 10 * kHMulriple, secondLineBtn.frame.size.width, 12 * kHMulriple)];
        secondLineLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
        secondLineLabel.textAlignment = NSTextAlignmentCenter;
        secondLineLabel.textColor = RGB(111, 111, 111);
        secondLineLabel.text = secondLineLabelArr[j];
        secondLineLabel.centerY = 155 * kHMulriple / 2;
        [secondLineBtn addSubview:secondLineLabel];
        
        secondLineBtn.tag = 2000 + j;
        [categoryView addSubview:secondLineBtn];
    }
    //第三行按钮
    
    UIImageView *thirdLineBtnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginout"]];
    [self.loginoutBtn addSubview:thirdLineBtnImage];
    
    
    thirdLineBtnImage.centerX = self.loginoutBtn.width / 2;
    thirdLineBtnImage.centerY = 80 * kHMulriple/ 2;
    UILabel *thirdLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, thirdLineBtnImage.frame.size.height + 10 * kHMulriple, self.loginoutBtn.frame.size.width, 12 * kHMulriple)];
    thirdLineLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
    thirdLineLabel.textAlignment = NSTextAlignmentCenter;
    thirdLineLabel.text = @"退出登录";
    thirdLineLabel.textColor = RGB(111, 111, 111);
    thirdLineLabel.centerY = 155 * kHMulriple / 2;
    [self.loginoutBtn addSubview:thirdLineLabel];
    
    [categoryView addSubview:self.loginoutBtn];
    

    [self addSubview:categoryView];

}

- (UIImageView *)photoImageView {
    
    if (!_photoImageView) {
        
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(152 * kMulriple, 50 * kHMulriple, 70 * kMulriple, 70 * kHMulriple)];
        [self.photoImageView setImage:[UIImage imageNamed:@"defaultImage"]];
        _photoImageView.layer.cornerRadius = 35 * kMulriple;
        _photoImageView.layer.masksToBounds = YES;
        
    }
    return _photoImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(147 * kMulriple, 135 * kHMulriple, 240 * kMulriple, 20 * kHMulriple)];
        _nameLabel.centerX = kWight / 2;
        _nameLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        
    }
    return _nameLabel;
}

- (UIButton *)setUpBtn {
    
    if (!_setUpBtn) {
        
        self.setUpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _setUpBtn.frame = CGRectMake(kWight - 40 * kMulriple, 20 * kHMulriple, 25 * kMulriple, 25 * kHMulriple);
        [_setUpBtn setBackgroundImage:[UIImage imageNamed:@"setup"] forState:UIControlStateNormal];
//        [_setUpBtn setImage:[UIImage imageNamed:@"setup"] forState:UIControlStateNormal];
    }
    return _setUpBtn;
}

- (UIButton *)messageBtn {
    
    if (!_messageBtn) {
        
        self.messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(20 * kMulriple, 20 * kHMulriple, 22 * kMulriple, 24 * kHMulriple)];
//        [_messageBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
        [_messageBtn setBackgroundImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    }
    return _messageBtn;
}


- (UIButton *)inComeBtn {
    
    if (!_inComeBtn) {
        
        self.inComeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50 * kMulriple, 15 * kHMulriple, 100 * kMulriple, 80 * kHMulriple)];
    }
    return _inComeBtn;
}

- (UILabel *)priceLabel {
    
    if (!_priceLabel) {
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5 * kHMulriple, 65 * kMulriple, 30 * kHMulriple)];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = [UIFont systemFontOfSize:25 * kMulriple];
    }
    return _priceLabel;
}

- (UILabel *)priceLittleLabel {
    
    if (!_priceLittleLabel) {
        
        self.priceLittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60 * kMulriple, 13 * kHMulriple, 40 * kMulriple, 20 * kMulriple)];
        self.priceLittleLabel.textColor = [UIColor redColor];
        _priceLittleLabel.font = [UIFont systemFontOfSize:19 * kMulriple];
    }
    return _priceLittleLabel;
}

- (UIButton *)listBtn {
    
    if (!_listBtn) {
        
        self.listBtn = [[UIButton alloc] initWithFrame:CGRectMake(225 * kMulriple, 15 * kHMulriple, 100 * kMulriple, 100 * kHMulriple)];
    }
    return _listBtn;
}

- (UILabel *)acountLabel {
    
    if (!_acountLabel) {
        
        self.acountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5 * kHMulriple, 100 * kMulriple, 30 * kHMulriple)];
        _acountLabel.centerX = self.listBtn.width / 2;
        _acountLabel.textColor = [UIColor redColor];
        _acountLabel.textAlignment = NSTextAlignmentCenter;
        _acountLabel.font = [UIFont systemFontOfSize:25 * kMulriple];
    }
    return _acountLabel;
}

- (UIButton *)loginoutBtn {
    
    if (!_loginoutBtn) {
        
        self.loginoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 231 * kHMulriple, 124 * kMulriple, 114 * kHMulriple)];
        self.loginoutBtn.backgroundColor = [UIColor whiteColor];
    }
    return _loginoutBtn;
}

@end
