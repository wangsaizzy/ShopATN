//
//  ShopInformationView.h
//  @的你
//
//  Created by 吴明飞 on 16/3/30.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"
@interface ShopInformationView : UIView
@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) UIView *secondView;
//@property (nonatomic, strong) UIView *thirdView;
//@property (nonatomic, strong) UIView *fouthView;

@property (nonatomic, strong) UIImageView *shopHeadImageView;//商铺头像
@property (nonatomic, strong) UIImageView *publicizeImageView;//列表展示图
@property (nonatomic, strong) UIButton *headImageViewBtn;//头像选择按钮
@property (nonatomic, strong) UIButton *publicizeImageBtn;//宣传图选择按钮
@property (nonatomic, strong) UITextField *shopNameTF;//店铺名称
@property (nonatomic, strong) PlaceholderTextView *detailAddressTV;//详细地址
@property (nonatomic, strong) PlaceholderTextView *descriptionTV;//店铺描述
@property (nonatomic, strong) UITextField *discountTF;//折扣
@property (nonatomic, strong) UITextField *phoneTF;//电话
@property (nonatomic, strong) PlaceholderTextView *popularizeTV;//推广用语

@property (nonatomic, strong) UIButton *mapBtn;

@end
