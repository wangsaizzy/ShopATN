//
//  ShopInformationView.m
//  @的你
//
//  Created by 吴明飞 on 16/3/30.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "ShopInformationView.h"
#import "UIView+Addition.h"

@interface ShopInformationView ()<UIScrollViewDelegate>

@end

@implementation ShopInformationView



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self addSubview:self.scrollView];
        
        
        self.backgroundColor = RGB(238, 238, 238);
    }
    return self;
}

- (void)setupViews {
    
    /*
     第一个自定义View
    
     */
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 210 * kHMulriple)];
    firstView.backgroundColor = RGB(238, 238, 238);

    
    [self.publicizeImageBtn addSubview:self.publicizeImageView];
    [firstView addSubview:self.publicizeImageBtn];
    [self.headImageViewBtn addSubview:self.shopHeadImageView];
    [firstView addSubview:self.headImageViewBtn];
    [self.scrollView addSubview:firstView];
    /*
     第二个自定义View
     
     
     */
    
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 210 * kHMulriple, kWight,  170 * kHMulriple)];
    secondView.backgroundColor = [UIColor whiteColor];
    
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 60 * kHMulriple)];
    UILabel *nameTextLable = [[UILabel alloc] initWithFrame:CGRectMake(15 * kMulriple, 17.5 * kHMulriple, 80 * kMulriple, 25 * kHMulriple)];
    nameTextLable.text = @"店铺名称";
    nameTextLable.font = K17Font;
    nameTextLable.textColor = RGB(111, 111, 111);
    [nameView addSubview:nameTextLable];
    [nameView addSubview:self.shopNameTF];
    [secondView addSubview:nameView];
    
    //店铺地址
    UIView *detailAddressView = [[UIView alloc] initWithFrame:CGRectMake(0, 60 * kHMulriple, kWight, 110 * kHMulriple)];
    //Label
    UILabel *detailAddressTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * kMulriple, 25 * kHMulriple, 80 * kMulriple, 35 * kHMulriple)];
    detailAddressTextLabel.text = @"店铺地址";
    detailAddressTextLabel.font = KFont;
    detailAddressTextLabel.textColor = RGB(111, 111, 111);
    
    UIImageView *mapImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20 * kMulriple, 25 * kHMulriple)];
    [mapImage setImage:[UIImage imageNamed:@"mapImage"]];
    mapImage.centerY = self.mapBtn.height / 2;
    [self.mapBtn addSubview:mapImage];
    
    [detailAddressView addSubview:detailAddressTextLabel];
    [detailAddressView addSubview:self.mapBtn];
    [detailAddressView addSubview:self.detailAddressTV];
    [secondView addSubview:detailAddressView];

    //分割线
    UILabel *secondLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 59 * kHMulriple, kWight, 1 * kHMulriple)];
    secondLineLabel.backgroundColor = RGB(237, 237, 237);
    [secondView addSubview:secondLineLabel];

    
    [self.scrollView addSubview:secondView];
    
    
    
    /*
     第三个自定义View
     
     
     */
    
    
    UIView *thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, 385 * kHMulriple, kWight,  170 * kHMulriple)];
    thirdView.backgroundColor = [UIColor whiteColor];
    
    
    //店铺描述
    UIView *shopDescriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 110 * kHMulriple)];
    //Label
    UILabel *shopDescriptionTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * kMulriple, 17.5 * kHMulriple, 80 * kMulriple, 25 * kHMulriple)];
    
    shopDescriptionTextLabel.text = @"店铺描述";
    shopDescriptionTextLabel.font = K17Font;
    shopDescriptionTextLabel.textColor = RGB(111, 111, 111);
    [shopDescriptionView addSubview:shopDescriptionTextLabel];
    [shopDescriptionView addSubview:self.descriptionTV];
    [thirdView addSubview:shopDescriptionView];
    

    
    //客服电话
    //电话
    UIView *shopPhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 110 * kHMulriple, kWight, 60 * kHMulriple)];
    //Label
    UILabel *showPhoneTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * kMulriple, 17.5 * kHMulriple, 80 * kMulriple, 25 * kHMulriple)];
    
    showPhoneTextLabel.text = @"客服电话";
    showPhoneTextLabel.font = K17Font;
    showPhoneTextLabel.textColor = RGB(111, 111, 111);
    [shopPhoneView addSubview:showPhoneTextLabel];
    [shopPhoneView addSubview:self.phoneTF];
    [thirdView addSubview:shopPhoneView];

    
   
    //分割线
    UILabel *thirdLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 109 * kHMulriple, kWight, 1 * kHMulriple)];
    thirdLineLabel.backgroundColor = RGB(237, 237, 237);
    [thirdView addSubview:thirdLineLabel];
    
    
    [self.scrollView addSubview:thirdView];
    
    /*
     第四个自定义View
    
     */
    
    UIView *fouthView = [[UIView alloc] initWithFrame:CGRectMake(0, 560 * kHMulriple, kWight, 170 * kHMulriple)];
    fouthView.backgroundColor = [UIColor whiteColor];
    
    
    
    //返现额度
    UIView *explainDiscountView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 60 * kHMulriple)];
    //Label
    UILabel *explainDiscountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * kMulriple, 17.5 * kHMulriple, 80 * kMulriple, 25 * kHMulriple)];
    explainDiscountTextLabel.text = @"返现额度";
    explainDiscountTextLabel.font = K17Font;
    explainDiscountTextLabel.textColor = RGB(111, 111, 111);
    [explainDiscountView addSubview:explainDiscountTextLabel];
    
    UILabel *symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(60 * kMulriple, 5 * kHMulriple, 15 * kMulriple, 30 * kHMulriple)];
    symbolLabel.text = @"%";
    symbolLabel.font = K17Font;
    [self.discountTF addSubview:symbolLabel];
    [explainDiscountView addSubview:self.discountTF];
    [fouthView addSubview:explainDiscountView];
    
    //一句话推广商家
    UIView *popularizeView = [[UIView alloc] initWithFrame:CGRectMake(0, 60 * kHMulriple, kWight, 110 * kHMulriple)];
    //Label
    UILabel *popularizeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * kMulriple, 17.5 * kHMulriple, 80 * kMulriple, 50 * kHMulriple)];
    popularizeTextLabel.text = @"一句话推广商家";
    popularizeTextLabel.numberOfLines = 0;
    popularizeTextLabel.font = K17Font;
    popularizeTextLabel.textColor = RGB(111, 111, 111);
    [popularizeView addSubview:popularizeTextLabel];
    [popularizeView addSubview:self.popularizeTV];
    [fouthView addSubview:popularizeView];

    
    
    //分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 59 * kHMulriple , kWight, 1 * kHMulriple)];
    lineLabel.backgroundColor = RGB(237, 237, 237);
    [fouthView addSubview:lineLabel];
    
    
    [self.scrollView addSubview:fouthView];
    
    
    
}

