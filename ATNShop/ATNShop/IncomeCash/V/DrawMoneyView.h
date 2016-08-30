//
//  DrawMoneyView.h
//  @的你
//
//  Created by 吴明飞 on 16/3/28.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawMoneyView : UIView
@property (nonatomic, strong) UILabel *cashLabel;
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UIButton *bingdingBtn;
@property (nonatomic, strong) UIImageView *directFirstImage;
@property (nonatomic, strong) UIImageView *directApplyFirstImage;
@property (nonatomic, strong) UIImageView *directHistorySecondImage;
@property (nonatomic, strong) UILabel *bangDingLabel;
@property (nonatomic, strong) UIButton *accountBtn;

@property (nonatomic, strong) UIButton *historyCashBtn;
@property (nonatomic, strong) UIButton *applyCashBtn;
@end
