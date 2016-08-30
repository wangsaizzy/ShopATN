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
    
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 340 * kHMulriple)];
    firstView.backgroundColor = [UIColor whiteColor];
    
    
    [self.shopBannerBtn addSubview:self.shopBannerImageView];
    [firstView addSubview:self.shopBannerBtn];
    
    //店铺状态
    UIView *shopStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 70 * kHMulriple, kWight, 60 * kHMulriple)];
    //Label
    UILabel *shopStateTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * kMulriple, 15 * kHMulriple, 85 * kMulriple, 30 * kHMulriple)];
    shopStateTextLabel.text = @"店铺状态";
    shopStateTextLabel.font = KFont;
    shopStateTextLabel.textColor = RGB(111, 111, 111);
    [shopStateView addSubview:shopStateTextLabel];
    [shopStateView addSubview:self.stateSwitch];
    [shopStateView addSubview:self.shopStateLabel];
    
    [firstView addSubview:shopStateView];
    
    //头像
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 130 * kHMulriple, kWight, 90 * kHMulriple)];
    //Label
    UILabel *headTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * kMulriple, 30 * kHMulriple, 85 * kMulriple, 30 * kHMulriple)];
    
    headTextLabel.text = @"头像";
    headTextLabel.font = KFont;
    headTextLabel.textColor = RGB(111, 111, 111);
    [headView addSubview:headTextLabel];
    [self.headImageViewBtn addSubview:self.shopHeadImageView];
    [headView addSubview:self.headImageViewBtn];
    [firstView addSubview:headView];
    
    UILabel *lineFirstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 129 * kHMulriple, kWight, 1 * kHMulriple)];
    lineFirstLabel.backgroundColor = RGB(237, 237, 237);
    [firstView addSubview:lineFirstLabel];
    
    
    //列表展示图
    UIView *showListView = [[UIView alloc] initWithFrame:CGRectMake(0, 220 * kHMulriple, kWight, 120 * kHMulriple)];
    
    //Label
    UILabel *showListTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * kMulriple, 15 * kHMulriple, 95 * kMulriple, 25 * kHMulriple)];
    showListTextLabel.text = @"列表展示图";
    showListTextLabel.font = KFont;
    showListTextLabel.textColor = RGB(111, 111, 111);
    [showListView addSubview:showListTextLabel];
    [self.showListBtn addSubview:self.shopListImageView];
    [showListView addSubview:self.showListBtn];
    [firstView addSubview:showListView];
    
    
    
    
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 219 * kHMulriple, kWight, 1 * kHMulriple)];
    lineLabel.backgroundColor = RGB(237, 237, 237);
    [firstView addSubview:lineLabel];
    
    
    [self.scrollView addSubview:firstView];
    /*
     第二个自定义View
     
     
     */
    
    self.secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 345 * kHMulriple, kWight,  115* kHMulriple)];
    _secondView.backgroundColor = [UIColor whiteColor];
    
    
    
    //Label
    UILabel *showEnvironmentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * kMulriple, 15 * kHMulriple, 95 * kMulriple, 30 * kHMulriple)];
    showEnvironmentTextLabel.text = @"环境展示图";
    showEnvironmentTextLabel.font = KFont;
    showEnvironmentTextLabel.textColor = RGB(111, 111, 111);
    [_secondView addSubview:showEnvironmentTextLabel];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * kMulriple, 45 * kHMulriple, 85 * kMulriple, 20 * kHMulriple)];
    numberLabel.text = @"(最多二十张)";
    numberLabel.font = [UIFont systemFontOfSize:12 * kMulriple];
    numberLabel.textColor = RGB(111, 111, 111);
    [_secondView addSubview:numberLabel];
    [_secondView addSubview:self.showEnvironmentBtn];
    [self.scrollView addSubview:self.secondView];
    
    /*
     第三个自定义View
     
     
     */
    
    
    self.thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, 475 * kHMulriple, kWight,  145* kHMulriple)];
    _thirdView.backgroundColor = [UIColor whiteColor];
    
    
    //店铺名称
    UIView *shopNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 60 * kHMulriple)];
    //Label
    UILabel *shopNameTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * kMulriple, 15 * kHMulriple, 85 * kMulriple, 30 * kHMulriple)];
    
    shopNameTextLabel.text = @"店铺名称";
    shopNameTextLabel.font = KFont;
    shopNameTextLabel.textColor = RGB(111, 111, 111);
    [shopNameView addSubview:shopNameTextLabel];
    [shopNameView addSubview:self.shopNameTF];
    [_thirdView addSubview:shopNameView];
    

    
    //店铺地址
    UIView *detailAddressView = [[UIView alloc] initWithFrame:CGRectMake(0, 60 * kHMulriple, kWight, 85 * kHMulriple)];
    //Label
    UILabel *detailAddressTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * kMulriple, 25 * kHMulriple, 105 * kMulriple, 35 * kHMulriple)];
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
    [_thirdView addSubview:detailAddressView];
    
    
   
    //分割线
    UILabel *thirdLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 59 * kHMulriple, kWight, 1 * kHMulriple)];
    thirdLineLabel.backgroundColor = RGB(237, 237, 237);
    [_thirdView addSubview:thirdLineLabel];
    
    
    [self.scrollView addSubview:self.thirdView];
    
    /*
     第四个自定义View
     
     
     */
    
    
    self.fouthView = [[UIView alloc] initWithFrame:CGRectMake(0, 635 * kHMulriple, kWight,  220 * kHMulriple)];
    _fouthView.backgroundColor = [UIColor whiteColor];
    
    
    //店铺分类
    UIView *shopCategoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 60 * kHMulriple)];
    //Label
    UILabel *shopCategoryTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * kMulriple, 15 * kHMulriple, 85 * kMulriple, 30 * kHMulriple)];
    
    shopCategoryTextLabel.text = @"店铺分类";
    shopCategoryTextLabel.font = KFont;
    shopCategoryTextLabel.textColor = RGB(111, 111, 111);
    [shopCategoryView addSubview:shopCategoryTextLabel];
    
    self.categoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(180 * kMulriple, 10 * kHMulriple, 15 * kMulriple, 20 * kHMulriple)];
    self.categoryImage.image = [UIImage imageNamed:@"right"];
    self.categoryImage.centerY = self.chooseCategoryBtn.height / 2;
    [self.chooseCategoryBtn addSubview:self.categoryImage];
    [shopCategoryView addSubview:self.chooseCategoryBtn];
    [self.chooseCategoryBtn addSubview:self.chooseCategoryLabel];
    [_fouthView addSubview:shopCategoryView];
    
    
    
    //电话
    UIView *shopPhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 60 * kHMulriple, kWight, 60 * kHMulriple)];
    //Label
    UILabel *showPhoneTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * kMulriple, 15 * kHMulriple, 105 * kMulriple, 30 * kHMulriple)];
    
    showPhoneTextLabel.text = @"电话";
    showPhoneTextLabel.font = KFont;
    showPhoneTextLabel.textColor = RGB(111, 111, 111);
    [shopPhoneView addSubview:showPhoneTextLabel];
    [shopPhoneView addSubview:self.phoneTF];
    [_fouthView addSubview:shopPhoneView];
    
    
    //折扣说明
    UIView *explainDiscountView = [[UIView alloc] initWithFrame:CGRectMake(0, 120 * kHMulriple, kWight, 50 * kHMulriple)];
    //Label
    UILabel *explainDiscountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * kMulriple, 15 * kHMulriple, 105 * kMulriple, 20 * kHMulriple)];
    explainDiscountTextLabel.text = @"折扣说明";
    explainDiscountTextLabel.font = KFont;
    explainDiscountTextLabel.textColor = RGB(111, 111, 111);
    [explainDiscountView addSubview:explainDiscountTextLabel];
    [explainDiscountView addSubview:self.discountLabel];
    [_fouthView addSubview:explainDiscountView];
    
    
    for (int i = 0; i < 2; i++) {
        //分割线
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 59 * kHMulriple + i * 59 * kHMulriple, kWight, 1 * kHMulriple)];
        lineLabel.backgroundColor = RGB(237, 237, 237);
        [_fouthView addSubview:lineLabel];
    }
    
    [self.scrollView addSubview:self.fouthView];
    
    UILabel *lineTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 169 * kHMulriple, kWight, 1 * kHMulriple)];
    lineTextLabel.backgroundColor = RGB(237, 237, 237);
    [_fouthView addSubview:lineTextLabel];
    
    //提示内容
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * kMulriple, 180 * kHMulriple, 335 * kMulriple, 30 * kHMulriple)];
    
    textLabel.text = @"更改店名、地址、电话等内容请联系业务经理!";
    textLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
    textLabel.textColor = RGB(111, 111, 111);
    [_fouthView addSubview:textLabel];
    
}

