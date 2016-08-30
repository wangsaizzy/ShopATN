//
//  ShopInformationView.h
//  @的你
//
//  Created by 吴明飞 on 16/3/30.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopInformationView : UIView
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *secondView;
@property (nonatomic, strong) UIView *thirdView;
@property (nonatomic, strong) UIView *fouthView;
@property (nonatomic, strong) UISwitch *stateSwitch;//开关
@property (nonatomic, strong) UITextField *shopNameTF;
@property (nonatomic, strong) UIImageView *shopHeadImageView;//商铺头像
@property (nonatomic, strong) UIImageView *shopListImageView;//列表展示图
@property (nonatomic, strong) UIImageView *shopBannerImageView;//横幅展示图

@property (nonatomic, strong) UIButton *headImageViewBtn;//头像
@property (nonatomic, strong) UITextView *detailAddressTV;//详细地址
@property (nonatomic, strong) UILabel *shopStateLabel;//店铺状态
@property (nonatomic, strong) UILabel *chooseCategoryLabel;//店铺分类
@property (nonatomic, strong) UIImageView *categoryImage;
@property (nonatomic, strong) UILabel *discountLabel;//折扣
@property (nonatomic, strong) UITextField *phoneTF;//电话
@property (nonatomic, strong) UIButton *chooseCategoryBtn;//选择分类
@property (nonatomic, strong) UIButton *shopBannerBtn;//横幅展示图按钮
@property (nonatomic, strong) UIButton *showListBtn;//列表展示图按钮
@property (nonatomic, strong) UIButton *showEnvironmentBtn;//环境展示图按钮

@property (nonatomic, strong) UIButton *mapBtn;

@end
