//
//  TodayIncomeCell.h
//  ATNShop
//
//  Created by 王赛 on 16/10/10.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TodayIncomeModel;
@interface TodayIncomeCell : UITableViewCell

@property (nonatomic, strong) UILabel *dayLabel;//日期
@property (nonatomic, strong) UILabel *weekLabel;//周几
@property (nonatomic, strong) UIImageView *posterImageView;//图片

@property (nonatomic, strong) UILabel *moneyLabel;//金额
@property (nonatomic, strong) UILabel *timeLabel;//具体时间

@property (nonatomic ,strong) TodayIncomeModel *incomemodel;

@end