#pragma mark -懒加载
//滑动视图
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWight, kHeight)];
        self.scrollView.contentSize = CGSizeMake(kWight, 795 * kHMulriple);
        self.scrollView.backgroundColor = RGB(238, 238, 238);
        self.scrollView.delegate = self;
        self.scrollView.showsVerticalScrollIndicator = NO;//纵向滚动条
        self.scrollView.bounces = NO;
        self.scrollView.scrollsToTop = YES;
    }
    return _scrollView;
}

- (UIImageView *)publicizeImageView {
    
    if (!_publicizeImageView) {
        
        self.publicizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWight, 150 * kHMulriple)];
        
    }
    return _publicizeImageView;
}

- (UIButton *)publicizeImageBtn {
    
    if (!_publicizeImageBtn) {
        
        self.publicizeImageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _publicizeImageBtn.frame = CGRectMake(0, 0, kWight, 150 * kHMulriple);
        [_publicizeImageBtn setBackgroundImage:[UIImage imageNamed:@"banner"] forState:UIControlStateNormal];
        
        _publicizeImageBtn.backgroundColor = RGB(180, 180, 180);
    }
    return _publicizeImageBtn;
}

//头像按钮
- (UIButton *)headImageViewBtn {
    if (!_headImageViewBtn) {
        self.headImageViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headImageViewBtn.frame = CGRectMake(10 * kMulriple, 130 * kHMulriple, 70 * kMulriple, 70 * kHMulriple);
    
        [_headImageViewBtn setBackgroundImage:[UIImage imageNamed:@"headImage"] forState:UIControlStateNormal];
    }
    return _headImageViewBtn;
}