#pragma mark -懒加载
//滑动视图
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWight, kHeight)];
        self.scrollView.contentSize = CGSizeMake(kWight, 920 * kHMulriple);
        self.scrollView.backgroundColor = RGB(238, 238, 238);
        self.scrollView.delegate = self;
        self.scrollView.showsVerticalScrollIndicator = NO;//纵向滚动条
        self.scrollView.bounces = NO;
        self.scrollView.scrollsToTop = YES;
    }
    return _scrollView;
}

//横幅按钮
- (UIButton *)shopBannerBtn {
    if (!_shopBannerBtn) {
        self.shopBannerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shopBannerBtn.frame = CGRectMake(0, 0, kWight, 70 * kHMulriple);
        [_shopBannerBtn setBackgroundImage:[UIImage imageNamed:@"banner"] forState:UIControlStateNormal];
    }
    return _shopBannerBtn;
}

//横幅
- (UIImageView *)shopBannerImageView {
    if (!_shopBannerImageView) {
        self.shopBannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWight, 70 * kHMulriple)];
       
        
    }
    return _shopBannerImageView;
}

//开关
- (UISwitch *)stateSwitch {
    if (!_stateSwitch) {
        self.stateSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(275 * kMulriple, 15 * kHMulriple, 90 * kMulriple, 45 * kHMulriple)];
        self.stateSwitch.on = YES;
        // 控件大小，不能设置frame，只能用缩放比例
        self.stateSwitch.onTintColor = RGB(235, 88, 64);
    }
    return _stateSwitch;
}

