//
//  SubcribeShopViewCell.h
//  @你
//
//  Created by 吴明飞 on 16/5/16.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubscribeModel;
@interface SubcribeShopViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *dayLabel;//日期
@property (nonatomic, strong) UILabel *weekLabel;//周几
@property (nonatomic, strong) UIImageView *posterImageView;//图片
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UILabel *nameLabel;//名称
@property (nonatomic, strong) UILabel *timeLabel;//具体时间
@property (nonatomic, strong) SubscribeModel *model;

@end