//头像
- (UIImageView *)shopHeadImageView {
    if (!_shopHeadImageView) {
        self.shopHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70 * kMulriple, 70 * kHMulriple)];
        
    }
    return _shopHeadImageView;
}

//店铺名称
- (UITextField *)shopNameTF {
    
    if (!_shopNameTF) {
        
        self.shopNameTF = [[UITextField alloc] initWithFrame:CGRectMake(105 * kMulriple, 10 * kHMulriple, 245 * kMulriple, 40 * kHMulriple)];
        self.shopNameTF.textColor = RGB(111, 111, 111);
        _shopNameTF.font = K17Font;
        _shopNameTF.backgroundColor = RGB(238, 238, 238);
    }
    return _shopNameTF;
}




- (UIButton *)mapBtn {
    
    if (!_mapBtn) {
        
        self.mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(335 * kMulriple, 20 * kHMulriple, 30 * kMulriple, 50 * kHMulriple)];
    }
    return _mapBtn;
}


//店铺详细地址
- (PlaceholderTextView *)detailAddressTV {
    
    if (!_detailAddressTV) {
        
        self.detailAddressTV = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(105 * kMulriple, 10 * kHMulriple, 215 * kMulriple, 90 * kHMulriple)];
        self.detailAddressTV.textColor = RGB(111, 111, 111);
        _detailAddressTV.placeholder = @"请选择店铺区域";
        _detailAddressTV.backgroundColor = RGB(238, 238, 238);
        _detailAddressTV.font = K17Font;
    }
    return _detailAddressTV;
}

- (PlaceholderTextView *)descriptionTV {
    
    if (!_descriptionTV) {
        
        self.descriptionTV = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(105 * kMulriple, 10 * kHMulriple, 245 * kMulriple, 90 * kHMulriple)];
        self.descriptionTV.textColor = RGB(111, 111, 111);
        _descriptionTV.placeholder = @"请添加店铺描述";
        _descriptionTV.backgroundColor = RGB(238, 238, 238);
        _descriptionTV.font = K17Font;
    }
    return _descriptionTV;
}

//电话输入框
- (UITextField *)phoneTF {
    if (!_phoneTF) {
        self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(105 * kMulriple, 10 * kHMulriple, 240 * kMulriple, 40 * kHMulriple)];
        self.phoneTF.textColor = RGB(111, 111, 111);
        _phoneTF.font = K17Font;
        self.phoneTF.backgroundColor = RGB(238, 238, 238);
    }
    return _phoneTF;
}

//折扣输入框
- (UITextField *)discountTF {
    
    if (!_discountTF) {
        
        self.discountTF = [[UITextField alloc] initWithFrame:CGRectMake(105 * kMulriple, 10 * kHMulriple, 80 * kMulriple, 40 * kHMulriple)];
        _discountTF.textColor = RGB(111, 111, 111);
        _discountTF.backgroundColor = RGB(238, 238, 238);
        _discountTF.font = K17Font;
    }
    return _discountTF;
}

- (PlaceholderTextView *)popularizeTV {
    
    
    if (!_popularizeTV) {
        
        self.popularizeTV = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(105 * kMulriple, 10 * kHMulriple, 245 * kMulriple, 90 * kHMulriple)];
        _popularizeTV.placeholder = @"使用一句话推广一下";
        _popularizeTV.backgroundColor = RGB(238, 238, 238);
        _popularizeTV.textColor = RGB(111, 111, 111);
        _popularizeTV.font = K17Font;
    }
    return _popularizeTV;
}



@end