//展示店铺状态Label
- (UILabel *)shopStateLabel {
    if (!_shopStateLabel) {
        self.shopStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(135 * kMulriple, 15 * kHMulriple, 80 * kMulriple, 30 * kHMulriple)];
        _shopStateLabel.font = KFont;
        self.shopStateLabel.textColor = RGB(77, 77, 77);
    }
    return _shopStateLabel;
}

//头像按钮
- (UIButton *)headImageViewBtn {
    if (!_headImageViewBtn) {
        self.headImageViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headImageViewBtn.frame = CGRectMake(147 * kMulriple, 10 * kHMulriple, 70 * kMulriple, 70 * kHMulriple);
       
        [_headImageViewBtn setBackgroundImage:[UIImage imageNamed:@"headImage"] forState:UIControlStateNormal];
    }
    return _headImageViewBtn;
}

//头像
- (UIImageView *)shopHeadImageView {
    if (!_shopHeadImageView) {
        self.shopHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70 * kMulriple, 70 * kHMulriple)];
    
        self.shopHeadImageView.layer.masksToBounds = YES;
        self.shopHeadImageView.layer.cornerRadius = 35 * kMulriple;
    }
    return _shopHeadImageView;
}

//店铺名称
- (UITextField *)shopNameTF {
    
    if (!_shopNameTF) {
        
        self.shopNameTF = [[UITextField alloc] initWithFrame:CGRectMake(135 * kMulriple, 7.5 * kHMulriple, 210 * kMulriple, 45 * kHMulriple)];
        self.shopNameTF.textColor = RGB(111, 111, 111);
        _shopNameTF.font = [UIFont systemFontOfSize:17 * kMulriple];
        _shopNameTF.backgroundColor = RGB(238, 238, 238);
    }
    return _shopNameTF;
}


//选择店铺种类按钮
- (UIButton *)chooseCategoryBtn {
    if (!_chooseCategoryBtn) {
        self.chooseCategoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(135 * kMulriple, 5 * kHMulriple, 210 * kMulriple, 45 * kHMulriple)];
        [self.chooseCategoryBtn.layer setBorderWidth:1 * kMulriple];   //边框宽度
        [self.chooseCategoryBtn.layer setBorderColor:RGB(237, 237, 237).CGColor];//边框颜色
    }
    return _chooseCategoryBtn;
}

//选择店铺种类label
- (UILabel *)chooseCategoryLabel {
    if (!_chooseCategoryLabel) {
        self.chooseCategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kMulriple, 5 * kHMulriple, 125 * kMulriple, 25 * kHMulriple)];
        
        _chooseCategoryLabel.font = KFont;
        self.chooseCategoryLabel.centerY = self.chooseCategoryBtn.height / 2;
        self.chooseCategoryLabel.textColor = RGB(111, 111, 111);
    }
    return _chooseCategoryLabel;
}


- (UIButton *)mapBtn {
    
    if (!_mapBtn) {
        
        self.mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(335 * kMulriple, 20 * kHMulriple, 30 * kMulriple, 50 * kHMulriple)];
    }
    return _mapBtn;
}


//店铺详细地址
- (UITextView *)detailAddressTV {
    
    if (!_detailAddressTV) {
        
        self.detailAddressTV = [[UITextView alloc] initWithFrame:CGRectMake(135 * kMulriple, 7.5 * kHMulriple, 190 * kMulriple, 70 * kHMulriple)];
        self.detailAddressTV.textColor = RGB(111, 111, 111);
        
        _detailAddressTV.backgroundColor = RGB(238, 238, 238);
        _detailAddressTV.font = KFont;
    }
    return _detailAddressTV;
}

//电话输入框
- (UITextField *)phoneTF {
    if (!_phoneTF) {
        self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(135 * kMulriple, 7.5 * kHMulriple, 210 * kMulriple, 45 * kHMulriple)];
        self.phoneTF.textColor = RGB(111, 111, 111);
        _phoneTF.font = KFont;
        self.phoneTF.backgroundColor = RGB(238, 238, 238);
    }
    return _phoneTF;
}

//折扣输入框
- (UILabel *)discountLabel {
    
    if (!_discountLabel) {
        
        self.discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(135 * kMulriple, 7.5 * kHMulriple, 210 * kMulriple, 35 * kHMulriple)];
        self.discountLabel.textColor = RGB(111, 111, 111);
        _discountLabel.font = KFont;
       
        
    }
    return _discountLabel;
}

//列表展示图
- (UIImageView *)shopListImageView {
    if (!_shopListImageView) {
        self.shopListImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80 * kMulriple, 80 * kHMulriple)];
        
    }
    return _shopListImageView;
}

//列表展示图按钮
- (UIButton *)showListBtn {
    if (!_showListBtn) {
        self.showListBtn = [[UIButton alloc] initWithFrame:CGRectMake(145 * kMulriple, 20 * kHMulriple, 80 * kMulriple, 80 * kHMulriple)];
        
        [_showListBtn setBackgroundImage:[UIImage imageNamed:@"defaultShowImage"] forState:UIControlStateNormal];
    }
    return _showListBtn;
}

- (UIButton *)showEnvironmentBtn {
    
    if (!_showEnvironmentBtn) {
        self.showEnvironmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(145 * kMulriple, 20 * kHMulriple, 80 * kMulriple, 80 * kHMulriple)];
        [_showEnvironmentBtn setBackgroundImage:[UIImage imageNamed:@"showListImage"] forState:UIControlStateNormal];
        
    }
    return _showEnvironmentBtn;
}

@end
